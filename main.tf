terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.6"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

module "microservices" {
  source = "./modules/microservices"

  microservices = {
    globe_web = {
      name  = "3d-globe-web"
      image = "cloudacademydevops/3d-globe-web"
      ports = ["8080:80"]
      env   = ["GLOBE_API_HOSTPORT=localhost:9090"]
      tags = {
        colour = "green"
      }
    },
    globe_api = {
      name  = "3d-globe-api-v2"
      image = "cloudacademydevops/3d-globe-api-v2"
      ports = ["9090:9090"]
      tags = {
        colour = "red"
      }
    }
  }

  providers = {
    docker = docker
  }
}
