# Desplegando la API de Mythical Mysfits usando Terraform, Auto Scaling Groups y LoadBalancer

![diagrama](diagrama.jpeg)

Utilizaremos los siguientes recursos para realizar el despliegue de la arquitectura:

- aws_security_group
- aws_launch_configuration
- aws_autoscaling_group
- aws_lb
- aws_lb_target_group
- aws_lb_listener

## Materiales de apoyo

1. <https://master.d3ne2l9b29wug0.amplifyapp.com/> Desplegando la API de Mythical Mysfits usando Auto Scaling Groups
2. <https://master.d3qozw5mtctwjk.amplifyapp.com/> Desplegando la API usando CloudFormation y Auto Scaling Groups

Nota:

```bash
while sleep 1; do curl http://mythical-mysfits-alb-1091469221.us-east-1.elb.amazonaws.com; done
```
