# PostgreSQL Docker Cluster

## 🐳 Quick Start

```bash
docker-compose up -d
```

## 🗄️ Import Existing Data

```bash
docker exec -i postgres-db psql -U postgres < full.dump.sql
```

## 🔌 Connect to PostgreSQL

```bash
psql -h localhost -U postgres
```

Default password: `abcdf`
