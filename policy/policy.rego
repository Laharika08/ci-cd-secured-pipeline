package kubernetes.admission

deny[msg] if {
  input.kind == "Deployment"
  container := input.spec.template.spec.containers[_]
  endswith(container.image, ":latest")

  msg := sprintf("Container image %s uses the disallowed latest tag.", [container.image])
}
