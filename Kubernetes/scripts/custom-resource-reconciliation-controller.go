// last_verified: 2026-10-13 · Kubernetes n/a
// Purpose: reusable reconciliation core for a namespaced custom resource.
// When to use: backing a small operator where each custom resource declares
// desired state (replicas, image, config) and the controller converges the
// observed state toward it with idempotent applies and finalizer cleanup.
// Prerequisites: none beyond the standard library; the Store interface adapts
// this core to a live cluster client or a test fake.
// Usage: implement Store (Get/Apply/Delete), construct a Reconciler, and call
// Reconcile on each watch event or resync tick. See main for a runnable demo.
// Verify: run the demo (go run) and confirm steady-state converges with no
// further applies, deletion honours the finalizer, and invalid desired state
// surfaces a non-retryable error. Common errors: returning Requeue on
// terminal validation failures (hot loop); applying before finalizer is set
// (orphaned externals on delete); treating every update error as retryable
// instead of backing off only on conflicts and transient failures.

package main

import (
	"errors"
	"fmt"
	"log"
	"maps"
	"time"
)

// Desired captures what the custom resource asks for.
type Desired struct {
	Name     string
	Replicas int32
	Image    string
	Config   map[string]string
}

// Observed captures what currently exists for the resource.
type Observed struct {
	Exists     bool
	Deleting   bool
	Replicas   int32
	Image      string
	Config     map[string]string
	Finalizers []string
}

// Outcome tells the caller what to do after a reconcile pass.
type Outcome struct {
	Requeue      bool
	RequeueAfter time.Duration
}

// Store abstracts persistence so the core stays testable without a cluster.
type Store interface {
	Get(name string) (Observed, error)
	EnsureFinalizer(name, finalizer string) error
	RemoveFinalizer(name, finalizer string) error
	Apply(desired Desired) (changed bool, err error)
	Delete(name string) error
}

// Reconciler holds operator policy: finalizer name and retry behaviour.
type Reconciler struct {
	Finalizer  string
	MaxBackoff time.Duration
}

// ErrInvalidDesired marks terminal input errors that must not be retried.
var ErrInvalidDesired = errors.New("invalid desired state")

// ErrConflict marks transient write conflicts worth one requeue.
var ErrConflict = errors.New("update conflict")

func validate(d Desired) error {
	if d.Name == "" {
		return fmt.Errorf("%w: name is empty", ErrInvalidDesired)
	}
	if d.Replicas < 0 {
		return fmt.Errorf("%w: replicas must be >= 0", ErrInvalidDesired)
	}
	if d.Image == "" {
		return fmt.Errorf("%w: image is empty", ErrInvalidDesired)
	}
	return nil
}

func contains(list []string, s string) bool {
	for _, v := range list {
		if v == s {
			return true
		}
	}
	return false
}

func drifted(d Desired, o Observed) bool {
	return o.Replicas != d.Replicas || o.Image != d.Image || !maps.Equal(o.Config, d.Config)
}

