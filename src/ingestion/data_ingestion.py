import yfinance as yf
import pandas as pd
from datetime import datetime
from sqlalchemy import create_engine

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

    # Remove the time zone information (+00:00), for database compatibility
    df['datetime'] = df['datetime'].dt.tz_localize(None)

    # Add metadata tags
    df['ticker'] = ticker_symbol # Adding a column for the ticker symbol as metadata
    df['ingested_at'] = datetime.now() # Adding a column for the ingestion timestamp as metadata

    print(f"---Transformation completed for {ticker_symbol} at {datetime.now()}---")
    return df # Returning the transformed DataFrame

# Load

def load_data(df, db_name="market_data.db"):
    if df is None or df.empty:
        print("No data to load.")
        return
    
    try:
        engine = create_engine(f'sqlite:///{db_name}')
        df.to_sql('prices', engine, if_exists='append', index=False)
        print(f"--- Loading completed at {datetime.now()}, db: {db_name} ---")
    except Exception as e:
        print(f"Error loading data into database: {e}")

# MAIN EXECUTION ***

symbol = "BTC-USD"
raw_data = fetch_market_data(symbol) # Excracting the raw data for the specified symbol

if raw_data is not None:
    
    clean_data = transform_data(raw_data, symbol) # Transforming the raw data
    
    if clean_data is not None:
        load_data(clean_data) # Loading the transformed data into the database

    print("\nSample of the ETL data:")
    print(clean_data.head(2)) # Displaying 2