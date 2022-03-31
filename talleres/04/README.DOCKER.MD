# Crearemos Dockerfile

```
FROM ubuntu:latest
RUN echo Updating existing packages, installing and upgrading python and pip.
RUN apt-get update -y
RUN apt-get install -y python3-pip python3-dev build-essential
RUN pip3 install --upgrade pip
RUN echo Copying the Mythical Mysfits Flask service into a service directory.
COPY . /MythicalMysfitsService
WORKDIR /MythicalMysfitsService
RUN echo Installing Python packages listed in requirements.txt
RUN pip3 install -r ./requirements.txt
RUN echo Starting python and starting the Flask service...
ENTRYPOINT ["python3"]
EXPOSE 8080
CMD ["app.py"]
```

## Multi-staged dependencias & código

```
FROM python:3.7-slim AS build
RUN apt-get update -y
RUN apt-get install -y --no-install-recommends build-essential gcc
RUN python -m venv --copies /opt/venv
ENV PATH /opt/venv/bin:$PATH

RUN pip3 install --upgrade pip
COPY requirements.txt .
RUN pip install -r requirements.txt

FROM python:3.7-slim AS final
COPY --from=build /opt/venv /opt/venv/
ENV PATH /opt/venv/bin:$PATH
COPY . .
EXPOSE 8080
ENTRYPOINT ["python3"]
CMD ["app.py"]
```

## Comandos basicos para Docker

 - Construir imagen
   ``` docker build --pull --rm -f "backend/Dockerfile" . -t bootcampmodulesre:multistage ```

 - Correr contenedor
   ``` docker run --rm -d  -p 8080:8080 bootcampmodulesre:multistage ```

 - Abrir una Terminal dentro del contenedor Docker
   ``` docker exec -it :container_id bash ```

 - Ver todos los contenedores
   ```docker ps```

- Ver todos los contenedores incluyendo el peso 
  ```docker ps -as```

- Parar un contenedor concreto
  ```docker kill :container_id```

- Ver todas las imágenes Docker instaladas
  ```docker images```

- Limpia cualquier imagen, compilación, etc. que pueda estar activa
  ```docker system prune```


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