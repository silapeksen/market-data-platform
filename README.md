# Market Data Platform

An end-to-end data engineering project: ingest market data (stocks, FX, crypto, macro indicators), orchestrate pipelines, model the data in a warehouse, and serve it for analytics. Built phase by phase to learn and demonstrate the modern data engineering stack.


## Goals

- Batch ingestion (daily pulls, historical backfill)
- Streaming ingestion (live price feed)
- Orchestration, testing, and monitoring
- Dimensional modeling (staging -> marts)
- Cloud deployment and CI/CD

## Planned architecture

```
 Sources              Ingestion        Storage / Warehouse        Serving
┌──────────────┐    ┌───────────┐    ┌──────────────────────┐   ┌───────────┐
│ yfinance     │    │  Python   │    │ PostgreSQL (Phase 1) │   │ Power BI  │
│ Binance API  │───>│  Airflow  │───>│ dbt models (Phase 3) │──>│ Dashboards│
│ TCMB EVDS    │    │  Kafka    │    │ BigQuery / S3 (P4)   │   └───────────┘
└──────────────┘    └───────────┘    └──────────────────────┘
                     (Phase 2, 5)           Spark (Phase 5)
```

## Tech stack (planned)

| Layer | Tools |
|---|---|
| Language | Python, SQL |
| Storage | PostgreSQL, later BigQuery or S3 |
| Orchestration | Apache Airflow |
| Transformation | dbt, PySpark |
| Streaming | Kafka |
| Infra | Docker, docker-compose, GitHub Actions |
| BI | Power BI |

## Project structure

```
src/ingestion/   # pull data from APIs
src/transform/   # clean and standardize
src/load/        # write to the database
sql/             # schemas and queries
dags/            # Airflow DAGs (Phase 2)
tests/           # unit and data-quality tests
docs/            # notes, diagrams, learning log
```

## Getting started

1. Copy the environment file and set your own password:
   ```
   cp .env.example .env
   ```
2. Start the database:
   ```
   docker compose up -d
   ```
3. Check it is healthy:
   ```
   docker compose ps
   ```

## Author

Sıla Pekşen, Computer Engineering, Istanbul Aydin University.
[GitHub](https://github.com/silapeksen) · [LinkedIn](https://www.linkedin.com/in/sila-peksen)
