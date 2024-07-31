import 'package:color_app/views/mejores_puntajes.dart';
import 'package:flutter/material.dart';
import 'package:color_app/views/nuevojuego.dart';
import 'package:color_app/views/juego_personalizado.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PuntajesLista {
  static List<Map<String, dynamic>> puntajesjugador = [];
}

//Se define la clase Home
class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //Redirige al menu principal con las opciones
      home: Menu(),
    );
  }
}

class Menu extends StatelessWidget {
  const Menu({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      //Appbar de la clase menu
      appBar: AppBar(
        title: Text(
            "ColorApp",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.deepPurpleAccent
        ),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //Se agrega una imagen en el menú
            Container(
              padding: EdgeInsets.only(right: 50, left: 50, top: 100, bottom: 40),
                //Imagen con la ruta desde /img
                child: Image.asset("img/lg2ic.jpg", height: 200,),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Container(
                child: Text(
                  "Color App",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurpleAccent,
                    fontSize: 30,
                  ),
                ),
              ),
            ),
            Container(

              child: Column(
                // Asegura que el Row se ajuste al contenido
                mainAxisSize: MainAxisSize.min,
                children: [
                  //Se crea el primer botón
                  Padding(
                    padding: const EdgeInsets.only(top: 25, right: 60, left: 60),
                    child: Expanded(
                      child: ElevatedButton(
                          onPressed: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Nuevojuego(
                                      actualizarPuntajes: (puntajes) {
                                        PuntajesLista.puntajesjugador.clear();
                                        PuntajesLista.puntajesjugador.addAll(puntajes);
                                      },
                              ))
                            );
                          },
                          child: Row(
                            // Centra el contenido
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  "Nuevo Juego",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              //Agregamos un icono al botón
                              //Utilizamos FontAwesome para importar el icono
                              Expanded(
                                child: FaIcon(
                                  FontAwesomeIcons.gamepad,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                          //Se le dan estilos al botón
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurpleAccent,
                            padding: EdgeInsets.symmetric(vertical: 15, horizontal:65),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          )
                      ),
                    ),
                  ),

                  //Se crea el segundo botón
                  Padding(
                    padding: const EdgeInsets.only(top: 20, right: 60, left: 60),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => JuegoPersonalizado(mostrarConfiguracion: true)));
                      },
                      child: Row(
                        // Centra el contenido
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              "Juego Personalizado",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          // Espacio entre texto e ícono
                          SizedBox(width: 8),
                          Expanded(
                            child: FaIcon(
                              FontAwesomeIcons.wandMagicSparkles,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      // Estilos del botón
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 35),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),

                  //Se crea el tercer botón
                  Padding(
                    padding: const EdgeInsets.only(top: 20, right: 60, left: 60, bottom: 50),
                    child: ElevatedButton(
                        onPressed: (){
                          //Redirigir a la vista de Mejores puntajes
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>MejoressPuntajes()));
                        },
                        child: Row(
                          // Centra el contenido
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Text(
                                "Mejores Puntajes",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15
                                ),
                              ),
                            ),
                            // Espacio entre texto e ícono
                            SizedBox(width: 8),
                            Expanded(
                              child: FaIcon(
                                FontAwesomeIcons.crown,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                        //Estilos del botón
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent,
                          padding: EdgeInsets.symmetric(vertical: 14, horizontal:52),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        )
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}

