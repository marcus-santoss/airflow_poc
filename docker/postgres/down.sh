#!/bin/bash

podman container stop db-application || podman container rm -f db-application