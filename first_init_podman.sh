# airflow-scheduler - The scheduler monitors all tasks and DAGs, then triggers the task instances once their dependencies are complete.
# airflow-webserver - The webserver available at http://localhost:8080.
# airflow-worker - The worker that executes the tasks given by the scheduler.
# airflow-init - The initialization service.
# flower - The flower app for monitoring the environment. It is available at http://localhost:5555.
# postgres - The database.
# redis - The redis - broker that forwards messages from scheduler to worker.

# Inicializar cria os containers sem inicializar
podmman-compose up --no-start --force-recreate -t 0

#Inicializa o Postgres
podman-compose start postgres

# Inicializa o airflow-init ( popular o banco de dados )
podman-compose start airflow-init && podman-compose logs -f airflow-init

# Derruba o ambiente
podman-compose down -t 0

# Sobe o ambiente com todos os componentes
podman-compose up -d -t 0

# Exibe os logs do webserver
timeout 30 podman-compose logs -f airflow-webserver