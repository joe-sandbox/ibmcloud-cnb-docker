
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

### Parte 1: Ejecutar con Volumen (Todo se hace con comandos)

Esta opción es la más moderna y se recomiena para cuando se tenga la necesidad de persistir y también te sientas cómodo en ejecutar en su totalidad comandos desde la terminal incluyendo el editor de texto vim.

*1. Crea un directorio en tu equipo el cual deseas conectar(bind) al sistema de archivos del contenedor:*
```bash 
mkdir cloud-bootcamp; #para sistemas UNIX/LINUX
```
*2. Ejecuta VSCode apuntando al directorio de cloud-bootcamp*
```bash 
code cloud-bootcamp;
```
*3. Dentro de VSCode, en la parte de arriba verás un menú que dice "Terminal" da click, seguido de otro click en "Nueva Terminal. Esto abrirá una terminal dentro de VSCode.

*4. Dentro de la terminal crea un volumen de docker:*
```bash 
docker volume create cnb-bootcamp
```
*5.  Dentro de la terminal, ejecuta el contenedor unido a nuestro dircetorio y al volumen previamente creado*
```bash 
docker run -it --name cnbtools \ 
       --mount type=bind,source="$(pwd)/cloud-bootcamp",target=/cloud-bootcamp \
       --mount source=cnb-bootcamp,target=/home \
       hjosef13/cnb-tools
```
o si lo prefieres en una sola línea:
```bash 
docker run -it --name cnbtools --mount type=bind,source="$(pwd)/cloud-bootcamp",target=/cloud-bootcamp --mount source=cnb-bootcamp,target=/home hjosef13/cnb-tools
```
*6. Una vez dentro del contenedor(en la terminal), ejecuta el siguiente comando:*
```bash 
cd /cloud-bootcamp
```
*7. Clona los repositorios (Solo la primera vez)*
```bash 
git clone https://github.com/ibm-cloud-academy/LightBlueCompute
git clone https://github.com/IBM/container-service-getting-started-wt.git
```
*8. Realiza el login en IBM Cloud (Utiliza tus credenciales que viste en tu cuenta)*
```bash 
ibmcloud login -r us-south
```

## Documentation

- [Docker Volumes](https://docs.docker.com/storage/volumes/)
- [VI Cheatsheet](https://devhints.io/vim)

  
