// last_verified: 2026-10-12 · controller-runtime 0.18.4
package controllers

import (
	"context"
	"fmt"
	"reflect"

	appsv1 "k8s.io/api/apps/v1"
	corev1 "k8s.io/api/core/v1"
	networkingv1 "k8s.io/api/networking/v1"
	"k8s.io/apimachinery/pkg/api/errors"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/runtime"
	"k8s.io/apimachinery/pkg/types"
	"k8s.io/apimachinery/pkg/util/intstr"
	"k8s.io/apimachinery/pkg/api/resource"
	ctrl "sigs.k8s.io/controller-runtime"
	"sigs.k8s.io/controller-runtime/pkg/client"
	"sigs.k8s.io/controller-runtime/pkg/controller/controllerutil"
	"sigs.k8s.io/controller-runtime/pkg/log"

	appsv1alpha1 "github.com/example/webapp-operator/api/v1alpha1"
)

// WebAppReconciler reconciles a WebApp object
type WebAppReconciler struct {
	client.Client
	Scheme *runtime.Scheme
}

//+kubebuilder:rbac:groups=apps.example.org,resources=webapps,verbs=get;list;watch;create;update;patch;delete
//+kubebuilder:rbac:groups=apps.example.org,resources=webapps/status,verbs=get;update;patch
//+kubebuilder:rbac:groups=apps.example.org,resources=webapps/finalizers,verbs=update
//+kubebuilder:rbac:groups=apps,resources=deployments,verbs=get;list;watch;create;update;patch;delete
//+kubebuilder:rbac:groups=apps,resources=deployments/status,verbs=get;update;patch
//+kubebuilder:rbac:groups=core,resources=services,verbs=get;list;watch;create;update;patch;delete
//+kubebuilder:rbac:groups=networking.k8s.io,resources=ingresses,verbs=get;list;watch;create;update;patch;delete

// Reconcile is part of the main kubernetes reconciliation loop which aims to
// move the current state of the cluster closer to the desired state.
func (r *WebAppReconciler) Reconcile(ctx context.Context, req ctrl.Request) (ctrl.Result, error) {
	logger := log.FromContext(ctx)

	// Fetch the WebApp instance
	webApp := &appsv1alpha1.WebApp{}
	if err := r.Get(ctx, req.NamespacedName, webApp); err != nil {
		if errors.IsNotFound(err) {
			logger.Info("WebApp resource not found. Ignoring since object must be deleted")
			return ctrl.Result{}, nil
		}
		logger.Error(err, "Failed to get WebApp")
		return ctrl.Result{}, err
	}

	// Initialize status if needed
	if webApp.Status.Conditions == nil {
		webApp.Status.Conditions = []metav1.Condition{}
	}

	// Set default values
	r.setDefaults(webApp)

	// Reconcile Deployment
	if err := r.reconcileDeployment(ctx, webApp); err != nil {
		logger.Error(err, "Failed to reconcile Deployment")
		r.updateCondition(webApp, "DeploymentReady", metav1.ConditionFalse, "DeploymentFailed", err.Error())
		return ctrl.Result{}, err
	}

	// Reconcile Service
	if err := r.reconcileService(ctx, webApp); err != nil {
		logger.Error(err, "Failed to reconcile Service")
		r.updateCondition(webApp, "ServiceReady", metav1.ConditionFalse, "ServiceFailed", err.Error())
		return ctrl.Result{}, err
	}

	// Reconcile Ingress if enabled
	if webApp.Spec.IngressEnabled {
		if err := r.reconcileIngress(ctx, webApp); err != nil {
			logger.Error(err, "Failed to reconcile Ingress")
			r.updateCondition(webApp, "IngressReady", metav1.ConditionFalse, "IngressFailed", err.Error())
			return ctrl.Result{}, err
		}
		r.updateCondition(webApp, "IngressReady", metav1.ConditionTrue, "IngressCreated", "Ingress successfully created")
	} else {
		// Delete Ingress if it exists but no longer enabled
		if err := r.deleteIngress(ctx, webApp); err != nil {
			logger.Error(err, "Failed to delete Ingress")
			return ctrl.Result{}, err
		}
	}

	// Update status from Deployment
	if err := r.updateStatus(ctx, webApp); err != nil {
		logger.Error(err, "Failed to update status")
		return ctrl.Result{}, err
	}

	r.updateCondition(webApp, "DeploymentReady", metav1.ConditionTrue, "DeploymentReady", "Deployment is ready")
	r.updateCondition(webApp, "ServiceReady", metav1.ConditionTrue, "ServiceCreated", "Service successfully created")

	return ctrl.Result{}, nil
}

