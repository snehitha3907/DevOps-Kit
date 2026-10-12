// last_verified: 2026-10-12 · controller-runtime 0.18.4
package v1alpha1

import (
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

// WebAppSpec defines the desired state of WebApp
type WebAppSpec struct {
	// Replicas is the desired number of replicas for the web application
	// +optional
	Replicas *int32 `json:"replicas,omitempty"`

	// Image is the container image to run for the web application
	Image string `json:"image"`

	// Port is the port the web application listens on
	// +optional
	Port int32 `json:"port,omitempty"`

	// Resources defines the resource requirements for the web application pods
	// +optional
	Resources *ResourceRequirements `json:"resources,omitempty"`

	// EnvVars defines environment variables for the web application
	// +optional
	EnvVars []EnvVar `json:"envVars,omitempty"`

	// ServiceType defines the type of Service to create
	// +optional
	ServiceType string `json:"serviceType,omitempty"`

	// IngressEnabled enables ingress for the web application
	// +optional
	IngressEnabled bool `json:"ingressEnabled,omitempty"`

	// IngressHost is the hostname for the ingress
	// +optional
	IngressHost string `json:"ingressHost,omitempty"`
}

// ResourceRequirements defines the resource requirements for containers
type ResourceRequirements struct {
	// Limits describes the maximum amount of compute resources allowed
	// +optional
	Limits map[string]string `json:"limits,omitempty"`

	// Requests describes the minimum amount of compute resources required
	// +optional
	Requests map[string]string `json:"requests,omitempty"`
}

// EnvVar represents an environment variable
type EnvVar struct {
	// Name is the name of the environment variable
	Name string `json:"name"`

	// Value is the value of the environment variable
	Value string `json:"value"`
}

// WebAppStatus defines the observed state of WebApp
type WebAppStatus struct {
	// Replicas is the current number of replicas
	Replicas int32 `json:"replicas"`

	// ReadyReplicas is the number of ready replicas
	ReadyReplicas int32 `json:"readyReplicas"`

	// AvailableReplicas is the number of available replicas
	AvailableReplicas int32 `json:"availableReplicas"`

	// Conditions represent the latest available observations of the WebApp's state
	// +optional
	Conditions []metav1.Condition `json:"conditions,omitempty"`

	// ServiceName is the name of the Service created for the web application
	// +optional
	ServiceName string `json:"serviceName,omitempty"`

	// IngressName is the name of the Ingress created for the web application
	// +optional
	IngressName string `json:"ingressName,omitempty"`
}

//+kubebuilder:object:root=true
//+kubebuilder:subresource:status
//+kubebuilder:printcolumn:name="Replicas",type="integer",JSONPath=".spec.replicas",description="Desired replicas"
//+kubebuilder:printcolumn:name="Ready",type="integer",JSONPath=".status.readyReplicas",description="Ready replicas"
//+kubebuilder:printcolumn:name="Image",type="string",JSONPath=".spec.image",description="Container image"
//+kubebuilder:printcolumn:name="Age",type="date",JSONPath=".metadata.creationTimestamp"

// WebApp is the Schema for the webapps API
type WebApp struct {
	metav1.TypeMeta   `json:",inline"`
	metav1.ObjectMeta `json:"metadata,omitempty"`

	Spec   WebAppSpec   `json:"spec,omitempty"`
	Status WebAppStatus `json:"status,omitempty"`
}

//+kubebuilder:object:root=true

// WebAppList contains a list of WebApp
type WebAppList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty"`
	Items           []WebApp `json:"items"`
}

func init() {
	SchemeBuilder.Register(&WebApp{}, &WebAppList{})
}