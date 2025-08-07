import oracledb
import time
import os
from datetime import datetime

def wait_for_database():
    max_attempts = 30
    attempt = 0
    while attempt < max_attempts:
        try:
            connection = oracledb.connect(
                user="system",
                password=os.getenv("ORACLE_PASSWORD", "YourPass321"),
                dsn="oracle:1521/ORCLPDB1"
            )
            print("Successfully connected to Oracle Database!")
            return connection
        except Exception as e:
            print(f"Attempt {attempt + 1}/{max_attempts}: Database not ready yet... {str(e)}")
            attempt += 1
            time.sleep(10)
    raise Exception("Could not connect to the database after maximum attempts")

def test_database_operations(connection):
    cursor = connection.cursor()
    
    # Create a test table
    try:
        cursor.execute("""
            CREATE TABLE test_table (
                id NUMBER GENERATED ALWAYS AS IDENTITY,
                message VARCHAR2(100),
                created_at TIMESTAMP,
                PRIMARY KEY (id)
            )
        """)
        print("Test table created successfully!")
    except oracledb.DatabaseError as e:
        error = e.args[0]
        if error.code == 955:  # Table already exists
            print("Test table already exists")
        else:
            raise

    # Insert a test record
    cursor.execute("""
        INSERT INTO test_table (message, created_at)
        VALUES (:1, :2)
    """, ["Test message from Python", datetime.now()])
    connection.commit()
    print("Test record inserted successfully!")

    # Query the test record
    cursor.execute("SELECT * FROM test_table")
    rows = cursor.fetchall()
    print("\nTest Records:")
    for row in rows:
        print(f"ID: {row[0]}, Message: {row[1]}, Created At: {row[2]}")

    cursor.close()

def main():
    print("Waiting for Oracle Database to be ready...")
    try:
        connection = wait_for_database()
        test_database_operations(connection)
        print("\nAll database operations completed successfully!")
    except Exception as e:
        print(f"Error: {str(e)}")
    finally:
        if 'connection' in locals():
            connection.close()

if __name__ == "__main__":
    main() 