// setDefaults sets default values for the WebApp spec
func (r *WebAppReconciler) setDefaults(webApp *appsv1alpha1.WebApp) {
	if webApp.Spec.Replicas == nil {
		replicas := int32(1)
		webApp.Spec.Replicas = &replicas
	}
	if webApp.Spec.Port == 0 {
		webApp.Spec.Port = 8080
	}
	if webApp.Spec.ServiceType == "" {
		webApp.Spec.ServiceType = "ClusterIP"
	}
}

// reconcileDeployment creates or updates the Deployment for the WebApp
func (r *WebAppReconciler) reconcileDeployment(ctx context.Context, webApp *appsv1alpha1.WebApp) error {
	logger := log.FromContext(ctx)

	deployment := r.buildDeployment(webApp)

	// Set WebApp instance as the owner and controller
	if err := controllerutil.SetControllerReference(webApp, deployment, r.Scheme); err != nil {
		return err
	}

	// Check if Deployment already exists
	found := &appsv1.Deployment{}
	err := r.Get(ctx, types.NamespacedName{Name: deployment.Name, Namespace: deployment.Namespace}, found)
	if err != nil && errors.IsNotFound(err) {
		logger.Info("Creating a new Deployment", "Deployment.Namespace", deployment.Namespace, "Deployment.Name", deployment.Name)
		return r.Create(ctx, deployment)
	} else if err != nil {
		return err
	}

	// Update the found Deployment if spec has changed
	if !reflect.DeepEqual(found.Spec, deployment.Spec) {
		logger.Info("Updating Deployment", "Deployment.Namespace", deployment.Namespace, "Deployment.Name", deployment.Name)
		found.Spec = deployment.Spec
		return r.Update(ctx, found)
	}

	return nil
}

// buildDeployment constructs a Deployment object for the WebApp
func (r *WebAppReconciler) buildDeployment(webApp *appsv1alpha1.WebApp) *appsv1.Deployment {
	labels := map[string]string{
		"app":       webApp.Name,
		"managed-by": "webapp-operator",
	}

	envVars := []corev1.EnvVar{}
	for _, env := range webApp.Spec.EnvVars {
		envVars = append(envVars, corev1.EnvVar{
			Name:  env.Name,
			Value: env.Value,
		})
	}

	// Add default env vars
	envVars = append(envVars, corev1.EnvVar{
		Name:  "PORT",
		Value: fmt.Sprintf("%d", webApp.Spec.Port),
	})

	resources := corev1.ResourceRequirements{}
	if webApp.Spec.Resources != nil {
		if webApp.Spec.Resources.Limits != nil {
			resources.Limits = make(corev1.ResourceList)
			for k, v := range webApp.Spec.Resources.Limits {
				resources.Limits[corev1.ResourceName(k)] = resource.MustParse(v)
			}
		}
		if webApp.Spec.Resources.Requests != nil {
			resources.Requests = make(corev1.ResourceList)
			for k, v := range webApp.Spec.Resources.Requests {
				resources.Requests[corev1.ResourceName(k)] = resource.MustParse(v)
			}
		}
	}

	return &appsv1.Deployment{
		ObjectMeta: metav1.ObjectMeta{
			Name:      webApp.Name,
			Namespace: webApp.Namespace,
			Labels:    labels,
		},
		Spec: appsv1.DeploymentSpec{
			Replicas: webApp.Spec.Replicas,
			Selector: &metav1.LabelSelector{
				MatchLabels: labels,
			},
			Template: corev1.PodTemplateSpec{
				ObjectMeta: metav1.ObjectMeta{
					Labels: labels,
				},
				Spec: corev1.PodSpec{
					Containers: []corev1.Container{
						{
							Name:            webApp.Name,
							Image:           webApp.Spec.Image,
							Ports:           []corev1.ContainerPort{{ContainerPort: webApp.Spec.Port}},
							Env:             envVars,
							Resources:       resources,
							ImagePullPolicy: corev1.PullIfNotPresent,
							ReadinessProbe: &corev1.Probe{
								ProbeHandler: corev1.ProbeHandler{
									HTTPGet: &corev1.HTTPGetAction{
										Path: "/health",
										Port: intstr.FromInt32(webApp.Spec.Port),
									},
								},
								InitialDelaySeconds: 5,
								PeriodSeconds:       10,
							},
							LivenessProbe: &corev1.Probe{
								ProbeHandler: corev1.ProbeHandler{
									HTTPGet: &corev1.HTTPGetAction{
										Path: "/health",
										Port: intstr.FromInt32(webApp.Spec.Port),
									},
								},
								InitialDelaySeconds: 15,
								PeriodSeconds:       20,
							},
						},
					},
				},
			},
		},
	}
}

