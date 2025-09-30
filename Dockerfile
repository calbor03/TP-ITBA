# Imagen base
FROM python:3.9-slim

# Directorio de trabajo
WORKDIR /app

# Copiar scripts al contenedor
COPY load_data.py .
COPY report_queries.py .

# Instalar dependencias necesarias
RUN pip install psycopg2-binary pandas

# Por defecto no ejecutamos nada, usamos CMD con argumento
ENTRYPOINT ["python"]
CMD ["load_data.py"]

