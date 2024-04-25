# Importing  Libraries
import pandas as pd
from sqlalchemy import create_engine

# PostgreSQL Connection String
conn_string = 'postgresql://{YOUR_USERNAME}:{YOUR_PASSWORD}@{YOUR_HOST}:{YOUR_PORT_NUMBER}/{YOUR_DATABASE_NAME}'
db = create_engine(conn_string)
conn = db.connect()

# List of CSV Files
files = ['artist', 'canvas_size', 'image_link', 'museum_hours', 'museum', 'product_size', 'subject', 'work']

# Loop through each csv file and import to PostgreSQL
for file in files:
       # Read the CSV files from the specified directory
             df = pd.read_csv(f'{YOUR_DIRECTORY_OF_CSV_FILES}/{file}.csv')
       # Write the DataFrame to PostgreSQL database
             df.to_sql(file, con=conn, if_exists='replace', index=False)



# REMEMBER TO INSTALL NECESSARY LIBRARIES FOR YOUR DATABASE SYSTEM - IN THIS CASE IT'S pandas, sqlalchemy AND psycopg2-binary *OR* psycopg2. FOR MY MySQL IT WILL BE pandas, sqlalchemy AND mysql-connector-python *OR* you can use pymysql.
# REMEMBER TO REPLACE {YOUR_INFORMATION} WITH YOUR ACTUAL CREDENTIALS
