import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:color_app/home.dart';
import 'package:flutter/material.dart';
//import fontawesome
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import math para random
import 'dart:math';
//import async para el tiempo
import 'dart:async';
//import para guardar datos
import 'package:shared_preferences/shared_preferences.dart';


//Se crea la clase JuegoPersonalizado
class JuegoPersonalizado extends StatefulWidget {
  //se define un booleano para la configuración
  final bool mostrarConfiguracion;
  const JuegoPersonalizado({Key? key, required this.mostrarConfiguracion}) : super(key: key);

  @override
  State<JuegoPersonalizado> createState() => _JuegoPersonalizadoState();
}

class _JuegoPersonalizadoState extends State<JuegoPersonalizado> {
  //definimos una lista con los colores (en figuras)
  final List<Color> colores = [Colors.red, Colors.yellow, Colors.blue, Colors.green];
  //definimos una lista para los colores (en palabras)
  final List<String> colorestext = ["Rojo", "Amarillo", "Azul", "Verde"];

  //lista para mezclar la lista de colores (palabras)
  List<Color> mezclapalabras = [];

  //palabra que va a tener el color
  String palabra = "";
  //variable para el color del texto que muestra el nombre del color
  Color colortexto = Colors.black;
  //variable para almacenar el color correcto
  Color colorcorrecto = Colors.black;
  //variable para guardar el puntaje
  int puntaje = 0;
  //variable para temporizador
  Timer? _tiempo;
  int _tiempoRestante = 0;
  //variable contar intentos
  int intentosfallidos = 0;
  //variable contar palabras correctas
  int palabras_correctas = 0;
  //variable contar pausas
  int contadorPausas = 0;
  //variable duración de la palabra por defecto
  int duracionpalabra = 3000;
  //variable para la duracion de la palabra
  Timer? _duracionPalabraTimer;
  //variable para ediar el tiempo
  bool _editarTiempo = false;
  //controlador para recibir los datos que ingrese el usuario
  final TextEditingController _controllerTiempo = TextEditingController();

  @override
  //Método initState para que se ejecute la funcion antes de que se dibuje la app
  void initState() {
    super.initState();
    //Hace referencia al widget asociado con el estado actual
    if (widget.mostrarConfiguracion) {
      //_mostrarConfiguracion se ejecutará tan pronto como se dibuje la app
      Future.delayed(Duration.zero, _mostrarConfiguracion);
    } else {
      //Si mostrarConfiguracion es falsa, se llaman a estas dos funciones.
      _cargarConfiguracion();
      _generarpalabracolor();
    }
  }

