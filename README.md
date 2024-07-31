# Aplicación Flutter - ColorApp
<p>Esta es una aplicación que permite medir la capacidad de reacción mediante un juego de colores, el usuario podrá medir su capacidad, accediendo a diferentes opciones de juego y guardando su puntaje.</p>

## Fucionamiento
### Juego nuevo 
<p>Encontraremos la vista del juego nuevo, que permitirá al usuario jugar con los valores predeterminados, también le permitirá guardar su nombre con el puntaje alcanzado y se mostrarán en pantalla los datos del juego conforme este avance, además de la opción de pausar el juego en cualquqier momento.
</p>

- `lib/views/nuevojuego.dart`

### Juego Personalizado 
<p>En esta vista, el usuario podrá jugar con los valores que desee, permitiendole cambiar el tiempo de juego, el tiempo por palabra y el número de intentos, también se mostrarán en pantalla los datos del juego conforme este avance, además de la opción de pausar el juego en cualquqier momento.
</p>

- `lib/views/juego_personalizado.dart`

### Mejores puntajes
<p>El usuario podrá visualizar los mejores 5 puntajes, en esta vista se acceden a los datos cargados de Firestore (Firebase).
</p>

- `lib/views/mejores_puntajes.dart`

## Ejecución del proyecto
>Ejecuta en tu terminal o linea de comandos:
	                    
#### 1. Clonar el proyecto

```bash
git clone https://github.com/lessli3/ColorApp.git

```
#### 2. Instalación de dependencias
   
```bash
flutter pub get

```
#### 3. Ejecutar aplicación
   
```bash
flutter run
```

## Recomendaciones
>Si decides trabajar con Firestore (Firebase) debes tener en cuenta que debes realizar el proceso de conexión al proyecto siguiendo las instrucciones detalladas que proporciona:
	                    
#### https://console.firebase.google.com/u/0/?hl=es-419
