# airflow-scheduler - The scheduler monitors all tasks and DAGs, then triggers the task instances once their dependencies are complete.
# airflow-webserver - The webserver available at http://localhost:8080.
# airflow-worker - The worker that executes the tasks given by the scheduler.
# airflow-init - The initialization service.
# flower - The flower app for monitoring the environment. It is available at http://localhost:5555.
# postgres - The database.
# redis - The redis - broker that forwards messages from scheduler to worker.

# Sobe o servico airflow-init ( população do banco de dados )
docker-compose up airflow-init

# Sobe o ambiente completo
docker-compose up

# Visualizar os logs do compose
docker-compose logs