// Reconcile converges one resource toward desired state. It is level-driven:
// repeated calls with the same input settle instead of duplicating work.
func (r Reconciler) Reconcile(store Store, desired Desired) (Outcome, error) {
	if err := validate(desired); err != nil {
		return Outcome{}, err
	}
	observed, err := store.Get(desired.Name)
	if err != nil {
		return Outcome{Requeue: true}, fmt.Errorf("get %s: %w", desired.Name, err)
	}
	// Deletion path: release external state first, then drop the finalizer.
	if observed.Deleting {
		if contains(observed.Finalizers, r.Finalizer) {
			if err := store.Delete(desired.Name); err != nil {
				if errors.Is(err, ErrConflict) {
					return Outcome{Requeue: true, RequeueAfter: time.Second}, nil
				}
				return Outcome{Requeue: true}, fmt.Errorf("delete %s: %w", desired.Name, err)
			}
			if err := store.RemoveFinalizer(desired.Name, r.Finalizer); err != nil {
				return Outcome{Requeue: true}, fmt.Errorf("remove finalizer: %w", err)
			}
		}
		return Outcome{}, nil
	}
	// Normal path: finalizer first so deletes are never missed.
	if !contains(observed.Finalizers, r.Finalizer) {
		if err := store.EnsureFinalizer(desired.Name, r.Finalizer); err != nil {
			return Outcome{Requeue: true}, fmt.Errorf("ensure finalizer: %w", err)
		}
		return Outcome{Requeue: true}, nil
	}
	if !observed.Exists || drifted(desired, observed) {
		changed, err := store.Apply(desired)
		if err != nil {
			if errors.Is(err, ErrConflict) {
				backoff := minDuration(r.MaxBackoff, 5*time.Second)
				return Outcome{Requeue: true, RequeueAfter: backoff}, nil
			}
			return Outcome{Requeue: true}, fmt.Errorf("apply %s: %w", desired.Name, err)
		}
		if changed {
			// One requeue lets the next pass confirm steady state.
			return Outcome{Requeue: true}, nil
		}
	}
	return Outcome{}, nil
}

func minDuration(a, b time.Duration) time.Duration {
	if a <= 0 {
		return b
	}
	if a < b {
		return a
	}
	return b
}

// memoryStore is an in-process Store used by the demo and unit tests.
type memoryStore struct {
	objects map[string]Observed
	desired map[string]Desired
}

func newMemoryStore() *memoryStore {
	return &memoryStore{objects: map[string]Observed{}, desired: map[string]Desired{}}
}

func (m *memoryStore) Get(name string) (Observed, error) {
	o, ok := m.objects[name]
	if !ok {
		return Observed{}, nil
	}
	return o, nil
}

func (m *memoryStore) EnsureFinalizer(name, finalizer string) error {
	o := m.objects[name]
	if !contains(o.Finalizers, finalizer) {
		o.Finalizers = append(o.Finalizers, finalizer)
		m.objects[name] = o
	}
	return nil
}

func (m *memoryStore) RemoveFinalizer(name, finalizer string) error {
	o := m.objects[name]
	kept := o.Finalizers[:0]
	for _, f := range o.Finalizers {
		if f != finalizer {
			kept = append(kept, f)
		}
	}
	o.Finalizers = kept
	if o.Deleting {
		delete(m.objects, name)
		return nil
	}
	m.objects[name] = o
	return nil
}

func (m *memoryStore) Apply(desired Desired) (bool, error) {
	o := m.objects[desired.Name]
	next := Observed{
		Exists:     true,
		Replicas:   desired.Replicas,
		Image:      desired.Image,
		Config:     maps.Clone(desired.Config),
		Finalizers: o.Finalizers,
	}
	if o.Exists && !drifted(desired, o) {
		return false, nil
	}
	m.objects[desired.Name] = next
	return true, nil
}

func (m *memoryStore) Delete(name string) error {
	o, ok := m.objects[name]
	if !ok {
		return nil
	}
	o.Exists = false
	m.objects[name] = o
	return nil
}

func main() {
	store := newMemoryStore()
	r := Reconciler{Finalizer: "example.io/cleanup", MaxBackoff: 5 * time.Second}
	desired := Desired{Name: "webapp-sample", Replicas: 3, Image: "example-registry/webapp:latest", Config: map[string]string{"mode": "prod"}}

	for i := 0; i < 3; i++ {
		outcome, err := r.Reconcile(store, desired)
		if err != nil {
			log.Fatalf("reconcile: %v", err)
		}
		fmt.Printf("pass %d: requeue=%v after=%s\n", i+1, outcome.Requeue, outcome.RequeueAfter)
		if !outcome.Requeue {
			break
		}
	}
	final, _ := store.Get(desired.Name)
	fmt.Printf("steady state: replicas=%d image=%s finalizers=%v\n", final.Replicas, final.Image, final.Finalizers)
}
