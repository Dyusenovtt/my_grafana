# Домашнее задание к занятию 14 «Средство визуализации Grafana»

## Инфраструктура

Для выполнения задания была развёрнута инфраструктура в Yandex Cloud с разделением ролей между виртуальными машинами:

*   **VM `myterra`** — используется для запуска **Terraform**. С его помощью создаётся целевая ВМ `monitoring` (Ubuntu 22.04, 2 vCPU, 4 GB RAM, 20 GB disk) в сети `monitoring-network` (подсеть `10.6.1.0/24`).
*   **VM `myansible`** — используется для запуска **Ansible**. Ansible по SSH подключается к ВМ `monitoring` и разворачивает на ней стек мониторинга.
*   **VM `monitoring`** — целевая машина, на которой развёрнут стек сервисов в **Docker Compose**.

**Стек мониторинга:**
*   `Node Exporter` — сборщик системных метрик.
*   `Prometheus` — база данных временных рядов (порт 9090).
*   `Grafana` (v13.3.0) — средство визуализации (порт 3000).

Все три сервиса запущены в изолированной Docker-сети `monitoring`, что позволяет Grafana обращаться к Prometheus по имени сервиса (`http://prometheus:9090`).

---

## Выполнение заданий

### Задание 1
Подключён источник данных **Prometheus** (URL: `http://prometheus:9090`).

### Задание 2
Создан Dashboard с четырьмя панелями. Использованы следующие PromQL-запросы:

1.  **Утилизация CPU (%):**
    `100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)`
2.  **CPULA 1/5/15:**
    `node_load1`, `node_load5`, `node_load15` (три отдельных запроса на одной панели)
3.  **Свободная оперативная память:**
    `node_memory_MemAvailable_bytes`
4.  **Свободное место на файловой системе:**
    `node_filesystem_avail_bytes{mountpoint="/",fstype!~"tmpfs|overlay"}`

### Задание 3
В качестве канала нотификации настроен **Email** (SMTP Яндекс.Почты).
Создан Contact Point `Email Alert` и Alert Rule `High CPU` (срабатывает при превышении заданного порога). Тестовое уведомление успешно доставлено на почту.

### Задание 4
JSON-модель дашборда экспортирована и сохранена в файл `dashboard.json`.




<img width="974" height="942" alt="image" src="https://github.com/user-attachments/assets/97912b8b-3462-4296-ba0b-b0f0a1946d58" />
<img width="974" height="462" alt="image" src="https://github.com/user-attachments/assets/e03d91dc-ca95-45ac-8554-538a3c4d1b5f" />
<img width="974" height="810" alt="image" src="https://github.com/user-attachments/assets/aacb684a-ecb7-419d-8979-cd7f001b33de" />
<img width="974" height="686" alt="image" src="https://github.com/user-attachments/assets/e676bcd7-69e2-4fbf-8df6-a797ee58f5a6" />
<img width="974" height="757" alt="image" src="https://github.com/user-attachments/assets/14d7c280-3d9f-4f80-b3d9-c2393cee5131" />
<img width="974" height="559" alt="image" src="https://github.com/user-attachments/assets/e6f49782-b328-4619-9070-c8c091a24c0d" />
<img width="974" height="686" alt="image" src="https://github.com/user-attachments/assets/35f29076-7945-4ce4-900e-2787f1d695ce" />
<img width="974" height="718" alt="image" src="https://github.com/user-attachments/assets/70f2ea12-db82-406b-a4f7-dd225c4f6ff2" />
<img width="974" height="884" alt="image" src="https://github.com/user-attachments/assets/f017651f-4178-4eea-9e45-c3ffc89790eb" />
<img width="974" height="687" alt="image" src="https://github.com/user-attachments/assets/8d14f98c-e7e9-4e3b-b7fb-2f4a5d7970f7" />





