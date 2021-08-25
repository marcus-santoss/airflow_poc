#!/bin/bash

podman run --name db-application \
           --replace -d -p 5544:5432 \
           -e POSTGRES_USER=postgres \
           -e POSTGRES_PASSWORD=postgres \
           -e POSTGRES_DB=postgres \
           docker.io/postgres:13