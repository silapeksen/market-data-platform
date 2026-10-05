import sqlite3
import pandas as pd

conn = sqlite3.connect('market_data.db') # Connect to db

query = "SELECT * FROM prices" # Select everthing from the 'prices' table
df_check = pd.read_sql_query(query, conn)

conn.close() # Close connection

# Results
print(f"Total Records in Database: {len(df_check)}") # 559
print("\nLast 5 Rows in Database:")
print(df_check.tail())