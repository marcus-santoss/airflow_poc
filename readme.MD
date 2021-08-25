#### Sobre o projeto

Este é um projeto airflow de teste e um template para inicialização de novos projetos utilizando o docker-compose. O
ambiente é formado com os seguintes componentes:

- airflow-scheduler - The scheduler monitors all tasks and DAGs, then triggers the task instances once their
  dependencies are complete.
- airflow-webserver - The webserver available at http://localhost:8080.
- airflow-worker - The worker that executes the tasks given by the scheduler.
- airflow-init - The initialization service.
- flower - The flower app for monitoring the environment. It is available at http://localhost:5555.
- postgres - The database.
- redis - The redis - broker that forwards messages from scheduler to worker.
- sftp server - A simple SFTP server to test

### Credenciais do SFTP

- usuário: admin
- senha: admin
- Diretório raiz: shared

### Executar o projeto com Podman

```shell
bash first_init_podman.sh
```

### Executar o projeto com Podman

```shell
bash first_init_docker.sh
```

### Configurações para executar a DAG

### Conexões

Crie as seguintes conexões no airflow.

```yaml
  coindesk_connection:
    type: HTTP
    host: https://api.coindesk.com/v2/bpi

  sftp_connection:
    type: SFTP
    host: 0.0.0.0
    username: admin
    password: admin
    port: 22
    extra: '{"key_file": "~/.ssh/id_rsa", "no_host_key_check": "true"}'
```

### Variáveis

Import este json de variáveis no airflow.

```json
{
  "airflow_project_stage": "dev",
  "dev_configs": {
    "coin_api": {
      "conn_id": "coindesk_connection",
      "endpoint": "currentprice.json"
    },
    "sftp_server": {
      "conn_id": "sftp_connection"
    }
  }
}
```

### Acessar o Airflow ( Linha de Comando )

Suba o ambiente por completo e em um terminal, execute o seguinte comando:

```
docker container exec -it worker bash
```

Para ver a ajuda do airflow, digite:

```
airflow cheat-sheet
```

### Acessar variáveis nas Dags

Crie uma instancia da classe Environ ( lib.utils.Environ ) e acesse o atributo vars. Dentro dele estão todas as
variáveis criadas pelo usuário no Airflow.

```python
from lib.utils import Environ

env = Environ()

# Para ver todas as variaveis
print(env.vars)

# Para ver uma variavel especifica
print(env.vars.coin_api.conn_id)

# Outras formas de acesso
print(env.vars["coin_api"]["conn_id"])
print(env.vars.coin_api["conn_id"])
print(env.vars["coin_api"].conn_id)

for var in env.vars:
    print(var)
```