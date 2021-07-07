# Comandos Lab Microservicios
## Requisitos
### Requisitos 1: Ejecutar las cnb-tools en vscode
*1. Abrir una terminal y posicionarnos un directorio arriba del especial que creamos para el bootcamp*
*2. Ejecuta VSCode apuntando al directorio de cloud-bootcamp*
```bash 
code cloud-bootcamp;
```
*3. Dentro de VSCode, en la parte de arriba verás un menú que dice "Terminal" da click, seguido de otro click en "Nueva Terminal. Esto abrirá una terminal dentro de VSCode.*
*4. En la terminal, asegúrate que este corriendo el contenedor con el siguiente comando*
```bash 
docker ps
```
En caso que no esté corriendo arranca con:
```bash 
docker start cnbtools
```
*5. Ingresa de nuevo al contenedor*
```bash 
docker exec -it cnbtools bash
```
*6. Una vez dentro del contenedor, ejecuta el siguiente comando:*
```bash 
cd /cloud-bootcamp
```
### Requisitos 2: Autenticarse a ibmcloud
*1. Realiza el login en IBM Cloud (Utiliza tus credenciales que viste en tu cuenta)*
```bash 
ibmcloud login
```
*2. Apuntar al Resource Group correcto:*
```bash 
ibmcloud target -g cnb-telmex-mx-rg
```
*3. Confirmar la autenticación satisfactoria con:*
```bash 
ibmcloud target
```
### Requisitos 3: Ingresar las variables de entorno
- `export ID=` # Tu identificador del curso, suele ser un número del 1 al 20.
- `export CLUSTER_NAME=` # se te asigna 
- `export NAME_SPACE= `# te lo asinga el instructor
- `export CLOUDANT_SVC_NAME=cloudantdb-${ID}`  
Confirmar los valores correctos de las variables de entorno
```
export ID=
```
```
export CLUSTER_NAME=
```
```
export NAME_SPACE=
```
```
export CLOUDANT_SVC_NAME=cloudantdb-${ID}
```
```
echo $ID
echo $CLUSTER_NAME
echo $NAME_SPACE
echo $CLOUDANT_SVC_NAME
```
### Requisitos 4: Configurar cluster e ingresar las variables de entorno
Obtener Configuración del cluster
```bash
ibmcloud ks cluster config --cluster ${CLUSTER_NAME}
```
Ingresar la última variable de entorno que nos falta:
- `export WORKER_IP=` (Indicar la IP Pública: `ibmcloud ks workers --cluster ${CLUSTER_NAME}`).
Confirmar el valor correcto de la variable
```
echo $WORKER_IP
```
## Lab 1. Base de datos Customer
1. Creación de la base de datos "Cloudant" de clientes.
```bash
ibmcloud resource service-instances
ibmcloud resource service-instance-create ${CLOUDANT_SVC_NAME} cloudantnosqldb  lite us-south -p '{"legacyCredentials": true}'
```
2. Obtener los datos de la intancia
```bash
echo $CLOUDANT_SVC_NAME
export CLOUDANT_ID=
export CLOUDANT_GUID=
```
Confirmar el valor correcto de las variables
```
echo $CLOUDANT_ID
echo $CLOUDANT_GUID
```
3. Hacer un bind de nuestro cluster al servicio de cloudant
```bash
ibmcloud ks cluster service bind --cluster ${CLUSTER_NAME} --namespace default --service ${CLOUDANT_GUID}
```
4. Obtener las credenciales del servicio
```bash
ibmcloud resource service-key-create cloudant-creds --instance-id ${CLOUDANT_ID}
```
## Lab 2. Microservicio Customer
1. Ingresar al directorio en la terminal
```bash
cd LightBlueCompute/customer
```
2. Editar el archivo con las credenciales de la BD(línea 12:username, 13:password, 14:host) 
`LightBlueCompute/customer/src/main/resources/application.yml`
Podemos revisar que se haya editado correctamente con:
```bash
cat src/main/resources/application.yml
```
3. Build de la app Customer 
```bash
curl https://bootcamp-gradle-build.mybluemix.net/ms/customer --output docker/app.jar
cd docker
ls -l
```
4. Desplegar al container registry
```bash
ibmcloud cr build --tag us.icr.io/${NAME_SPACE}/customer-${ID} .
```
5. Cambiar de directorio
```bash
cd ../kubernetes
```
6. Editar el archivo customer.yml
`ibmcloud cr images` (para listar todas las imagenes y remplazar por la propia en la `línea 18`).
`kubectl get secrets` (para ver el nombre del binding y reemplazarlo en la `línea 32`).
7. Desplegar el microservicio en Kubernetes.
```bash
kubectl create -f customer.yml
```
Revisar el status de los pods:
```bash
kubectl get all
```
8. Insertar registro en la Base de Datos
```bash
curl  -i -X POST -H "Content-Type: application/json" -H "Accept: application/json" -d '{"username": "foo", "password": "bar", "firstName": "foo", "lastName": "bar", "email": "foo@bar.com"}' "http://${WORKER_IP}:30110/micro/customer"
```
9. Probar
```bash
curl "http://${WORKER_IP}:30110/micro/customer/search?username=foo"
```
## Lab 3. Mysql
1. Cambiar de directorio
```bash
cd ../../mysql
```
2. Desplegar al container registry
```bash
ibmcloud cr build --tag us.icr.io/${NAME_SPACE}/mysql-${NUM} .
```
3. Cambiar de directorio
```bash
cd kubernetes
```
4. Editar el archivo customer.yml
`ibmcloud cr images` (para listar todas las imagenes y remplazar por la propia en la `línea 18`).
5. Desplegar el microservicio en Kubernetes.
```bash
kubectl create -f mysql.yml
```
6. Imprimir la IP y el nombre del pod para usarlos posteriormente
```bash
kubectl get pods
echo $WORKER_IP
```
7. Entrar al pod
```bash
kubectl exec -it <POD_NAME> -- bash
```
8. Correr el script que inserta los registros en la BD.
```bash
bash /load-data.sh
```
9. Autenticarse para corroborar si se ingresaron los datos
```bash
mysql -udbuser -pPass4dbUs3R -h<worker_publicIP> -P30006
select count(*) from inventorydb.items;
quit
exit
```
## Lab 4. Microservicio Catalog
1. Cambiar de directorio
```bash
cd ../../catalog
```
2. Editar el archivo src/main/resources/application.yml 
Editar la `WORKING_IP` en la `línea 17`.
3. Build de la app Catalog
```bash
./gradlew build -x test 
./gradlew docker
```
En caso de error:
```bash
curl https://bootcamp-gradle-build.mybluemix.net/ms/catalog --output docker/app.jar
```
4. Cambiar de directorio
```bash
cd docker
```
5. Desplegar al container registry
```bash
ibmcloud cr build --tag us.icr.io/${NAME_SPACE}/catalog-${ID} .
```
6. Cambiar de directorio
```bash
cd ../kubernetes
```
7. Editar el archivo catalog.yml
```bash
`ibmcloud cr images` (para listar todas las imagenes y remplazar por la propia en la `línea 18`).
```
8. Desplegar el microservicio en Kubernetes.
```bash
kubectl create -f catalog.yml
```
9. Probar
```bash
curl "http://$WORKER_IP:30111/micro/items/13401"
```
## Lab 5. Microservicio Web
1. Cambiar de directorio
```bash
cd ../../web-app-lite/config
```
2. Editar el archivo default.json
Remplazar el host de catalogo, cambiar `cataloghost` por `catalog-lightblue-service:8081` en la `línea 15`.
Remplazar el base_path de catalogo, cambiar `/api` por `/micro` en la `línea 16`.
Remplazar el host de customer, cambiar `customerhost` por `customer-lightblue-service:8080` en la `línea 30`.
Remplazar el base_path de catalogo, cambiar `/api` por `/micro` en la `línea 31`.
3. Cambiar de directorio
```bash
cd ../
```
4. Desplegar al container registry
```bash
ibmcloud cr build --tag us.icr.io/${NAME_SPACE}/webapp-${ID} .
```
5. Cambiar de directorio
```bash
cd kubernetes
```
6. Editar el archivo webapp.yml
```bash
`ibmcloud cr images` (para listar todas las imagenes y remplazar por la propia en la `línea 18`).
```
7. Desplegar el microservicio en Kubernetes.
```bash
kubectl create -f webapp.yml
```
8. Probar en el navegador
```bash
echo "http://$WORKER_IP:30130/"
```
## TEARDOWN
```bash
ibmcloud ks cluster service unbind --cluster ${CLUSTER_NAME} --namespace default --service ${CLOUDANT_GUID}  
kubectl delete --all deployment
kubectl delete --all service
cd ..
rm -rf LightBlueCompute
export CLOUDANT_CREDS_ID="$(ibmcloud resource service-keys --output json | jq -r '.[] | select(.name=="cloudant-creds").id')"
echo $CLOUDANT_CREDS_ID
ibmcloud resource service-key-delete ${CLOUDANT_CREDS_ID} -f
ibmcloud resource service-instance-delete ${CLOUDANT_ID}  -f
git clone https://github.com/ibm-cloud-academy/LightBlueCompute
ibmcloud cr image-rm us.icr.io/${NAME_SPACE}/catalog-${ID}
ibmcloud cr image-rm us.icr.io/${NAME_SPACE}/customer-${ID}
ibmcloud cr image-rm us.icr.io/${NAME_SPACE}/mysql-${ID}
ibmcloud cr image-rm us.icr.io/${NAME_SPACE}/webapp-${ID}
ibmcloud cr images --restrict ${NAME_SPACE}
ibmcloud cr image-rm us.icr.io/${NAME_SPACE}/lightblue-catalog-kube
ibmcloud cr image-rm us.icr.io/${NAME_SPACE}/lightblue-customer-kube
ibmcloud cr image-rm us.icr.io/${NAME_SPACE}/lightblue-mysql-kube
ibmcloud cr image-rm us.icr.io/${NAME_SPACE}/lightblue-web-kube