  //Método para cargar la configuración de la partida
  void _cargarConfiguracion() async {
    // Obtiene la instancia de SharedPreferences de forma asíncrona
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      //Recupera el valor para la clave intentosfallidos, o usa 0 si no existe.
      intentosfallidos = prefs.getInt('intentosfallidos') ?? 0;
      //Recupera el valor para la clave tiemporestante, o usa 0 si no existe.
      _tiempoRestante = prefs.getInt('tiempoRestante') ?? 0;
      //Recupera el valor para la clave duracionpalabra, o usa 3000 si no existe.
      duracionpalabra = prefs.getInt('duracionpalabra') ?? 3000;
      //despues de cargar los datos genera la funcion
      _generarpalabracolor();
    });
  }

  //Mostrar la configuración para la partida
  void _mostrarConfiguracion() async {
    // Crea controladores de texto con los valores actuales de configuración.
    final TextEditingController _controllerIntentos = TextEditingController(text: '$intentosfallidos');
    final TextEditingController _controllerTiempo = TextEditingController(text: '$_tiempoRestante');
    final TextEditingController _controllerDuracionPalabra = TextEditingController(text: '$duracionpalabra');

    //variable para editar los intentos
    bool _editarIntentos = false;
    //variable para editar el tiempo
    bool _editarTiempo = false;
    //variable para editar la duracion de la palabra
    bool _editarDuracionPalabra = false;

    //Mostrar un modal desde abajo
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter modalSetState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              //Coontenido del modal
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Text("Configuración de la partida:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                        color: Colors.deepPurpleAccent
                      ),),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: Row(
                        children: [
                          // el checkbox se controla con la variable _editarIntentos.
                          // Si _editarIntentos es true, el checkbox estará marcado
                          Checkbox(
                            value: _editarIntentos,
                          //función de callback cuando el usuario cambia el estado del checkbox.
                            //value es el nuevo estado del checkbox.
                            onChanged: (bool? value) {
                              //Actualizar estado
                              modalSetState(() {
                                //se le asigna el nuevo valor
                                _editarIntentos = value ?? false;
                              });
                            },
                          ),
                          Text("Editar número de intentos",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15
                          ),),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          // el checkbox se controla con la variable _editarIntentos.
                          // Si _editarTiempo es true, el checkbox estará marcado
                          Checkbox(
                            value: _editarTiempo,
                            //onchange - función de callback cuando el usuario cambia el estado del checkbox.
                            //value es el nuevo estado del checkbox.
                            onChanged: (bool? value) {
                              //actualizar estado
                              modalSetState(() {
                                //se le aasigna el nuevo valor
                                _editarTiempo = value ?? false;
                              });
                            },
                          ),
                          Text("Editar tiempo",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15
                            ),),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: Row(
                        children: [
                          // el checkbox se controla con la variable _editarIntentos.
                          // Si _editarduracionpalabra es true, el checkbox estará marcado
                          Checkbox(
                            value: _editarDuracionPalabra,
                            //onchange - función de callback cuando el usuario cambia el estado del checkbox.
                            //value es el nuevo estado del checkbox.
                            onChanged: (bool? value) {
                              //actualizar el estado
                              modalSetState(() {
                                //asignar el nuevo valor
                                _editarDuracionPalabra = value ?? false;
                              });
                            },
                          ),
                          Text("Editar duración de la palabra",
                            style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15
                            ),),
                        ],
                      ),
                    ),
                    //Si se selecciona editarIntentos entonces se mostrará el textfield
                    if (_editarIntentos) ...[
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: TextField(
                          controller: _controllerIntentos,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Número de intentos',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                    //Si se selecciona editarTiempo entonces se mostrará el textfield
                    if (_editarTiempo) ...[
                      SizedBox(height: 10),
                      TextField(
                        controller: _controllerTiempo,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Tiempo en segundos',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                    //Si se selecciona editarDuracionPalabra entonces se mostrará el textfield
                    if (_editarDuracionPalabra) ...[
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: TextField(
                          controller: _controllerDuracionPalabra,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Duración de la palabra (ms)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                    SizedBox(height: 20),

                    //Seccion para los botones
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [

                        //Botón para regresar al inicio
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
                            },
                            child: Text('Regresar',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.deepPurpleAccent
                              ),),
                          ),
                        ),

                        //Botón para guardar la configuración
                        ElevatedButton(
                          onPressed: () {
                            //Se definen las variables con los datos de los controladores y si no sus valores por defecto
                            final intentos = _editarIntentos ? int.tryParse(_controllerIntentos.text) ?? 0 : 0;
                            final tiempo = _editarTiempo ? int.tryParse(_controllerTiempo.text) ?? 0 : _tiempoRestante;
                            final duracionPalabra = _editarDuracionPalabra ? int.tryParse(_controllerDuracionPalabra.text) ?? 3000 : duracionpalabra;

                            Navigator.of(context).pop();
                            //actualizar por los nuevos valores
                            setState(() {
                              intentosfallidos = intentos;
                              _tiempoRestante = tiempo;
                              duracionpalabra = duracionPalabra;
                              //generar nuevo juego con los valores dados
                              _generarpalabracolor();
                            });
                            //se guarda la configuración
                            _guardarConfiguracion();
                          },
                          child: Text('Guardar cambios',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.green
                            ),),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Divider(
                        height: 5,
                        color: Colors.grey,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      //Botón para cargar la configuración anterior
                      child: ElevatedButton(
                        onPressed: () {
                          _cargarConfiguracion(); // Llama al método para cargar la configuración guardada
                        },
                        child: Text('Cargar configuración anterior',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.blue
                          ),),
                      ),
                    )

                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  //Método para generar un nuevo juego
  void _generarpalabracolor() {
    //Se define para obtener el aleatorio
    final random = Random();

    //genera un índice aleatorio para la palabra y el color correcto
    int palabracolor = random.nextInt(colores.length);

    //lista de índices y eliminar el índice seleccionado para la palabra
    List<int> coloresrestantes = List.generate(colores.length, (index) => index)
      ..remove(palabracolor);

    //Se selecciona un índice aleatorio de los índices que se guardaron
    int colorfinal = coloresrestantes[random.nextInt(coloresrestantes.length)];

    //Se actualiza el estado
    setState(() {
      palabra = colorestext[palabracolor]; // Palabra asociada con palabracolor
      colorcorrecto = colores[colorfinal]; // Color correcto asociado con palabracolor
      colortexto = colores[colorfinal]; // Color del texto diferente del color correcto
      mezclapalabras = List.from(colores)..shuffle(); // Lista de colores mezclada para mostrar en la palabra

      //Cancela el temporizador si _duracionPalabraTimer no es null
      _duracionPalabraTimer?.cancel();
      _duracionPalabraTimer =
      //un nuevo temporizador que espera una duración especificada en milisegundos
      // luego ejecuta el callback proporcionado.
          Timer(Duration(milliseconds: duracionpalabra), () {
            //si el widget esta montado y genera la funcion
            if (mounted) {
              _generarpalabracolor();
            }
          });

      //Cancela el temporizador si _tiempo no es null
      _tiempo?.cancel();
      // Verifica si se debe usar el tiempo
      //se inicia si _tiempoRestante es mayor que 0 y _editarTiempo es false
      if (_tiempoRestante > 0 && !_editarTiempo) {
        // Crea un temporizador que se repite cada segundo
        // El callback se ejecuta cada vez que el temporizador se dispara.
        _tiempo = Timer.periodic(Duration(seconds: 1), (timer) {
          if (mounted){
            setState(() {
              //se descuenta el tiempo
              _tiempoRestante--;
            });
            if (_tiempoRestante ==0){
              //si el tiempo llega a 0 se cancela el tiempo y se muestra resultados
              _tiempo?.cancel();
              _mostrarResultado();
            }
          }else {
            //si no está montado se cancela el tiempo
            _tiempo?.cancel();
          }
        });
      }
    });
  }

  //Método para reiniciar el tiempo
  void _reiniciarTemporizador() {
    _tiempo?.cancel(); // Cancelar cualquier temporizador existente
    if (_tiempoRestante > 0) {
      _tiempo = Timer.periodic(Duration(seconds: 0), (timer) {
        if (mounted) {
          setState(() {
            _tiempoRestante--;
          });
          if (_tiempoRestante <= 0) {
            _tiempo?.cancel();
            _mostrarResultado();
          }
        } else {
          _tiempo?.cancel();
        }
      });
    }
  }

  //Método para guardar el puntaje
  void _respuestaColor(Color colorseleccionado) {
    //si el color seleccionado es igual al color correcto
    if (colorseleccionado == colorcorrecto) {
      setState(() {
        //actualizar el puntaje 5 puntos por acierto
        puntaje += 5;
        //se suman las palabras correctas
        palabras_correctas++;
        //si el tiempo es mayor a 0
        if (_editarTiempo && _tiempoRestante > 0) {
          // Reiniciar tiempo al valor seleccionado
          _tiempoRestante = int.tryParse(_controllerTiempo.text) ?? 0;
          _reiniciarTemporizador();
          //se muestra el resultado
          _mostrarResultado();
        }
        //seguir generando palabras
        _generarpalabracolor();
      });
    } else {
      // Ignorar intentos si se seleccionó la opción de tiempo
      if (!_editarTiempo && intentosfallidos > 0) {
        setState(() {
          //Aumenta el numero de intentos fallidos cuando se equivoque
          intentosfallidos--;
        });
        if (intentosfallidos == 0) {
          //Si los intentos se acaban mostrar alerta para guardar puntaje
          //se cancela el tiempo
          _tiempo?.cancel();
          //mostrar el resultado si se llega a 0
          _mostrarResultado();
        } else {
          //Generar una nueva palabra si el intento no alcanza el límite
          _generarpalabracolor();
        }
        //si se edita el tiempo
      } else if (_editarTiempo) {
        //generar palbras con la configuracion del tiempo
        _generarpalabracolor();
        //mostrar la configuracion
        _mostrarConfiguracion();
      }
    }
  }

  //Método para pausar el juego
  void _AlertaPausa() {
    //cancelar el tiempo
    _tiempo?.cancel();
    _duracionPalabraTimer?.cancel();
    //Mostrar la alerta
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Juego en Pausa",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.deepPurpleAccent
            ),),
          content: Text("Selecciona una opción para continuar:",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400
            ),),
          actions: [
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    // Regresar al inicio
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> Home()));
                  },
                  child: Text('Regresar',
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      )),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Continuar la partida
                      if (contadorPausas < 2) {
                        //Si el contador de pausa es menor a 2 reanudar
                        setState(() {
                          _duracionPalabraTimer = Timer(Duration(milliseconds: duracionpalabra), () {
                            if (mounted) {
                              _tiempoRestante--;
                              _generarpalabracolor();
                            }
                          });
                        });
                        // Incrementar el contador de pausas
                        contadorPausas++;
                      } else {
                        // Si se ha alcanzado el límite de pausas, reiniciar el juego
                        _reiniciarJuego();
                        // Reiniciar el contador de pausas
                        contadorPausas = 0;
                      }
                    },
                    child: Text('Continuar Partida',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  //Método para mostrar resultados
  void _mostrarResultado() {
    //cancelar el tiempo
    _tiempo?.cancel();
    //Mostrar alerta
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("¡Juego Terminado!",
          style: TextStyle(
            fontWeight: FontWeight.bold
          ),),
          content: Text(
            "Puntaje: $puntaje\nTotal de palabras correctas: $palabras_correctas",
            style: TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
              fontSize: 15
            ),
          ),
          actions: [
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
                  },
                  child: Text('Regresar',
                  style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                    color: Colors.deepPurpleAccent
                  ),),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Cierra el diálogo
                      // Reinicia el juego
                      _reiniciarJuego();
                    },
                    child: Text('Reiniciar Juego',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        color: Colors.green
                      ),),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  //Reiniciar el juego
  void _reiniciarJuego() {
    setState(() {
      //actualizar las variables a 0
      puntaje = 0;
      intentosfallidos = 0;
      palabras_correctas = 0;
      // Reiniciar tiempo con el valor configurado
      _tiempoRestante = int.tryParse(_controllerTiempo.text) ?? 0;
      //Mostrar configuración
      _mostrarConfiguracion();

    });
  }

  //Método para guardar configuración
  void _guardarConfiguracion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('intentosfallidos', intentosfallidos);
    await prefs.setInt('tiempoRestante', _tiempoRestante);
    await prefs.setInt('duracionpalabra', duracionpalabra);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Juego Personalizado",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurpleAccent,
                  fontSize: 18
              ),
            ),
            Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: Expanded(
                    child: FaIcon(
                      FontAwesomeIcons.pause,
                      color: Colors.deepPurpleAccent,
                      size: 25,
                    ),
                  ),
                  onPressed: () {
                    _AlertaPausa();
                  },
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Text(
                palabra,
                style: TextStyle(
                    fontSize: 45,
                    color: colortexto
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //se definen 4 columnas en pantallas grandes, 2 en pequeñas
                  crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
                  ),
                  itemCount: mezclapalabras.length,
                  itemBuilder: (context, index) {
                    Color color = mezclapalabras[index];
                    return GestureDetector(
                      //Al dar click se ejecutara la funcion
                      onTap: () => _respuestaColor(color),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Container(
                          //Se crean los circulos
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            //Se les asigna un color de la lista
                            color: color,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              child: Column(
                children: [
                  //Datos del juego
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Tiempo: $_tiempoRestante",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.lightBlueAccent
                        ),
                      ),
                      Text(
                        "Puntaje: $puntaje",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green
                        ),
                      ),
                      Text(
                        "Intentos: $intentosfallidos",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.red
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20, top: 15),
                        child: Text(
                          "Palabras correctas: $palabras_correctas",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    _tiempo?.cancel();
    _duracionPalabraTimer?.cancel();
    super.dispose();
  }

}





