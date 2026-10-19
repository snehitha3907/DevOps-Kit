// last_verified: 2026-10-19 · Prometheus n/a
// Purpose: reusable Go custom Collector that exposes application metrics via client_golang,
// registered with the default registry and served on a real /metrics endpoint.
// When to use: when built-in collectors (Go runtime, process) are not enough and you need
// domain-specific gauges/counters/histograms driven by your own data source.
// Prerequisites: Go toolchain; module with github.com/prometheus/client_golang dependency.
// Usage: go run custom-app-metrics-collector.go, then curl http://localhost:2112/metrics.
// Verify: the /metrics response contains the registered metric families and a scrape succeeds.
// Common errors: forgetting to register the collector (no data series); panicking in Collect
// (crashes the scrape handler); blocking Collect on slow I/O (scrape timeouts).

package main

import (
	"fmt"
	"log"
	"math/rand"
	"net/http"
	"time"

	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

// appCollector implements prometheus.Collector by gathering values on each scrape.
type appCollector struct {
	uptime prometheus.Gauge
	jobs   *prometheus.GaugeVec
}

func newAppCollector() *appCollector {
	return &appCollector{
		uptime: prometheus.NewGauge(prometheus.GaugeOpts{
			Name: "app_uptime_seconds",
			Help: "Seconds since the application process started.",
		}),
		jobs: prometheus.NewGaugeVec(prometheus.GaugeOpts{
			Name: "app_background_jobs",
			Help: "Number of background jobs currently in flight, by queue.",
		}, []string{"queue"}),
	}
}

func (c *appCollector) Describe(ch chan<- *prometheus.Desc) {
	ch <- c.uptime.Desc()
	c.jobs.Describe(ch)
}

func (c *appCollector) Collect(ch chan<- prometheus.Metric) {
	c.uptime.Set(time.Since(startTime).Seconds())
	ch <- c.uptime

	for _, q := range []string{"default", "priority"} {
		c.jobs.WithLabelValues(q).Set(float64(rand.Intn(10)))
	}
	c.jobs.Collect(ch)
}

var startTime = time.Now()

func main() {
	collector := newAppCollector()
	if err := prometheus.Register(collector); err != nil {
		log.Fatalf("register collector: %v", err)
	}

	http.Handle("/metrics", promhttp.Handler())
	addr := ":2112"
	fmt.Printf("serving metrics on %s/metrics\n", addr)
	if err := http.ListenAndServe(addr, nil); err != nil {
		log.Fatalf("serve: %v", err)
	}
}