// reconcileService creates or updates the Service for the WebApp
func (r *WebAppReconciler) reconcileService(ctx context.Context, webApp *appsv1alpha1.WebApp) error {
	logger := log.FromContext(ctx)

	service := r.buildService(webApp)

	// Set WebApp instance as the owner and controller
	if err := controllerutil.SetControllerReference(webApp, service, r.Scheme); err != nil {
		return err
	}

	// Check if Service already exists
	found := &corev1.Service{}
	err := r.Get(ctx, types.NamespacedName{Name: service.Name, Namespace: service.Namespace}, found)
	if err != nil && errors.IsNotFound(err) {
		logger.Info("Creating a new Service", "Service.Namespace", service.Namespace, "Service.Name", service.Name)
		return r.Create(ctx, service)
	} else if err != nil {
		return err
	}

	// Update the found Service if spec has changed (only mutable fields)
	if found.Spec.Type != service.Spec.Type || !reflect.DeepEqual(found.Spec.Ports, service.Spec.Ports) || !reflect.DeepEqual(found.Spec.Selector, service.Spec.Selector) {
		logger.Info("Updating Service", "Service.Namespace", service.Namespace, "Service.Name", service.Name)
		found.Spec.Type = service.Spec.Type
		found.Spec.Ports = service.Spec.Ports
		found.Spec.Selector = service.Spec.Selector
		return r.Update(ctx, found)
	}

	webApp.Status.ServiceName = service.Name
	return nil
}

// buildService constructs a Service object for the WebApp
func (r *WebAppReconciler) buildService(webApp *appsv1alpha1.WebApp) *corev1.Service {
	labels := map[string]string{
		"app":       webApp.Name,
		"managed-by": "webapp-operator",
	}

	serviceType := corev1.ServiceType(webApp.Spec.ServiceType)
	if serviceType == "" {
		serviceType = corev1.ServiceTypeClusterIP
	}

	return &corev1.Service{
		ObjectMeta: metav1.ObjectMeta{
			Name:      webApp.Name,
			Namespace: webApp.Namespace,
			Labels:    labels,
		},
		Spec: corev1.ServiceSpec{
			Type: serviceType,
			Ports: []corev1.ServicePort{
				{
					Port:       webApp.Spec.Port,
					TargetPort: intstr.FromInt32(webApp.Spec.Port),
					Protocol:   corev1.ProtocolTCP,
					Name:       "http",
				},
			},
			Selector: labels,
		},
	}
}

// reconcileIngress creates or updates the Ingress for the WebApp
func (r *WebAppReconciler) reconcileIngress(ctx context.Context, webApp *appsv1alpha1.WebApp) error {
	logger := log.FromContext(ctx)

	if webApp.Spec.IngressHost == "" {
		return fmt.Errorf("ingressHost is required when IngressEnabled is true")
	}

	ingress := r.buildIngress(webApp)

	// Set WebApp instance as the owner and controller
	if err := controllerutil.SetControllerReference(webApp, ingress, r.Scheme); err != nil {
		return err
	}

	// Check if Ingress already exists
	found := &networkingv1.Ingress{}
	err := r.Get(ctx, types.NamespacedName{Name: ingress.Name, Namespace: ingress.Namespace}, found)
	if err != nil && errors.IsNotFound(err) {
		logger.Info("Creating a new Ingress", "Ingress.Namespace", ingress.Namespace, "Ingress.Name", ingress.Name)
		return r.Create(ctx, ingress)
	} else if err != nil {
		return err
	}

	// Update the found Ingress if spec has changed
	if !reflect.DeepEqual(found.Spec, ingress.Spec) {
		logger.Info("Updating Ingress", "Ingress.Namespace", ingress.Namespace, "Ingress.Name", ingress.Name)
		found.Spec = ingress.Spec
		return r.Update(ctx, found)
	}

	webApp.Status.IngressName = ingress.Name
	return nil
}

