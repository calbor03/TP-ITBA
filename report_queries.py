import os
import psycopg2
import pandas as pd

# Variables de conexión
DB_HOST = os.getenv("DB_HOST", "postgres_sakila")
DB_NAME = os.getenv("DB_NAME", "sakila")
DB_USER = os.getenv("DB_USER", "admin")
DB_PASS = os.getenv("DB_PASS", "admin123")

QUERIES = {
    "Top 10 películas más rentables":
    """
    SELECT f.title, SUM(p.amount) AS revenue
    FROM payment p
    JOIN rental r ON p.rental_id = r.rental_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    GROUP BY f.title
    ORDER BY revenue DESC
    LIMIT 10;
    """,

    "Top 10 clientes que más gastaron":
    """
    SELECT c.first_name || ' ' || c.last_name AS customer, SUM(p.amount) AS total_spent
    FROM payment p
    JOIN customer c ON p.customer_id = c.customer_id
    GROUP BY customer
    ORDER BY total_spent DESC
    LIMIT 10;
    """,

    "Cantidad de películas por categoría":
    """
    SELECT cat.name, COUNT(*) AS film_count
    FROM film_category fc
    JOIN category cat ON fc.category_id = cat.category_id
    GROUP BY cat.name
    ORDER BY film_count DESC;
    """,

    "Ingresos por sucursal":
    """
    SELECT s.store_id, SUM(p.amount) AS revenue
    FROM payment p
    JOIN staff st ON p.staff_id = st.staff_id
    JOIN store s ON st.store_id = s.store_id
    GROUP BY s.store_id
    ORDER BY revenue DESC;
    """,

    "Cantidad de alquileres por mes":
    """
    SELECT DATE_TRUNC('month', r.rental_date) AS month, COUNT(*) AS rentals
    FROM rental r
    GROUP BY month
    ORDER BY month;
    """
}

def run_queries():
    conn = psycopg2.connect(
        dbname=DB_NAME, user=DB_USER, password=DB_PASS, host=DB_HOST
    )
    cur = conn.cursor()

    for title, query in QUERIES.items():
        print("\n" + "="*80)
        print(title)
        print("="*80)

        cur.execute(query)
        rows = cur.fetchall()
        colnames = [desc[0] for desc in cur.description]

        df = pd.DataFrame(rows, columns=colnames)
        print(df.to_string(index=False))

    cur.close()
    conn.close()

if __name__ == "__main__":
    run_queries()
