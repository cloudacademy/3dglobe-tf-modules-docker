terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

#LOCALS
#================================

locals {
  microservice_ports = {
    for svc_key, svc in var.microservices :
    svc.name => tonumber(split(":", svc.ports[0])[0])
  }
}

#MICROSERVICES
#================================

resource "docker_image" "microservices" {
  for_each = var.microservices

  name = each.value.image

  # lifecycle {
  #   prevent_destroy = true
  # }
}

resource "docker_container" "microservices" {
  for_each = var.microservices

  name  = each.value.name
  image = each.value.image

  ports {
    external = tonumber(split(":", each.value.ports[0])[0])
    internal = tonumber(split(":", each.value.ports[0])[1])
  }

  env = each.value.env != null ? each.value.env : []

  dynamic "labels" {
    for_each = try(merge(each.value.tags != null ? each.value.tags : {}, var.tags), {})
    content {
      label = labels.key
      value = labels.value
    }
  }

  depends_on = [
    docker_image.microservices
  ]
}
