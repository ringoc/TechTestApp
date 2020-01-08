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
    1. build from source
    2. install `dep`
    3. compile locally `go get -d github.com/ringoc/TechTestApp` and open `build.sh` what it trying to do
    4. `dist` created, run `./dist/TechTestApp serve`
    5. Dada ! Server started at localhost:3000 , Cool at least we got something
    6. Oops, To Do list can't be saved ![alt text][spa-localhost]
    7. check `ERROR: pq: password authentication failed for user "postgres"`, of course ! no persistance storage. 
    8. Fire up a PostgreSQL at localhost `docker run --name postgres -e POSTGRES_PASSWORD=changeme -p 5432:5432 -d postgres`
    9. Test psql connection `telnet localhost 5432`
    10. kill the SPA and create db with `./dist/TechTestApp updatedb`, database seems created
    11. try start the SPA again ![alt text][spa-localhost-1]
    12. All good, looks like it is working fine in local, start prepare to deploy to cloud. 


[spa-localhost]: images/spa-localhost.png "SPA localhost"
[spa-localhost-1]: images/spa-localhost-1.png "SPA localhost 1"

