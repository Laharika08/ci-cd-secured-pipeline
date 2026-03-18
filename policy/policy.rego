package main

deny contains msg if {
  input.kind == "Deployment"
  container := input.spec.template.spec.containers[_]
  endswith(container.image, ":latest")

  msg := sprintf("Container image %s uses latest tag", [container.image])
}
