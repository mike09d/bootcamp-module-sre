# CodePipeline IaC

Configurar manualmente un proyecto de CodePipeline para probar y desplegar la aplicación contenerizada.


Si utiliza la consola para crear un proyecto:

En Operating system (Sistema operativo), elija Ubuntu.

En Runtime, elija Standard (Estándar).

En Imagen, elija aws/codebuild/standard:4.0.

Dado que utilizar este proyecto de compilación para crear una imagen de Docker, seleccione Privileged (Con privilegios).

nota
De forma predeterminada, los contenedores Docker no permiten el acceso a ningún dispositivo. El modo privilegiado otorga acceso al contenedor Docker de un proyecto de compilación a todos los dispositivos. Para obtener más información, consulte la sección sobre privilegios en tiempo de ejecución y capacidades de Linux en el sitio web de Docker Docs.

Añada las siguientes variables de entorno:

AWS_DEFAULT_REGION con un valor de region-ID

AWS_ACCOUNT_ID con un valor de ID de account-ID

IMAGE_TAG con un valor de Latest

IMAGE_REPO_NAME con un valor de Amazon-ECR-repo-name



## Instrucciones

```
version: 0.2

phases: 
  pre_build:
    commands:
      - echo Logging in to Amazon ECR...
      - aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com
  build:
    commands:
      - echo Build started on `date`
      - echo Building the Docker image...          
      - docker build -t $IMAGE_REPO_NAME:$IMAGE_TAG -f backend/Dockerfile ./backend/
      - docker tag $IMAGE_REPO_NAME:$IMAGE_TAG $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME:$IMAGE_TAG
  post_build:
    commands:
      - echo Build completed on `date`
      - echo Pushing the Docker image...
      - docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME:$IMAGE_TAG
      
      ```