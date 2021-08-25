#!/bin/bash

podman run --name sftp --replace -d \
       -v $(pwd)/docker/sftp/shared:/home/admin/shared:z \
       -p 2222:22 atmoz/sftp:debian admin:admin:1001:100:shared

#       -v $(pwd)/docker/sftp/users.conf:/etc/sftp/users.conf:ro \
