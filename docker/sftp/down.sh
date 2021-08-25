#!/bin/bash

podman container stop sftp || podman container rm -f sftp
