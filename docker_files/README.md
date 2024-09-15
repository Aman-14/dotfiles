# Docker Compose Commands

## General Command Structure

```bash
docker compose -p <project> -f <docker-compose.yaml> up -d
```

## Specific Commands

### Run Databases

```bash
docker compose -p databases -f databases-docker-compose.yaml up -d
```

### Run Kafka

```bash
docker compose -p kafka -f kafka-docker-compose.yaml up -d
```

### Run open-webui

```bash
docker compose -p open-webui -f open-webui-docker-compose.yaml up -d
```
