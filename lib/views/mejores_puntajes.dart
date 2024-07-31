import 'package:flutter/material.dart';
//Importar para acceder a firestore
import 'package:cloud_firestore/cloud_firestore.dart';

//Define la clase MejoressPuntajes
//Statefull para guardar el estado cambiante / eventos asincronos
class MejoressPuntajes extends StatefulWidget {
  const MejoressPuntajes({super.key});

  @override
  State<MejoressPuntajes> createState() => _MejoressPuntajesState();
}

class _MejoressPuntajesState extends State<MejoressPuntajes> {
  //obtencion asincrona de datos desde firestore
  late Future<List<Map<String, dynamic>>> _futureData;


  //Método initState para que se ejecute la funcion antes de que se dibuje la app
  @override
  void initState() {
    super.initState();
    //Carga de datos comience cuando se inicialice el widget
    _futureData = getData();
  }

  //Método getData() devuelve un future que tendrá una coleccion de documentos (Query)
    Future<List<Map<String, dynamic>>> getData() async {
      // Obtención de datos de Firestore
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
      //Accede a la colección puntajes
          .collection('puntajes')
      //Ordena en orden descendente los puntajes para que sean de mayor a menor
          .orderBy('puntaje', descending: true)
      //Ejecuta la consulta y obtiene los elementos que coinciden
          .get();

      // Agrupación por nombre con el puntaje máximo
      final Map<String, int> puntajesMap = {};
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final nombre = data['nombre'];
        final puntaje = data['puntaje'] as int;

        if (puntajesMap.containsKey(nombre)) {
          if (puntaje > puntajesMap[nombre]!) {
            puntajesMap[nombre] = puntaje;
          }
        } else {
          puntajesMap[nombre] = puntaje;
        }
      }

      // Convertir el mapa a una lista de mapas
      final List<Map<String, dynamic>> listaPuntajes = puntajesMap.entries.map((entry) {
        return {
          'nombre': entry.key,
          'puntaje': entry.value,
        };
      }).toList();

      // Limitar a los mejores 5 puntajes
      listaPuntajes.sort((a, b) => b['puntaje'].compareTo(a['puntaje']));
      return listaPuntajes.take(5).toList();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Vista de los puntajes
      appBar: AppBar(
        title: Text(
          "Mejores Puntajes - ColorApp",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.deepPurpleAccent,
              fontSize: 18
          ),
        ),
      ),
      //
      body: FutureBuilder<List<Map<String, dynamic>>>(
        //Future de la consulta en firestore
          future: _futureData,
          //se construye el builder de acuerdo al estado y los datos del future
          builder: (context, snapshot) {
            //La consulta aun esta en proceso
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            //Si la consulta presenta un error
            else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No hay datos disponibles.'));
            }
            else {
              //Si la consulta se realiza con éxito
              return ListView.builder(
                //Los elementos retornados serán los documentos de firestore (con lmite de 5)
                  itemCount: snapshot.data!.length,
                //Construye cada elemento de la lista
                  itemBuilder: (context, index) {
                    //Obtiene los datos en el indice como Map
                   final data = snapshot.data![index];
                    //Se genera ListTile
                    return  ListTile(
                      //Enumerar los datos en un circulo
                      leading: CircleAvatar(
                        child: Text((index + 1).toString()),
                      ),
                        //Se muestra al nombre
                        title: Text(data['nombre']),
                        //Se muestra el puntaje
                        trailing: Text('Puntaje: ${data['puntaje']}',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.deepPurpleAccent
                        ),),
                    );
                  }
              );
            }
          }
      ),
    );
  }
}

