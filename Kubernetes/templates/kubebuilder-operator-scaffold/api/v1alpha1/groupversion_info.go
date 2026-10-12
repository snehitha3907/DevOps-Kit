// last_verified: 2026-10-12 · controller-runtime 0.18.4
package v1alpha1

import (
	"k8s.io/apimachinery/pkg/runtime"
	"k8s.io/apimachinery/pkg/runtime/schema"
	"k8s.io/apimachinery/pkg/apis/meta/v1"
)

// GroupVersion is the identifier for the API group and version
var GroupVersion = schema.GroupVersion{Group: "apps.example.org", Version: "v1alpha1"}

// SchemeBuilder is used to add types to the scheme
var SchemeBuilder = runtime.NewSchemeBuilder(addKnownTypes)

// AddToScheme adds the types to the scheme
func AddToScheme(scheme *runtime.Scheme) error {
	return SchemeBuilder.AddToScheme(scheme)
}

// addKnownTypes adds the types to the scheme
func addKnownTypes(scheme *runtime.Scheme) error {
	scheme.AddKnownTypes(GroupVersion,
		&WebApp{},
		&WebAppList{},
	)
	v1.AddToGroupVersion(scheme, GroupVersion)
	return nil
}