# Comandos Lab Kubernetes
Variables que deberas conocer de ante mano:
- `CLUSTER_NAME` - Nombre del cluster asignado
- `NAME_SPACE` - Solicita al facilitador este valor
- `ID` - Tu identificador del curso, suele ser un número del 1 al 20.
## Comandos frecuentes
Obtener Configuración del cluster
```bash
ibmcloud ks cluster config --cluster ${CLUSTER_NAME}
```
Obtener IP del cluster
```bash
ibmcloud ks workers --cluster ${CLUSTER_NAME} 
```
## Lab 1
1. 
```bash
cd 'container-service-getting-started-wt/Lab 1'
```
2.
```bash
ibmcloud cr build -t us.icr.io/${NAME_SPACE}/hello-world-${ID}:1 .
```
3.
```bash
kubectl create deployment hello-world-deployment --image=us.icr.io/${NAME_SPACE}/hello-world-${ID}:1
```
4.
```bash
kubectl expose deployment/hello-world-deployment --type=NodePort --port=8080 --name=hello-world-service --target-port=8080
```
5.
```bash
kubectl describe service hello-world-service
#obtener el valor de NodePort - un puerto entre 30,000 a 32,767
```
6.
```bash
kubectl get all -l app=hello-world-deployment
```
7.
```bash
curl "http://${WORKER_IP}:${nodeport}"
```
8.
```bash
kubectl delete all -l app=hello-world-deployment
```

## Lab 2
En este lab se pone a prueba el HealthManager de K8s. 
Una vez desplegada la aplicación, los primeros 10-15 segundos en el path /healthz se retorna un código 200. 
Despues regresa 500 y entonces se reiniciará y vovler a retornar 200.
1.
```bash
cd 'container-service-getting-started-wt/Lab 2'
```
2.
```bash
ibmcloud cr build -t us.icr.io/${NAME_SPACE}/hello-world-${ID}:2 .
```
3.
```bash
#actualizar antes el healthcheck con tu imagen...
kubectl apply -f healthcheck.yml
```
4.
```bash
# go to browser and check 169.51.200.186:30072 a hello world message should appear
curl "http://${WORKER_IP}:30072/"
```
5.
```bash
# on screen 1
kubectl get pods -o wide -w

#on screen 2
curl "http://${WORKER_IP}:30072/healthz"
```
6.
```bash
kubectl delete -f healthcheck.yml
```

## Lab 3
1.
```bash
ibmcloud resource service-instance-create cnb-tone-analyzer-${ID} tone-analyzer  standard us-south
```
2.
```bash
ibmcloud  resource service-instances
```
3.
```bash
ibmcloud ks cluster service bind --cluster ${CLUSTER_NAME} --namespace default --service cnb-tone-analyzer-${ID}
```
4.
```bash
kubectl get secrets --namespace=default
```
5.
```bash
cd 'container-service-getting-started-wt/Lab 3'
```
6.
```bash
cd watson
```
7.
```bash
ibmcloud cr build -t  us.icr.io/${NAME_SPACE}/watson-${ID} .
```
8.
```bash
cd ../watson-talk
ibmcloud cr build -t us.icr.io/${NAME_SPACE}/watson-talk-${ID} .
```
9.
```bash
ibmcloud cr images --restrict ${NAME_SPACE}
```
10.
```bash
cd ..
## actualizar watson-deployment.yml con los valores de tus imagenes y tu secret.
```
11.
```bash
kubectl apply -f watson-deployment.yml
```
12.
```bash
kubectl get pods
```
13.
```bash
curl --location --request GET "http://${WORKER_IP}:30080/analyze/%22Today%20is%20a%20beautiful%20day%22"
```
## Teardown
1. 
```bash
 kubectl delete -f watson-deployment.yml
```
2. 
```bash
ibmcloud ks cluster service unbind --cluster ${CLUSTER_NAME} --namespace default --service cnb-tone-analyzer-${ID}
```
3. 
```bash
ibmcloud resource service-instance-delete cnb-tone-analyzer-${ID} -f
```
