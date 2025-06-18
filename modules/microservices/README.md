## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_docker"></a> [docker](#provider\_docker) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [docker_container.microservices](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs/resources/container) | resource |
| [docker_image.microservices](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs/resources/image) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_microservices"></a> [microservices](#input\_microservices) | values for each microservice, including name, image, ports, environment variables, and tags. | <pre>map(object({<br/>    name  = string<br/>    image = string<br/>    ports = list(string)<br/>    env   = optional(list(string))<br/>    tags  = optional(map(string), {})<br/>  }))</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Default tags to apply to all microservices. Can be overridden by individual microservice tags. | `map(string)` | <pre>{<br/>  "environment": "production",<br/>  "team": "default-team"<br/>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_microservice_ports"></a> [microservice\_ports](#output\_microservice\_ports) | n/a |