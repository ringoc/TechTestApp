# TechTestApp 

## Deployment records

### Pre-requisites

1. golang installed
2. Cloud provider credential setup
3. Docker installed
3. forked from `https://github.com/servian/TechTestApp` to `https://github.com/ringoc/TechTestApp`

### Test in localhost
1. check `/readme.md`
2. check `/doc/readme.md`

#### Build in local
1. build from source
2. install `dep`
3. compile locally `go get -d github.com/ringoc/TechTestApp` 
    
#### Run SPA in local     
1. open `build.sh` what it trying to do
2. `dist` created, run `./dist/TechTestApp serve`
3. Dada ! Server started at localhost:3000 , Cool at least we got something
4. Oops, To Do list can't be saved ![alt text][spa-localhost]
5. check `ERROR: pq: password authentication failed for user "postgres"`, of course ! no persistance storage.
 
#### Setup up PostgreSQL in local with docker
 
1. Fire up a PostgreSQL at localhost `docker run --name postgres -e POSTGRES_PASSWORD=changeme -p 5432:5432 -d postgres`
2. Test psql connection `telnet localhost 5432`
3. kill the SPA and create db with `./dist/TechTestApp updatedb`, database seems created
4. try start the SPA again ![alt text][spa-localhost-1]
5. All good, looks like it is working fine in local, start prepare to deploy to cloud. 

[spa-localhost]: images/spa-localhost.png "SPA localhost"
[spa-localhost-1]: images/spa-localhost-1.png "SPA localhost 1"

### Architecture decision
For personal preference, I would go for containers with Kubernetes. With Kubernetes, based on personal experience, GKE
has much better performance with EKS. 

### Build container image for SPA
1. Run `docker build . -t techtestapp:latest` failed
2. Error log suggest dependency not resolved. 
3. Add additional `go get xxx` in Dockerfile
4. Docker image build successful but fail to retrieve a page `ERROR: EMPTYRESPONSE`
5. Usually this indicate application bind address 
6. Ahhh .... of course ... conf.toml `ListenHost="localhost"` , change to  `ListenHost="0.0.0.0"` and try again 
7. Bingo ! All good

### Deploy to GKE

#### Assumption
1. project ringo-264812 existed
2. Cloud SDK is installed
```
gcloud auth login
gcloud auth configure-docker
docker tag techtestapp:latest gcr.io/ringo-264812/techtestapp:latest
docker push gcr.io/ringo-264812/techtestappgcr.io/ringo-264812/techtestapp
gcloud config set project ringo-264812
gcloud container clusters create ringo-cluster
gcloud container clusters get-credentials ringo-cluster
```

#### Write up kubernetes manifest for deploy the SPA frontend


Under folder `/cloud/gcp/gke/techtestapp/*`
PVC - `techtestapp-pvc.yaml`
SVC - `techtestapp-svc.yaml`
Deploy - `techtestapp-deploy.yaml`
HorizontalAutoScaler - `techtestapp-autoscale.yaml`

Load testing by firing up a busybox 

```
> kubectl run --generator=run-pod/v1 -it --rm load-generator --image=busybox /bin/sh
> while true; do wget -q -O- http://34.87.204.59:3000/; done
```

#### Write up Kubernetes manifests for deploy the PostgreSQL db

https://portworx.com/postgres-kubernetes/






