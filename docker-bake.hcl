target "docker-metadata-action" {}

target "default" {
  inherits = [ "docker-metadata-action" ]

  attest = [
    "type=provenance,mode=max",
    "type=sbom",
  ]
  cache-from = ["type=registry,ref=ghcr.io/axolotlcloud/cups-avahi-airprint:latest"]
  cache-to = ["type=inline"]
  context = "."
  dockerfile = "Dockerfile"
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["ghcr.io/axolotlcloud/cups-avahi-airprint:latest"]
}
