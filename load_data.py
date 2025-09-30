import os
import psycopg2
import csv

# Variables de conexión (pueden venir de ENV)
DB_HOST = os.getenv("DB_HOST", "postgres_sakila")
DB_NAME = os.getenv("DB_NAME", "sakila")
DB_USER = os.getenv("DB_USER", "admin")
DB_PASS = os.getenv("DB_PASS", "admin123")
DATA_PATH = os.getenv("DATA_PATH", "/data")  # ruta montada con -v

# Tablas y archivos CSV en orden de carga (evita problemas de FK)
TABLES = [
    ("language", "language.csv", ["language_id", "name", "last_update"]),
    ("actor", "actor.csv", ["actor_id", "first_name", "last_name", "last_update"]),
    ("category", "category.csv", ["category_id", "name", "last_update"]),
    ("film", "film.csv", ["film_id", "title", "description", "release_year", "language_id",
                          "original_language_id", "rental_duration", "rental_rate", "length",
                          "replacement_cost", "rating", "last_update"]),
    ("film_category", "film_category.csv", ["film_id", "category_id", "last_update"]),
    ("film_actor", "film_actor.csv", ["actor_id", "film_id", "last_update"]),
    ("country", "country.csv", ["country_id", "country", "last_update"]),
    ("city", "city.csv", ["city_id", "city", "country_id", "last_update"]),
    ("address", "address.csv", ["address_id", "address", "address2", "district", "city_id",
                                "postal_code", "phone", "last_update"]),
    ("store", "store.csv", ["store_id", "manager_staff_id", "address_id", "last_update"]),
    ("staff", "staff.csv", ["staff_id", "first_name", "last_name", "address_id", "email",
                            "store_id", "active", "username", "password", "last_update"]),
    ("customer", "customer.csv", ["customer_id", "store_id", "first_name", "last_name",
                                  "email", "address_id", "active", "create_date", "last_update"]),
    ("inventory", "inventory.csv", ["inventory_id", "film_id", "store_id", "last_update"]),
    ("rental", "rental.csv", ["rental_id", "rental_date", "inventory_id", "customer_id",
                              "return_date", "staff_id", "last_update"]),
    ("payment", "payment.csv", ["payment_id", "customer_id", "staff_id", "rental_id",
                                "amount", "payment_date"])
]

def load_csv(cur, table, file, columns):
    filepath = os.path.join(DATA_PATH, file)
    print(f"📥 Cargando {file} en {table}...")
    with open(filepath, "r", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            values = [row[c] if row[c] != "" else None for c in columns]
            placeholders = ",".join(["%s"] * len(columns))
            query = f"INSERT INTO sakila.{table} ({','.join(columns)}) VALUES ({placeholders})"
            cur.execute(query, values)

def main():
    conn = psycopg2.connect(
        dbname=DB_NAME, user=DB_USER, password=DB_PASS, host=DB_HOST
    )
    conn.autocommit = True
    cur = conn.cursor()

    for table, file, columns in TABLES:
        load_csv(cur, table, file, columns)

    cur.close()
    conn.close()
    print("✅ Base de datos poblada con éxito.")

if __name__ == "__main__":
    main()
