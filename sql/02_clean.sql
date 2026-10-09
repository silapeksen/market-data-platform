/*
    Creating the clean.prices table if it does not exist.
*/

CREATE TABLE IF NOT EXISTS clean.prices (
    ticker      TEXT        NOT NULL,
    datetime    TIMESTAMP   NOT NULL,
    open        NUMERIC(18,8),
    high        NUMERIC(18,8),
    low         NUMERIC(18,8),
    close       NUMERIC(18,8),
    volume      BIGINT,
    ingested_at TIMESTAMP,
    PRIMARY KEY (ticker, datetime)
);