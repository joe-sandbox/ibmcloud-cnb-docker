
# Cloud native bootcamp tools

Este repositotorio contiene las instrucciones y herramientas para poder realizar el taller de Cloud-native Bootcamp. 



**TL;DR**
```docker 
  docker run -it --name cnb-tools hjosef13/cnb-tools:2021.3.1
```
## Que hay dentro de este imagen de docker?

- `IBM Cloud CLI` instalado.
- Editor de texto `VIM`
- `OpenJDK-8`
- `Git`
- Directorio `/home`
- `npm`
- `nodejs`
- Openshift Client
- wget & curl


Dentro del directorio de `/bootcamp` se ecuentran los siguiente repos clonados: 
- https://github.com/IBM/container-service-getting-started-wt.git
- https://github.com/ibm-cloud-academy/LightBlueCompute
- Además como los jars que se requieren durante los laboratorios de Java, como alternativa en caso que no funcione la compilación.
  
## Requisitos

Para poder ejecutar este proyecto es requerido la instalación de al menos:
- [Docker]()
- [VSCode]()

Así mismo crear un cuenta de [IBM Cloud](https://cloud.ibm.com).
## Instalación 

Si eres un usuario que sabe manejar la terminal y te sientes cómodo editando código de VIM puedes utilizar la imagen de docker hub `hjosef13/cnb-tools` en su forma más básica:
```docker 
  docker run -it --name cnb-tools hjosef13/cnb-tools:2021.3.1
```
Despues puedes pasar al paso 4.

De lo contrario sigue estos pasos.
### 1. Abre una terminal (En caso de windows si no cuentas con una consola con Bash te recomiendo uses PowerShell) y ejecuta los siguientes comandos:
Para windows:
```bash
cd %USERPROFILE%
mkdir mybootcamp
cd mybootcamp
```
Para MacOS:
```bash
cd ~
mkdir mybootcamp
cd mybootcamp
```
### 2. Abre VSCode con el directorio de myboootcamp pre-cargado.
Desde la terminal:
```bash
code .
```
Desde la aplicación:
File>Open... (Buscar directorio mybootcamp)
Archivo>Abrir... (Buscar directorio mybootcamp)

### 3. Ejecuta el contenedor
Para que este paso sea exitoso asegurate de estar dentro del directorio de mybootcamp.
```bash
docker run -it --name cnbtools --mount type=bind,source="$(pwd)",target=/bootcamp hjosef13/cnb-tools:2021.3.1
```
### 4. Descarga los repositorios y archivos necesarios
```bash
git clone https://github.com/IBM/container-service-getting-started-wt.git 
git clone https://github.com/ibm-cloud-academy/LightBlueCompute 
curl https://bootcamp-gradle-build.mybluemix.net/ms/catalog --output catalog.jar 
curl https://bootcamp-gradle-build.mybluemix.net/ms/customer --output customer.jar
```

### 5. Configura la terminal de IBM Cloud CLI
Antes de ejecutar el comando asegurate de cambiar los valores `<usuario>`y `<password>`por tu usuario y contraseña de IBM Cloud.
```bash
ibmcloud login -u <usuario> -p <password> -r us-south
```

Todo lo listo para empezar a trabajar en los laboratorios!

## He terminado como salgo de esto?
Para salir del contenedor basta con ingresar `exit` para salir. 


## He salido del contenedor como puedo volver a entrar? 
Si saliste o reiniciaste tu computadora puedes seguir trabajando con el contenedor e iniciarlo de esta manera:
```bash
docker start -i cnbtools
```

Si por alguna extraña razon no funcionara porque extrañamente sigue ejecutandose el contenedor intenta con el siguiente comando:
```bash
docker exec -it cnbtools bash
```

## Documentation

- [Docker Volumes](https://docs.docker.com/storage/volumes/)
- [VI Cheatsheet](https://devhints.io/vim)

  
