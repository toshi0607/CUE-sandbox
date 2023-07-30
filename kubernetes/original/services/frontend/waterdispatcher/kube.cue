package kube

service: waterdispatcher: {
	apiVersion: "v1"
	kind:       "Service"
	// Our metadata
	metadata: {
		name: "waterdispatcher"
		labels: {
			app:       "waterdispatcher"
			domain:    "prod"
			component: "frontend"
		}
	}
	spec: {
		ports: [{
			port:       7080
			targetPort: 7080
			protocol:   "TCP"
			name:       "http"
		}]
		selector: {
			app:       "waterdispatcher"
			domain:    "prod"
			component: "frontend"
		}
	}
}
deployment: waterdispatcher: {
	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata: name: "waterdispatcher"
	spec: {
		replicas: 1
		template: {
			metadata: {
				annotations: {
					"prometheus.io.scrape": "true"
					"prometheus.io.port":   "7080"
				}
				labels: {
					// Important: these labels need to match the selector above
					// The api server enforces this constraint.
					app:       "waterdispatcher"
					domain:    "prod"
					component: "frontend"
				}
			}
			spec: containers: [{
				image: "gcr.io/myproj/waterdispatcher:v0.0.48"
				ports: [{
					containerPort: 7080
				}]
				name: "waterdispatcher"
				args: [
					"-http=:8080",
					"-etcd=etcd:2379",
				]
			}]
		}
	}
}
