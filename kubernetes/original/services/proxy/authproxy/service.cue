package kube

service: authproxy: {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		name: "authproxy"
		labels: {
			app:    "authproxy"
			domain: "prod"
		}
	}
	spec: {
		ports: [{
			port:       4180
			protocol:   "TCP"
			targetPort: 4180
			name:       "client"
		}]
		selector: app: "authproxy"
	}
}
