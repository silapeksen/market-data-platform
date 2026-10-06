CREATE SCHEMA IF NOT EXISTS raw;
CREATE SCHEMA IF NOT EXISTS clean;

CREATE TABLE IF NOT EXISTS raw.prices (
    datetime    TIMESTAMP,
    open        NUMERIC(18,8),
    high        NUMERIC(18,8),
    low         NUMERIC(18,8),
    close       NUMERIC(18,8),
    volume      BIGINT,
    ticker      TEXT,
    ingested_at TIMESTAMP
);
