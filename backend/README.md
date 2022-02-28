# API

## Dependencias

Para ejecutar este proyecto es necesario tener `python` 3.7+ instalado, así como `pip`.

Instala las dependencias con:

```bash
pip install -r requirements.txt
```

## Ejecución en modo desarrollo

Crea la variable de ambiente `FLASK_APP` para indicar al servidor de Flask que módulo vas a correr:

```bash
export FLASK_APP=app.py
```

Y ejecuta la aplicación con el servidor de desarrollo de Flask (puedes cambiar el puerto si lo deseas):

```bash
python -m flask run --host=0.0.0.0 --port=8000
```

## Ejecución con gunicorn

Para utilizar el servidor Gunicorn con el puerto 8000, ejecuta el siguiente comando:

```bash
gunicorn -w 3 -b 0.0.0.0:8000 app:app
```