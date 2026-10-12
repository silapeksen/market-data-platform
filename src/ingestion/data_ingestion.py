import os # operating syst
import yfinance as yf
from datetime import datetime
from dotenv import load_dotenv # package reads .env file
from sqlalchemy import create_engine, URL # URL is the SQLAlchemy’s connection link generator

load_dotenv() # read .env file

# Constants
TICKERS = ["BTC-USD", "ETH-USD", "USDTRY=X"]

# Extract

def fetch_market_data(ticker_symbol):
    """
    -> Retrieve the last 24 hours of data for the specified symbol at 1-minute intervals
    """

    try: # For error handling during data retrieval
        print(f"{ticker_symbol} data retrieval started at {datetime.now()}")
        ticker = yf.Ticker(ticker_symbol) # Retrieving data via yfinance
        df = ticker.history(period="1d", interval="1m") # Fetching 1-minute interval data for the last day

        if df.empty:
            print(f"Warning: No data retrieved for {ticker_symbol}.")
            return None    
    
        return df # Returning the DataFrame containing the market data
    except Exception as e:
        print(f"Error fetching data for {ticker_symbol}: {e}")
        return None

# Transform

def transform_data(df, ticker_symbol):
    """
    -> Cleans raw data, standardizes naming and adds metadata (tags).
    """
    if df is None or df.empty:
        return None
    
    # Convert the Index (Datetime) to a regular column
    df = df.reset_index()

    # Column selecting
    required_columns = ['Datetime', 'Open', 'High', 'Low', 'Close', 'Volume']
    df = df[required_columns].copy()

    # Lowercase column names (uppercase letters sometimes cause problems in SQL)
    df.columns = [col.lower() for col in df.columns]

    # Timezone conversion and localization
    df['datetime'] = df['datetime'].dt.tz_convert("UTC").dt.tz_localize(None)

    # Add metadata tags
    df['ticker'] = ticker_symbol # Adding a column for the ticker symbol as metadata
    df['ingested_at'] = datetime.now() # Adding a column for the ingestion timestamp as metadata

    print(f"---Transformation completed for {ticker_symbol} at {datetime.now()}---")
    return df # Returning the transformed DataFrame

# Load

def get_engine():
    url = URL.create(
        drivername="postgresql+psycopg2",
        username=os.getenv("POSTGRES_USER"),
        password=os.getenv("POSTGRES_PASSWORD"),
        host="localhost",
        port=5432,
        database=os.getenv("POSTGRES_DB"),
    )
    return create_engine(url)

def load_data(df):
    if df is None or df.empty:
        print("No data to load.")
        return

    try:
        engine = get_engine()
        df.to_sql("prices", engine, schema="raw", if_exists="append", index=False)
        print(f"--- Loading completed at {datetime.now()} ---")
    except Exception as e:
        print(f"Error loading data into database: {e}")


def run_pipeline(ticker_symbol):

    # önce raw bi şekilde data çekiliyor.
    raw_data = fetch_market_data(ticker_symbol)

    # raw data standardize edilip etiketleniyor (columns, ticker, ingested_at).
    clean_data = transform_data(raw_data, ticker_symbol)
    
    # sonr data sql tarafında(DISTINC + ON CONFLICT) temizleniyor(clean.prices katmanı)
    load_data(clean_data)

    if clean_data is not None:
        print(f"\nSample of {ticker_symbol}:")
        print(clean_data.head(2))

def main():
    # TICKER constant ındaki sembolleri tek tek run_pipeline a atıyor.
    for symbol in TICKERS:
        run_pipeline(symbol)

if __name__ == "__main__":
    main()