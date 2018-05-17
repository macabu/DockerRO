# DockerRO

To run locally with `docker-compose`, you need to first start the `db` container, then do `docker-compose up` and everything should work.  

Optionally you can also start each container individually, but it is recommended that the following order is obeyed:
 1. db (REQUIRED)
 2. login-server
 3. char-server
 4. map-server
