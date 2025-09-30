# Trabajo Práctico Intermedio - Foundations (ITBA)

Este repositorio contiene la resolución del Trabajo Práctico Intermedio de la sección **Foundations** del Módulo 1 de la Diplomatura en Cloud Data Engineering (ITBA).  

El objetivo es poner en práctica conocimientos de **PostgreSQL, Bash, Python, Docker y GitHub Flow** mediante una serie de ejercicios que construyen sobre el avance del anterior.

---

##Ejercicio 1: Elección de dataset y preguntas de negocio

Se eligió el dataset **Sakila** (base de datos de ejemplo para videoclub, adaptada a PostgreSQL).  

### Preguntas de negocio propuestas
1. ¿Cuáles son las películas más rentables del videoclub?  
2. ¿Qué clientes generan mayores ingresos en alquileres?  
3. ¿Cuál es la duración promedio de los alquileres según categoría de película?  
4. ¿Qué sucursal es la más rentable?  

Archivo relacionado: [`ejercicio1.md`](ejercicio1.md)

---

##Ejercicio 2: Crear container de la DB

Se creó un archivo `docker-compose.yml` que levanta un contenedor con **PostgreSQL 12.7** exponiendo el puerto estándar `5432`.  

### Comando
```bash
docker-compose up -d
```

Esto crea un contenedor llamado `postgres_sakila` con usuario `admin`, contraseña `admin123` y base de datos inicial `sakila`.

Archivo relacionado: [`docker-compose.yml`](docker-compose.yml)

---

##Ejercicio 3: Script para creación de tablas

Se implementó un script de Bash que ejecuta el archivo `schema.sql` (definición completa del esquema Sakila).  

### Comando
```bash
./create_tables.sh
```

Esto crea todas las tablas, claves primarias y foráneas necesarias.  

Archivos relacionados:  
- [`schema.sql`](schema.sql)  
- [`create_tables.sh`](create_tables.sh)  

---

##Ejercicio 4: Popular la base de datos

Se desarrolló un script en **Python 3.9** (`load_data.py`) que lee los archivos CSV del dataset Sakila y los inserta en la base de datos PostgreSQL.  

El script se ejecuta dentro de un contenedor de Docker a partir de un `Dockerfile`.  
Los datos se montan mediante un volumen (`/data`) para que no formen parte de la imagen.  

### Construcción de la imagen
```bash
docker build -t sakila-tools .
```

### Ejecución del loader
```bash
docker run --rm   --network=host   -e DB_HOST=localhost   -e DB_USER=admin   -e DB_PASS=admin123   -e DB_NAME=sakila   -e DATA_PATH=/data   -v $(pwd)/data:/data   sakila-tools load_data.py
```

Esto carga todos los datos en las tablas del esquema Sakila, dejando la base lista para consultas.  

Archivos relacionados:  
- [`load_data.py`](load_data.py)  
- [`Dockerfile`](Dockerfile)  
- Carpeta `data/` con los CSV  

---

##Ejercicio 5: Consultas a la base de datos

Se desarrolló un script en **Python 3.9** (`report_queries.py`) que ejecuta 5 consultas SQL con valor de negocio y muestra un reporte por pantalla.  

### Consultas implementadas
1. **Top 10 películas más rentables**.  
2. **Top 10 clientes que más gastaron**.  
3. **Cantidad de películas por categoría**.  
4. **Ingresos por sucursal**.  
5. **Cantidad de alquileres por mes**.  

### Ejecución del reporte
```bash
docker run --rm   --network=host   -e DB_HOST=localhost   -e DB_USER=admin   -e DB_PASS=admin123   -e DB_NAME=sakila   sakila-tools report_queries.py
```

Esto muestra en consola un reporte tabulado con los resultados de cada consulta.  

Archivos relacionados:  
- [`report_queries.py`](report_queries.py)  
- [`Dockerfile`](Dockerfile) (compartido con Ejercicio 4)  
