
# Cloud native bootcamp tools

Este repositotorio contiene las instrucciones y herramientas para poder realizar el taller de Cloud-native Bootcamp. 



**TL;DR**
```docker 
  docker run -it --name cnb-tools hjosef13/cnb-tools
```
## Que hay dentro de este imagen de docker?

- `IBM Cloud CLI` instalado.
- Editor de texto `VIM`
- `OpenJDK-8`
- `Git`
- Directorio `/home`
- `npm`
- `nodejs`


Dentro del directorio de `/home` se ecuentran los siguiente repos clonados: 
- https://github.com/IBM/container-service-getting-started-wt.git
- https://github.com/ibm-cloud-academy/LightBlueCompute


  
## Requisitos

Para poder ejecutar este proyecto es requerido la instalación de al menos:
- [Docker]()
- [VSCode]()

Así mismo crear un cuenta de [IBM Cloud](https://cloud.ibm.com).
## Instalación 

Puedes utilizar la imagen de docker hub `hjosef13/cnb-tools` en su forma más básica:
```docker 
  docker run -it --name cnb-tools hjosef13/cnb-tools
```
Esta es la versión mínima para ejecutar el contenedor. 
Es **importante** tener en cuenta que no tiene ningún volumen (formar de persistir) asignado por lo que se perderá toda edición alguna.

**Opción 1: Ejecutar con Volumen (Todo se hace con comandos)**

Esta opción es la más moderna y se recomiena para cuando se tenga la necesidad de persistir y también te sientas cómodo en ejecutar en su totalidad comandos desde la terminal incluyendo el editor de texto vim.

*1. crea un volumen de docker:*
```bash 
docker volume create cnb-bootcamp
```
*2. corre el contenedor con el volumen*
```bash 
docker run -it --name cnbtools --mount source=cnb-bootcamp,target=/home hjosef13/cnb-tools
```
Con el comando anterior estamos ejecutando el contenedor de manera interactiva y estamos asignando el volumen al directorio `/home` dentro del contenedor. 


**Opción 2: Ejecutar con Bind (Soporte para VSCode)**

Esta opción la puedes utilizar para cuando no te sientas tan cómodo para ejecutar del todo los comandos en la terminal y quieras utilizar VSCode como editor de texto.
Esta alternativa no es la más recomendada en cuanto a performan. Sin embargo para este escenario de solo poder realizar el taller se considera suficiente.

*1. Crea un directorio en tu equipo el cual deseas conectar(bind) al sistema de archivos del contenedor:*
```bash 
mkdir cloud-bootcamp;
cd cloud-bootcamp;
```
*2. Ejecuta el contenedor unido a nuestro dircetorio*
```bash 
docker run -it --name cnbtools --mount type=bind,source="$(pwd)/cloud-bootcamp",target=/cloud-bootcamp hjosef13/cnb-tools
```
*3. Clona los repositorios*
```bash 
git clone https://github.com/ibm-cloud-academy/LightBlueCompute
git clone https://github.com/IBM/container-service-getting-started-wt.git
```

## Documentation

- [Docker Volumes](https://docs.docker.com/storage/volumes/)
- [VI Cheatsheet](https://devhints.io/vim)

  