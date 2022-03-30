# Introducción a CodePipeline

Configurar manualmente un proyecto de CodePipeline para probar y desplegar el API de Mythical Mysfits con Auto Scaling Groups.

## Instrucciones

1. Crear un proyecto en CodePipeline con los siguientes parámetros:

- **Pipeline settings**
  - *Pipeline name*: `mf-build`
  - *Service role*: `New service role`
  - Validar que se encuentra marcada la casilla `Allow AWS CodePipeline to create a service role so it can be used with this new pipeline`
- **Advanced settings**
  - *Artifact store*: `Default location`
  - *Encryption key*: `Default AWS Managed Key`

2. En la sección de *Source* especificamos el repositorio de GitHub:

- **Source**
  - *Source provider*: `GitHub (Version 2)`
  - `Connection` -> Connect to GitHub -> *You have successfully configured the action with the provider.*
  - *Repository*: `bootcamp-module-devops`
  - *Branch*: `main`
  - *Output artifact format*: `CodePipeline default`

3. En la sección de *Build* creamos un proyecto de CodeBuild para validar y exportar el template de CloudFormation:

- **Build**
  - *Build provider*: `AWS CodeBuild`
  - *Region*: (selecciona tu región)
  - *Project name*: Click en `Create Project`

En la ventana emergente llenar estos campos:

- **Project configuration**
  - *Project name*: `mf`
- **Environment**
  - *Environment image*: `Managed image`
  - *Operating system*: `Ubuntu`
  - *Runtime(s)*: `Standard`
  - *Image*: `aws/codebuild/standard:4.0`
  - *Image version*: `Always use the latest image for this runtime version`
  - *Environment type*: `Linux`
  - *Service role*: `New service role`
- **Buildspec**
  - *Build specifications*: `Use a buildspec file`
  - *Buildspec name*: `talleres/03/buildspec-tests.yml`
- **Logs**: Validar que la casilla `CloudWatch logs` esté seleccionada
  - *Group name*: `gn-mf`
  - *Stream name*: `sn-mf`

Click en `Skip deploy stage`

4. Validar que el Pipeline se ejecuta con cada cambio al repositorio

## Validación

Hacer *push* a los cambios y validar que CodePipeline ejecuta las etapas de forma correcta.

# Referencias

## Introducción a CodeBuild

- https://master.d372ywlov8ovek.amplifyapp.com/

## Introducción a CodePipeline

- https://master.d3999qk39rj7j3.amplifyapp.com/

## Introducción a CodeDeploy

- https://master.d3e43dmmbjepa0.amplifyapp.com/

# Documentación AWS
- https://docs.aws.amazon.com/codebuild/latest/userguide/build-spec-ref.html
- https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-env-vars.html
- https://docs.aws.amazon.com/codebuild/latest/userguide/available-runtimes.html