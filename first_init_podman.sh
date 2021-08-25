podmman-compose up --no-start -V

podman-compose start postgres
podman-compose start airflow-init && podman-compose logs -f airflow-init
podman-compose down
podman-compose up -d
timeout 15 podman-compose logs -f airflow-webserver