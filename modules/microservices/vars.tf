variable "microservices" {
  type = map(object({
    name  = string
    image = string
    ports = list(string)
    env   = optional(list(string))
    tags  = optional(map(string), {})
  }))

  description = "values for each microservice, including name, image, ports, environment variables, and tags."

  validation {
    condition = alltrue([
      for ms in var.microservices : can(regex("^([a-zA-Z0-9]+([._-][a-zA-Z0-9]+)*)(/[a-zA-Z0-9]+([._-][a-zA-Z0-9]+)*)*(:[a-zA-Z0-9._-]+)?$", ms.image))
    ])
    error_message = "Each microservice 'image' must be a valid Docker image string (e.g., 'nginx:latest', 'myrepo/myimage:v1.0')."
  }

  validation {
    condition = alltrue([
      for ms in var.microservices : alltrue([
        for p in ms.ports : can(regex("^[0-9]+:[0-9]+$", p))
      ])
    ])
    error_message = "Each port mapping must be in the format 'hostPort:containerPort' (e.g., '8080:80')."
  }
}

variable "tags" {
  type = map(string)

  default = {
    environment = "production"
    team        = "default-team"
  }

  description = "Default tags to apply to all microservices. Can be overridden by individual microservice tags."
}
