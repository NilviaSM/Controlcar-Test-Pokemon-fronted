
# ControlCar Frontend

Este es el frontend para la prueba técnica de ControlCar, desarrollado en Flutter. La aplicación permite mostrar una lista paginada de pokémones y gestionar la captura y liberación de estos.

## Características

- Listado de pokémones paginado, con buscador por nombre y tipo.
- Visualización de pokémones capturados, con un límite de 6 capturas.
- Distinción visual de pokémones capturados en el listado principal.
- Captura y liberación de pokémones directamente desde la aplicación.

## Requisitos

- Flutter SDK instalado.
- Chrome configurado como navegador predeterminado para Flutter.

## Instalación

1. Instala las dependencias necesarias:
   ```bash
   flutter pub get
   ```

## Ejecución

1. flutter run -d chrome
   ```
2. La aplicación se abrirá en tu navegador Chrome.

## Estructura del Proyecto

- `lib/`: Carpeta principal del código fuente de la aplicación.
- `assets/`: Imágenes y otros recursos utilizados en la aplicación.
- `pubspec.yaml`: Archivo de configuración para las dependencias de Flutter.

## Endpoints Usados

- **GET /pokemons**: Devuelve la lista paginada de pokémones con filtros opcionales por nombre y tipo.
- **POST /pokemons/capture**: Cambia el estado de un pokémon a capturado. Si ya hay 6 pokémones capturados, se libera el más antiguo.
- **PUT /pokemons/release**: Libera un pokémon capturado.



## Contacto

Si tienes alguna duda o sugerencia, por favor, contáctame a través de nilvia.sepulveda@gmail.com .
