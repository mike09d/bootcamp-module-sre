# CodePipeline IaC

Configurar manualmente un proyecto de CodePipeline para probar y desplegar la infraestructura por terraform.

## Instrucciones

1. Crear un proyecto en CodePipeline con los siguientes parámetros:

- **Pipeline settings**
  - *Pipeline name*: `mf-iac-terraform`
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
  - *Project name*: `mf-terraform-apply`
- **Environment**
  - *Environment image*: `Managed image`
  - *Operating system*: `Amazon Linux 2`
  - *Runtime(s)*: `Standard`
  - *Image*: `aws/codebuild/amazonlinux2-x86_64-standard:3.0`
  - *Image version*: `Always use the latest image for this runtime version`
  - *Environment type*: `Linux`
  - *Service role*: `New service role`
- **Buildspec**
  - *Build specifications*: `Use a buildspec file`
  - *Buildspec name*: `talleres/03/buildspec-iac.yml`
- **Logs**: Validar que la casilla `CloudWatch logs` esté seleccionada
  - *Group name*: `mf-tf`
  - *Stream name*: `mf-tf`

Click en `Skip deploy stage`

4. Completar el archivo `buildspec-iac.yml`:

5. Validar que el Pipeline se ejecuta con cada cambio al repositorio

## Validación

Hacer *push* a los cambios y validar que CodePipeline ejecuta las etapas de forma correcta.