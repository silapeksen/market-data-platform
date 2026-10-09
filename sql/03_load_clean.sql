/*
    inserting the values into clean.prices table from raw.prices table 
    while ensuring no duplicates with the help of the primary key.
*/
INSERT INTO clean.prices (ticker, datetime, open, high, low, close, volume, ingested_at)
SELECT DISTINCT ON(ticker, datetime) -- DISTINCT -> unique values, without any repeats (tr: ayırt edici)
    ticker, datetime, open, high, low, close, volume, ingested_at
FROM raw.prices
ORDER BY ticker, datetime, ingested_at DESC -- DESC -> 10 to 1, Z to A, New to Old (tr:sondan başa)
ON CONFLICT (ticker, datetime) DO UPDATE SET -- CONFLICT -> if there is a conflict, do the following (tr: çakışma)
    open = EXCLUDED.open,                    -- DO UPDATE -> if there is a conflict, update the existing record (tr: güncelleme yap)
    high = EXCLUDED.high,
    low = EXCLUDED.low,
    close = EXCLUDED.close,
    volume = EXCLUDED.volume,
    ingested_at = EXCLUDED.ingested_at; -- EXCLUDED -> new row that trying to be inserted (tr: çakışmada eklenmek istenen yeni satır)