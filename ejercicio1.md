# Ejercicio 1 - Elección de Dataset y Preguntas de Negocio

## Dataset elegido: Sakila

El dataset **Sakila** es una base de datos de ejemplo creada originalmente para MySQL y portada a PostgreSQL.  
Simula el esquema de un videoclub, incluyendo información de:

- **Películas**: títulos, duración, clasificación, idioma.  
- **Clientes**: nombres, direcciones, ciudades y países.  
- **Alquileres**: historial de préstamos de películas a clientes, con fechas de alquiler y devolución.  
- **Pagos**: registros de los montos pagados por cada cliente.  
- **Empleados y Tiendas**: información de las sucursales y quién las administra.  

Este dataset permite practicar modelado, consultas SQL y análisis de negocio en un entorno realista.

## Preguntas de negocio

1. **¿Cuáles son las películas más rentables del videoclub?**  
   → Se puede calcular sumando los pagos asociados a cada película.  

2. **¿Qué clientes generan mayores ingresos en alquileres?**  
   → Identificar los clientes con mayor monto total pagado.  

3. **¿Cuál es la duración promedio de los alquileres según categoría de película (acción, comedia, drama, etc.)?**  
   → Relacionar `rental` con `film_category`.  

4. **¿Qué sucursal (store) es la más rentable?**  
   → Comparar ingresos entre las diferentes tiendas y sus empleados.  

5. *(opcional extra)*: **¿Existen patrones de estacionalidad en los alquileres?**  
   → Analizar la cantidad de alquileres por mes.  

---
