#!/bin/bash
set -e

echo "Iniciando ejecución end2end del TP..."

# 1. Levantar contenedor de PostgreSQL
echo "📦 Levantando contenedor de PostgreSQL..."
docker-compose up -d

# 2. Esperar a que Postgres esté listo
echo "Esperando a que PostgreSQL inicie..."
sleep 10

# 3. Crear tablas
echo "Creando tablas..."
./create_tables.sh

# 4. Construir imagen
echo "🔨 Construyendo imagen Docker..."
docker build -t sakila-tools .

# 5. Cargar datos
echo "Cargando datos..."
docker run --rm \
  --network=host \
  -e DB_HOST=localhost \
  -e DB_USER=admin \
  -e DB_PASS=admin123 \
  -e DB_NAME=sakila \
  -e DATA_PATH=/data \
  -v $(pwd)/data:/data \
  sakila-tools load_data.py

# 6. Ejecutar consultas
echo "Ejecutando reportes..."
docker run --rm \
  --network=host \
  -e DB_HOST=localhost \
  -e DB_USER=admin \
  -e DB_PASS=admin123 \
  -e DB_NAME=sakila \
  sakila-tools report_queries.py

echo "Proceso end2end finalizado con éxito."
