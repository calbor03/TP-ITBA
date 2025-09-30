#!/bin/bash
set -e

# Variables
DB_CONTAINER="postgres_sakila"
DB_USER="admin"
DB_NAME="sakila"

# Ejecutar script
echo "Creando esquema y tablas Sakila en PostgreSQL..."
docker exec -i $DB_CONTAINER psql -U $DB_USER -d $DB_NAME < schema.sql
echo "✅ Esquema Sakila creado con éxito."
