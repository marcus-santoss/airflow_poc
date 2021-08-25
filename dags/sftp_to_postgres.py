from datetime import timedelta

from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.providers.http.hooks.http import HttpHook
from airflow.providers.sftp.hooks.sftp import SFTPHook
from airflow.utils.dates import days_ago

from lib.utils import Environ

dag_ini = {
    "dag_id": "get_coin_data",
    # "scheduler": "* * * * *",
    "default_args": {"retries": 2, "retry_delay": timedelta(minutes=5)},
    "tags": ["sftp", "json", "postgres"],
    "start_date": days_ago(2),
}

environ = Environ()


def proccess_data(**kwargs):
    ti = kwargs["ti"]
    destination_path = f"/shared/{kwargs['ds']}"

    http_hook = HttpHook("get", http_conn_id=environ.vars.coin_api.conn_id)
    response = http_hook.run(endpoint=environ.vars.coin_api.endpoint)

    sftp_hook = SFTPHook(ftp_conn_id=environ.vars.sftp_server.conn_id)

    if not sftp_hook.path_exists(destination_path):
        sftp_hook.create_directory(destination_path)

    full_remote_path = f"{destination_path}/coin_data.json"
    full_local_path = "/tmp/data.json"

    with open(full_local_path, "w") as stream:
        print(response.text, file=stream)

    sftp_hook.store_file(full_remote_path, full_local_path)
    ti.xcom_push(key="full_remote_path", value=full_remote_path)


with DAG(**dag_ini) as dag:
    # 1- Pegar do GCS ( Datalake )
    # 2- Enviar para o Postgres
    # 3- Realizer consulta no Postgres
    # 4- Exportar para o SFTP
    get_from_api = PythonOperator(
        task_id="get_from_api",
        python_callable=proccess_data,
    )

    # get_from_sftp = SFTPOperator(
    #     task_id="get_from_sftp",
    #     ssh_conn_id=environ.vars.sftp_conn_id,
    #     local_filepath="/tmp/wine.json",
    #     remote_filepath="/shared/winemag-data-130k-v2.json",
    #     operation=SFTPOperation.GET
    # )
