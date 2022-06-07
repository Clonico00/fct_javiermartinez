// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fct_javiermartinez/controls/main.dart';
import 'package:fct_javiermartinez/models/menu_model.dart';
import 'package:flutter/material.dart';
import 'package:fct_javiermartinez/views/pantalla_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CamarerosScreen extends StatefulWidget {
  const CamarerosScreen({Key? key}) : super(key: key);

  @override
  State<CamarerosScreen> createState() => _CamarerosScreenState();
}

class _CamarerosScreenState extends State<CamarerosScreen> {
  late SharedPreferences login;
  @override
  void initState() {
    super.initState();
    //iniciamos la pantalla y recogemos las preferencias
    initial();
  }

  void initial() async {
    login = await SharedPreferences.getInstance();
  }

  //creamos dos listas de colores para asi poder ir variando con los distintos widgets
  List<Color> _colors = [
    Color.fromARGB(255, 6, 9, 94),
    Color.fromARGB(255, 255, 255, 255),
  ];
  List<Color> _colorsRV = [
    Color.fromARGB(255, 255, 255, 255),
    Color.fromARGB(255, 6, 9, 94),
  ];

  @override
  Widget build(BuildContext context) {
    // creamos un objeto de la clase Menu vacio
    var menu = Menu();
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          toolbarHeight: 50,
          elevation: 2,
          shadowColor: Color.fromARGB(255, 255, 255, 255),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10))),
          title: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              ClipRRect(
                child: InkWell(
                  onTap: () {
                    // el siguiente alertdialog servira para cerrar la sesion de camareros y volver a la seccion de
                    // login, tambien en el objeto creado anteriormente de Shared Preferences ponemos true para asi inidcar que se ha cerrado la sesion
                    Widget cancelButton = TextButton(
                      child: Text("No",
                          style: TextStyle(
                              color: _colors[0],
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Comfortaa')),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    );
                    Widget continueButton = TextButton(
                      child: Text("Si",
                          style: TextStyle(
                              color: _colors[0],
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Comfortaa')),
                      onPressed: () {
                        login.setBool('login', true);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ));
                      },
                    );

                    // set up the AlertDialog
                    AlertDialog alert = AlertDialog(
                      backgroundColor: _colorsRV[0],
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30)),
                      title: Text("Salir",
                          style: TextStyle(
                              color: _colors[0],
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Comfortaa')),
                      content: Text(
                          "¿Seguro que quieres salir al menu principal?\nLa sesion se cerrara",
                          style: TextStyle(
                              color: _colors[0],
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Comfortaa')),
                      actions: [
                        cancelButton,
                        continueButton,
                      ],
                    );

                    // show the dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return alert;
                      },
                    );
                  }, // Handle your callback
                  child: Container(
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: Color.fromARGB(255, 6, 9, 94),
                      size: 30.0,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 20),
              Text("Croissanteria Párraga: Mesas",
                  style: TextStyle(
                      color: _colorsRV[1],
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Comfortaa'))
            ],
          )),
          //con el widget Stream Builder creamos la instancia de nuestra base de datos de Firebase, indicando de que coleccion
          // leeremos los datos y tambien le añadimos la clausula where para que salgan los documentos ordenados segun el numero de mesa
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("cuenta")
              .orderBy("numeromesa", descending: false)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            //comprobamos que nuestra consulta tiene datos, de lo contrario se mostrara vacio
            if (snapshot.hasData) {
              //nos creamos un ListView para asi definir nuestra longitud de items, que sera el numero de documentos en Firebase
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  //aqui para ir recorriendo todos los documentos de la consulta usamos el index del ListView.builder
                  // que sera igual al numero de documentos
                  return Container(
                    height: 100,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Text(
                              "MESA " +
                                  //aqui mostramos la informacion de nuestra coleccion cuenta, mostrando el parametro que nos interese
                                  snapshot.data?.docs[index]['numeromesa'] +
                                  " - " +
                                  snapshot.data?.docs[index]['lugar'],
                              style: TextStyle(
                                  color: _colorsRV[index % 2],
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Comfortaa')),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: InkWell(
                            onTap: () {
                              //al pulsar sobre nuestra flecha guardamos en el objeto menu creado anteriormente, la informacion del lugar donde esta la mesa y su numero
                              // para asi poder identicarla en las siguientes pantallas
                              menu.lugar = (snapshot.data?.docs[index]['lugar'])
                                  .toString();
                              menu.numeroMesa = (snapshot.data?.docs[index]
                                      ['numeromesa'])
                                  .toString();
                                  // al cambiar de pantalla le pasamos nuestro objeto menu
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                builder: (context) => PantallaMenu(),
                                settings: RouteSettings(
                                  arguments: menu,
                                ),
                              ));
                            }, // Handle your callback
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              color: _colorsRV[index % 2],
                              size: 30.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: _colors[index % 2],
                      boxShadow: [
                        BoxShadow(color: _colors[index % 2], spreadRadius: 5)
                      ],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Container();
            }
          }),
    );
  }
}
