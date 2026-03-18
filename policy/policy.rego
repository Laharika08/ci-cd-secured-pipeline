package kubernetes.admission

deny[msg] if {
  input.kind == "Deployment"
  container := input.spec.template.spec.containers[_]
  not container.resources.limits

  msg := "Container must have resource limits defined"
}

deny[msg] if {
  input.kind == "Deployment"
  container := input.spec.template.spec.containers[_]
  container.image == "latest"

  msg := "Using latest tag is not allowed"
}

deny[msg] if {
  input.kind == "Deployment"
  container := input.spec.template.spec.containers[_]
  not container.securityContext.runAsNonRoot

  msg := "Container must not run as root"
}
