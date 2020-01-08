# TechTestApp 

## Deployment records

### Pre-requisites

1. golang installed
2. Cloud provider credential setup
3. Docker installed
3. forked from `https://github.com/servian/TechTestApp` to `https://github.com/ringoc/TechTestApp`

### Steps
1. check `/readme.md`
2. check `/doc/readme.md`
3. try start the SPA in local

#### Build
1. build from source
2. install `dep`
3. compile locally `go get -d github.com/ringoc/TechTestApp` 
    
#### Run SPA in local     
1. open `build.sh` what it trying to do
2. `dist` created, run `./dist/TechTestApp serve`
3. Dada ! Server started at localhost:3000 , Cool at least we got something
4. Oops, To Do list can't be saved ![alt text][spa-localhost]
5. check `ERROR: pq: password authentication failed for user "postgres"`, of course ! no persistance storage.
 
### Setup up PostgreSQL
 
1. Fire up a PostgreSQL at localhost `docker run --name postgres -e POSTGRES_PASSWORD=changeme -p 5432:5432 -d postgres`
2. Test psql connection `telnet localhost 5432`
3. kill the SPA and create db with `./dist/TechTestApp updatedb`, database seems created
4. try start the SPA again ![alt text][spa-localhost-1]
5. All good, looks like it is working fine in local, start prepare to deploy to cloud. 

[spa-localhost]: images/spa-localhost.png "SPA localhost"
[spa-localhost-1]: images/spa-localhost-1.png "SPA localhost 1"

