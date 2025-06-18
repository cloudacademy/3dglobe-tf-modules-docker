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

# Pulls the image
resource "docker_image" "microservices" {
  for_each = var.microservices

  name = each.value.image

  # lifecycle {
  #   prevent_destroy = true
  # }
}

# Create a container
# resource "docker_container" "globe_api" {
#   image = "cloudacademydevops/3d-globe-api-v2"
#   name  = "3d-globe-api-v2"
#   ports {
#     internal = 9090
#     external = 9090
#   }

#   labels {
#     label = "label1"docker_image.globe_api
#     value = "val1"
#   }

#   labels {
#     label = "label2"
#     value = "val2"
#   }
# }

# resource "docker_container" "globe_web" {
#   image = "cloudacademydevops/3d-globe-web"
#   name  = "3d-globe-web"
#   ports {
#     internal = 80
#     external = 8080
#   }
#   env = [
#     "GLOBE_API_HOSTPORT=localhost:9090"
#   ]

#   labels {
#     label = "label1"
#     value = "val1"
#   }

#   labels {
#     label = "label2"
#     value = "val2"
#   }
# }

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
