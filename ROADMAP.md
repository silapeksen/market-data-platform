# Roadmap

Each phase ends with a working milestone, an updated README, and a release tag.
Reference: https://roadmap.sh/data-engineer

## Phase 0: Foundation (Oct 2026)
- [ ] Rename repo to `market-data-platform`
- [ ] Create folder structure
- [ ] README with architecture sketch
- [ ] GitHub milestones and issues created
- [ ] `docs/learning-log.md` started
- [ ] Docker Desktop and WSL2 (Ubuntu) working
- [ ] Update GitHub bio, pin this repo

## Phase 1: SQL, Linux, PostgreSQL (Oct-Nov 2026)
- [ ] Run Postgres with docker-compose (volume, healthcheck)
- [ ] Connect with `psql`, create schemas `raw` and `clean`
- [ ] Move ingestion from SQLite to Postgres
- [ ] Write window-function queries (moving average, returns)
- [ ] Write join queries (stocks vs FX)
- [ ] Practice Linux commands inside an Ubuntu container

## Phase 2: Orchestration (Nov-Dec 2026)
- [ ] Airflow in docker-compose
- [ ] Daily ingestion DAG
- [ ] Retries, backfill, idempotent loads
- [ ] Config file and logging
- [ ] pytest unit tests

## Phase 3: Modeling with dbt (Jan-Feb 2027)
- [ ] dbt project with staging and mart layers
- [ ] `dim_instrument`, `dim_date`, `fact_price`
- [ ] dbt tests
- [ ] Power BI dashboard

## Phase 4: Cloud and CI/CD (Feb-Mar 2027)
- [ ] Move storage to GCP (GCS + BigQuery) or AWS
- [ ] GitHub Actions: lint and tests
- [ ] Cost alerts configured

## Phase 5: Streaming and Spark (Mar-Apr 2027)
- [ ] Binance websocket to Kafka
- [ ] Kafka consumer writes to storage
- [ ] PySpark job on historical data

## Phase 6: Polish (May-Jun 2027)
- [ ] Documentation and architecture diagram
- [ ] Short demo video
- [ ] Interview prep: explain every design decision

## Workflow rules
- One issue per task, one branch per issue, merge via PR
- Commit format: `feat:`, `fix:`, `docs:`, `chore:`
- Update README and this file at the end of each phase