// buildIngress constructs an Ingress object for the WebApp
func (r *WebAppReconciler) buildIngress(webApp *appsv1alpha1.WebApp) *networkingv1.Ingress {
	labels := map[string]string{
		"app":       webApp.Name,
		"managed-by": "webapp-operator",
	}

	pathType := networkingv1.PathTypePrefix
	return &networkingv1.Ingress{
		ObjectMeta: metav1.ObjectMeta{
			Name:      webApp.Name,
			Namespace: webApp.Namespace,
			Labels:    labels,
			Annotations: map[string]string{
				"nginx.ingress.kubernetes.io/rewrite-target": "/",
			},
		},
		Spec: networkingv1.IngressSpec{
			Rules: []networkingv1.IngressRule{
				{
					Host: webApp.Spec.IngressHost,
					IngressRuleValue: networkingv1.IngressRuleValue{
						HTTP: &networkingv1.HTTPIngressRuleValue{
							Paths: []networkingv1.HTTPIngressPath{
								{
									Path:     "/",
									PathType: &pathType,
									Backend: networkingv1.IngressBackend{
										Service: &networkingv1.IngressServiceBackend{
											Name: webApp.Name,
											Port: networkingv1.ServiceBackendPort{
												Number: webApp.Spec.Port,
											},
										},
									},
								},
							},
						},
					},
				},
			},
		},
	}
}

// deleteIngress deletes the Ingress if it exists
func (r *WebAppReconciler) deleteIngress(ctx context.Context, webApp *appsv1alpha1.WebApp) error {
	ingress := &networkingv1.Ingress{
		ObjectMeta: metav1.ObjectMeta{
			Name:      webApp.Name,
			Namespace: webApp.Namespace,
		},
	}
	if err := r.Delete(ctx, ingress); err != nil && !errors.IsNotFound(err) {
		return err
	}
	webApp.Status.IngressName = ""
	return nil
}

// updateStatus updates the WebApp status from the Deployment
func (r *WebAppReconciler) updateStatus(ctx context.Context, webApp *appsv1alpha1.WebApp) error {
	deployment := &appsv1.Deployment{}
	err := r.Get(ctx, types.NamespacedName{Name: webApp.Name, Namespace: webApp.Namespace}, deployment)
	if err != nil {
		if errors.IsNotFound(err) {
			webApp.Status.Replicas = 0
			webApp.Status.ReadyReplicas = 0
			webApp.Status.AvailableReplicas = 0
			return nil
		}
		return err
	}

	webApp.Status.Replicas = deployment.Status.Replicas
	webApp.Status.ReadyReplicas = deployment.Status.ReadyReplicas
	webApp.Status.AvailableReplicas = deployment.Status.AvailableReplicas

	return r.Status().Update(ctx, webApp)
}

// updateCondition updates a condition in the WebApp status
func (r *WebAppReconciler) updateCondition(webApp *appsv1alpha1.WebApp, conditionType string, status metav1.ConditionStatus, reason, message string) {
	condition := metav1.Condition{
		Type:    conditionType,
		Status:  status,
		Reason:  reason,
		Message: message,
	}

	// Find existing condition
	for i, c := range webApp.Status.Conditions {
		if c.Type == conditionType {
			if c.Status != status || c.Reason != reason || c.Message != message {
				condition.LastTransitionTime = metav1.Now()
				webApp.Status.Conditions[i] = condition
			}
			return
		}
	}

	// Add new condition
	condition.LastTransitionTime = metav1.Now()
	condition.ObservedGeneration = webApp.Generation
	webApp.Status.Conditions = append(webApp.Status.Conditions, condition)
}

// SetupWithManager sets up the controller with the Manager.
func (r *WebAppReconciler) SetupWithManager(mgr ctrl.Manager) error {
	return ctrl.NewControllerManagedBy(mgr).
		For(&appsv1alpha1.WebApp{}).
		Owns(&appsv1.Deployment{}).
		Owns(&corev1.Service{}).
		Owns(&networkingv1.Ingress{}).
		Complete(r)
}