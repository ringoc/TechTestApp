# TechTestApp 

## Deployment records

## Test result 
The SPA is under http://34.87.204.59:3000/

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
5. check `ERROR: pq: password authentication failed for user "postgres"`, of course ! no DB setup.
 
#### Setup up PostgreSQL in local with docker
 
1. Fire up a PostgreSQL at localhost `docker run --name postgres -e POSTGRES_PASSWORD=changeme -p 5432:5432 -d postgres`
2. Test connection 
3. kill the SPA and create db with `./dist/TechTestApp updatedb`, database seems created
4. try start the SPA again ![alt text][spa-localhost-1]
5. All good, looks like it is working fine in local, start prepare to deploy to cloud. 

[spa-localhost]: images/spa-localhost.png "SPA localhost"
[spa-localhost-1]: images/spa-localhost-1.png "SPA localhost 1"

### Architecture decision
For personal preference, I would build an image for the SPA and put them on Kubernetes. Choosing GKE since I got free credits. 
- SPA frontend autoscaling and HA with K8s deployment
- DB PostgreSQL HA with Cloud SQL

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
1. GCP roject `ringo-264812` already existed
2. Cloud SDK is installed, GCR API enabled, GKE API enabled
3. Setup GKE cluster `ringo-cluster`

#### Setting up GKE cluster
```
gcloud auth login
gcloud auth configure-docker
docker tag techtestapp:latest gcr.io/ringo-264812/techtestapp:latest
docker push gcr.io/ringo-264812/techtestappgcr.io/ringo-264812/techtestapp
gcloud config set project ringo-264812
gcloud container clusters create ringo-cluster
gcloud container clusters get-credentials ringo-cluster
```
#### 

#### Define manifest for deploy the SPA frontend
Manifest files located under folder `/cloud/gcp/gke/techtestapp/`

1. `techtestapp-pvc.yaml` - PersistenceVolumeClaim
2. `techtestapp-svc.yaml` - Service
3. `techtestapp-deploy.yaml` - Deployment
4. `techtestapp-autoscale.yaml` - HorizontalAutoScaler 

Load testing by firing up a busybox 

`kubectl run --generator=run-pod/v1 -it --rm load-generator --image=busybox /bin/sh`

`while true; do wget -q -O- http://34.87.204.59:3000/; done`

Watch the AutoScaler up scale the replicas as the CPU load go up

#### Define manifests for deploy the PostgreSQL (Current)

1. `postgres-db-pvc.yaml` - PersistenceVolumeClaim
2. `postgres-db-svc.yaml` - Service
3. `postgres-db-deploy.yaml` - Deployment
4. `postgres-db-secret.yaml` - Secret


#### Setup  PostgreSQL Cloud SQL instance HA (Ideal)
1. Create PostgreSQL Cloud SQL instance
```
gcloud sql instances create postgresdb \ 
    --availability-type=REGIONAL \
    --database-version=POSTGRES_11 \
    --cpu=2 --memory=4 \
    --region=australia-southeast1
```        
2. Configure root user
```
gcloud sql users set-password postgres \
    --instance=postgresdb \
    --prompt-for-password
```
3. Enable Cloud SQL Admin API 
`https://console.cloud.google.com/flows/enableapi?apiid=sqladmin&redirect=https://console.cloud.google.com`
4. Create Service Account 
`https://cloud.google.com/sql/docs/postgres/sql-proxy#create-service-account`
5. Create Secret for 
`kubectl create secret generic cloudsql-instance-credentials \
--from-file=credentials.json=secrets/ringo-264812-fe358db03343.json`
6. Define manifest with cloud proxy 
7. `./TechTestApp updatedb` can drop DB but failed to create DB 
`ERROR : pq: permission denied for tablespace pg_default`






