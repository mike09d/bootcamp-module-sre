# Servicios ECR AWS

Crear en el proyecto base de la infraestructura de terraform el recurso ECR:

```
resource "aws_ecr_repository" "main" {
  name                 = "<<REEMPLAZAR_NOMBRE_REPOSITORIO>>"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
```

Consideraciones:
1. Modularizar el recurso
2. Pasar por parametro el nombre del repositorio
3. Exportar el ARN del recurso