# Desplegando Mythical Mysfits en un servidor EC2

El reto es desplegar el backend y frontend dentro de un servidor EC2 de forma manual.

## Instrucciones

1. **EC2**

Crear un servidor `t2.micro` usando Amazon Linux 2 para desplegar ambos componentes.

Asegurarse de crear o elegir una llave privada `.pem` a la que tengamos acceso para poder conectarnos a través de SSH al servidor.

2. **Backend**

Instalar `python3` y `pip` en el servidor. Leer el archivo [backend/README.md](../../backend/README.md) para más información sobre cómo ejecutar la aplicación con `gunicorn`.

3. **Frontend**

Desplegar la aplicación ocupando `nginx` o `apache`. Se debe modificar el archivo `index.html` para incluir la dirección correcta del backend.

## Validación

Visitar la IP pública del servidor y validar que la aplicación funciona correctamente

## Limpieza

Borrar el servidor EC2 y el Security Group creado