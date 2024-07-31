import 'package:color_app/home.dart';
import 'package:flutter/material.dart';
//import fontawesome
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import math para random
import 'dart:math';
//import async para el tiempo
import 'dart:async';
//import para firestore
import 'package:cloud_firestore/cloud_firestore.dart';


//Se crea la clase nuevojuego
//Statefull para guardar el estado cambiante / eventos asincronos
class Nuevojuego extends StatefulWidget {
  //Funcion para actualizar puntaje
  final Function(List<Map<String, dynamic>>) actualizarPuntajes;

  const Nuevojuego({super.key, required this.actualizarPuntajes});

  @override
  State<Nuevojuego> createState() => _NuevojuegoState();
}

class _NuevojuegoState extends State<Nuevojuego> {
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
  int _tiempoRestante = 3;
  //intentos
  int intentosfallidos = 3;
  //Palabras correctas
  int palabras_correctas =0;
  //pausas
  int contadorPausas = 0;
  // Lista para almacenar los puntajes y nombres
  List<Map<String, dynamic>> puntajesjugador = [];


  @override
  //Método initState para que se ejecute la funcion antes de que se dibuje la app
  void initState() {
    super.initState();
    //funciones para generar la palabra
    _generarpalabracolor();
  }

  //Método para generar un nuevo juego
  void _generarpalabracolor(){
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
      _tiempoRestante = 3; // Reinicia el tiempo a 3 segundos

      //Cancela el temporizador si _tiempo no es null
      _tiempo?.cancel();
      // Crea un temporizador que se repite cada segundo
      _tiempo = Timer.periodic(Duration(seconds: 1), (timer) {
        if (_tiempoRestante > 0) {
          //si tiempo restante es mayor a 0 se va descontando el tiempo
          setState(() {
            _tiempoRestante--;
          });
        } else {
          //si el tiempo llega a 0 se cancela el tiempo y se muestra la ventana para escribir el nombre
          _tiempo?.cancel();
          _escribirnombre();
        }
      });
    });
  }

  //Método para guardar el puntaje
  void _respuestaColor (Color colorseleccionado) {
    //si el color seleccionado es igual al color correcto
    if (colorseleccionado == colorcorrecto) {
      setState(() {
        //actualizar el puntaje 5 puntos por acierto
        puntaje += 5;
        //se suman las palabras correctas
        palabras_correctas++;
        //seguir generando palabras
        _generarpalabracolor();
      });

    } else {
      //Aumenta el numero de intentos fallidos cuando se equivoque
      setState(() {
        intentosfallidos--;
      });
      if (intentosfallidos == 0){
        //Si los intentos se acaban mostrar alerta para guardar puntaje
        //se cancela el tiempo
        _tiempo?.cancel();
        intentosfallidos = 3;
        //mostrar alerta si los intentos llegan a 0
        _escribirnombre();
      } else {
        //Generar una nueva palabra si el intento no alcanza el límite
        _generarpalabracolor();
        }
    }
  }

  //Método para reiniar
  void _reiniciarJuego() {
    setState(() {
      //actualizar las variables a 0 o sus datos predeterminados
      puntaje = 0;
      intentosfallidos = 3;
      palabras_correctas = 0;
      //Generar palabra
      _generarpalabracolor();
    });
  }

  void _verificarPuntaje() async {
    try {
      // Crear una referencia a la colección de Firestore
      final puntajesRef = FirebaseFirestore.instance.collection('puntajes');

      // Verificar si el nombre ya existe en Firestore
      final querySnapshot = await puntajesRef.where('nombre', isEqualTo: 'nombre').get();

      if (querySnapshot.docs.isNotEmpty) {
        // Si el nombre existe, obtener el documento y su puntaje actual
        final document = querySnapshot.docs.first;
        final currentPuntaje = document['puntaje'] as int;

        if (puntaje > currentPuntaje) {
          // Si el nuevo puntaje es mayor, mostrar el diálogo para ingresar el nombre
          _escribirnombre();
        } else {
          // Si el nuevo puntaje es menor o igual, redirigir a las opciones
          _AlertaInicio();
        }
      } else {
        // Si el nombre no existe, mostrar el diálogo para ingresar el nombre
        _escribirnombre();
      }
    } catch (e) {
      // Manejar el error de Firestore
      print("Error al verificar el puntaje: $e");
      _AlertaInicio(); // Redirigir a las opciones en caso de error
    }
  }

  //Método para escirbir el nombre
  void _escribirnombre() {
    // Cancela el temporizador cuando se muestra el diálogo
    _tiempo?.cancel();
    //Controlador para el nombre
    final TextEditingController _controllernombre = TextEditingController();
    //Mostrar alerta
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("¡Ingresa tu nombre para guardar tu puntaje!",
          style: TextStyle(
            fontSize: 20
          ),),
          content:
          TextField(
            //controlador del nombre
            controller: _controllernombre,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(hintText: 'Nombre'),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () async {
                      // Obtener el nombre ingresado
                      String nombre = _controllernombre.text;

                      if (nombre.isNotEmpty) {
                        try {
                          // Crear una referencia a la colección de Firestore
                          final puntajesRef = FirebaseFirestore.instance.collection('puntajes');

                          // Verificar si el nombre ya existe en Firestore
                          final querySnapshot = await puntajesRef.where('nombre', isEqualTo: nombre).get();
                          if (querySnapshot.docs.isNotEmpty) {
                            // Si el nombre existe, obtener el documento y su puntaje actual
                            final document = querySnapshot.docs.first;
                            final puntajeinicial = document['puntaje'] as int;

                            if (puntaje > puntajeinicial) {
                              // Si el nuevo puntaje es mayor, actualizar el puntaje
                              await puntajesRef.doc(document.id).update({
                                'puntaje': puntaje,
                              });
                            }
                          } else {
                            // Si el nombre no existe, agregar un nuevo documento
                            await puntajesRef.add({
                              'nombre': nombre,
                              'puntaje': puntaje,
                            });
                          }

                          // Reiniciar el puntaje
                          setState(() {
                            puntaje = 0;
                            intentosfallidos = 3;
                          });

                          // Salir del diálogo y mostrar las opciones
                          Navigator.of(context).pop();
                          _AlertaInicio();
                        } catch (e) {
                          // Manejar el error de Firestore
                          print("Error al guardar el puntaje: $e");
                        }
                      }
                    },

                    child: Text('Guardar',
                      style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        // Llamar AlertaInicio después de cerrar el diálogo
                        _AlertaInicio();
                      },
                      child: Text('Cancelar',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  Text(
                    "Puntaje: $puntaje",
                    style: TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  "Total de palabras correctas: $palabras_correctas",
                  style: TextStyle(
                      color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Total de palabras incorrectas: $intentosfallidos",
                    style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  //método para pausar el juego
  void _AlertaPausa() {
    //cancelar el tiempo
    _tiempo?.cancel();
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
                  fontSize: 15,
                  )),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Continuar la partida
                      if (contadorPausas < 2) {
                        // Si el contador de pausas es menor que 2, simplemente reanudar
                        setState(() {
                          _tiempoRestante = _tiempoRestante; // Mantener el tiempo restante
                          _tiempo = Timer.periodic(Duration(seconds: 1), (timer) {
                            if (_tiempoRestante > 0) {
                              setState(() {
                                _tiempoRestante--;
                              });
                            } else {
                              _tiempo?.cancel();
                              _escribirnombre();
                            }
                          });
                        });
                        // Incrementar el contador de pausas
                        contadorPausas++;
                      } else {
                        // Si se ha alcanzado el límite de pausas, reiniciar el juego
                        _reiniciarJuego();
                        contadorPausas = 0; // Reiniciar el contador de pausas
                      }
                    },
                    child: Text('Continuar Partida',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
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

  //método para la alerta del inicio
  void _AlertaInicio() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Expanded(
            child: Text("Nuevo Juego",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.deepPurpleAccent
            ),),
          ),
          content: Text("Selecciona una opción para continuar:",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400
          ),),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      fontSize: 15,
                    ),),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Iniciar la partida
                      _reiniciarJuego();
                    },
                    child: Text('Comenzar Partida',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Creamos la vista
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Text(
                "Juego Nuevo - ColorApp",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurpleAccent,
                  fontSize: 18
                ),
              ),
            ),
            Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.pause,
                    color: Colors.deepPurpleAccent,
                    size: 25,
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
                //Palabra (texto) con el color excepto el color correspondiente
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
                  //Se muestran los datos del juego
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                          Text(
                          "Tiempo: $_tiempoRestante",
                          style: TextStyle(fontSize: 20,
                              fontWeight: FontWeight.bold,
                          color: Colors.lightBlueAccent),
                        ),
                      Text(
                        "Puntaje: $puntaje",
                        style: TextStyle(fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                      Text(
                        "Intentos: $intentosfallidos",
                        style: TextStyle(fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    ]
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20, top: 15),
                          child: Text(
                            "Palabras correctas: $palabras_correctas",
                            style: TextStyle(fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple),
                          ),
                        ),
                      ]
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



