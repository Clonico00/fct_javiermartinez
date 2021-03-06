// ignore_for_file: unused_field, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fct_javiermartinez/models/menu_model.dart';
import 'package:fct_javiermartinez/views/pantalla_menu.dart';
import 'package:fct_javiermartinez/views/pantalla_menu_detalles.dart';
import 'package:flutter/material.dart';
import 'package:fct_javiermartinez/views/pantalla_camareros.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PantallaCuenta extends StatefulWidget {
  const PantallaCuenta({Key? key}) : super(key: key);

  @override
  State<PantallaCuenta> createState() => _PantallaCuentaState();
}

class _PantallaCuentaState extends State<PantallaCuenta> {
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
    //guardamos nuestro objeto menu que nos hemos pasado anteriormente para identificar los datos
    final menu = ModalRoute.of(context)!.settings.arguments as Menu;
    //nos creamos un objeto fecha y le damos formato
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy  HH:mm').format(now);

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
            children: [
              InkWell(
                onTap: () async {
                  //si el usuario quiere volver para atras, volvemos a pasarle nuesto objeto menu a la anterior pantalla
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => PantallaMenu(),
                    settings: RouteSettings(
                      arguments: menu,
                    ),
                  ));
                }, // Handle your callback
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: Color.fromARGB(255, 6, 9, 94),
                  size: 30.0,
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Text(
                    "Croissanteria P??rraga: Mesa " +
                        menu.numeroMesa +
                        " Cuenta",
                    style: TextStyle(
                        color: _colorsRV[1],
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Comfortaa')),
              )
            ],
          )),
      body: Container(
          decoration: new BoxDecoration(
              gradient: LinearGradient(colors: [
            Color.fromARGB(255, 255, 255, 255),
            Color.fromARGB(255, 18, 22, 134),
          ], begin: Alignment.topCenter, end: Alignment(0.0, 1.0))),
          //con el widget Stream Builder creamos la instancia de nuestra base de datos de Firebase, indicando de que coleccion
          // leeremos los datos y tambien le a??adimos la clausula where para que salgan solo las comandas asociadas a esa mesa
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("cuenta")
                  .where("numeromesa", isEqualTo: menu.numeroMesa)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                //comprobamos que no haya nada en la cuenta de no haber nada simplemente mostramos lo mismo pero vacio
                if ((snapshot.data?.docs[0]['food']) != null) {
                  return ListView(
                    padding: EdgeInsets.all(10.0),
                    children: [
                      Card(
                          shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide:
                                  BorderSide(color: _colorsRV[1], width: 1)),
                          color: _colorsRV[1],
                          child: ListTile(
                              trailing: Text(
                                  menu.lugar.toUpperCase() +
                                      " :" +
                                      "                         " +
                                      formattedDate,
                                  style: TextStyle(
                                      color: _colors[1],
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'Comfortaa')))),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Card(
                          shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: _colors[1], width: 0)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          //esta vez como solo habra un documento no nos hace falta el index, con el 0 lo indicamos
                                          //mostramos los datos de toda la comida que tiene en la cuenta
                                          snapshot.data?.docs[0]['food']
                                              .replaceFirst("\n", ""),
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 18, 22, 134),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w900,
                                              fontFamily: 'Comfortaa')),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          //esta vez como solo habra un documento no nos hace falta el index, con el 0 lo indicamos
                                          //mostramos los datos de toda los precios que tiene en la cuenta
                                          snapshot.data?.docs[0]['prices']
                                              .replaceFirst("\n", ""),
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 18, 22, 134),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w900,
                                              fontFamily: 'Comfortaa')),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 75.0),
                      ),
                      Card(
                          shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide:
                                  BorderSide(color: _colorsRV[1], width: 1)),
                          color: _colorsRV[1],
                          child: ListTile(
                              title: Text('TOTAL :',
                                  style: TextStyle(
                                      color: _colors[1],
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'Comfortaa')),
                              trailing: Text(
                                  //esta vez como solo habra un documento no nos hace falta el index, con el 0 lo indicamos
                                  //mostramos el total que tiene en la cuenta

                                  (snapshot.data?.docs[0]['total']).toString() +
                                      "\???",
                                  style: TextStyle(
                                      color: _colors[1],
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'Comfortaa')))),
                      Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Card(
                              shape: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: _colorsRV[1], width: 0)),
                              child: Container(
                                width: double.infinity,
                                child: RawMaterialButton(
                                  fillColor: Color.fromARGB(255, 255, 255, 255),
                                  elevation: 0.0,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20.0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  onPressed: () async {
                                    //el siguiente alertdialog sirve para confirmar que se quiere reiniciar la cuenta, borrando asi todos los datos asociados(comida, precios y total)
                                    // de ser asi los guardamos vacios en nuestro objeto menu para asi cuando se cambie de pantalla este est?? vacio
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
                                        menu.food = "";
                                        menu.prices = "";
                                        menu.total = 0;
                                        //llamamos al siguiente metodo para actualizar los datos en nuestra base de datos pasandole el objeto menu
                                        updateCuenta(menu);
                                        //le cambiamos de pantalla
                                        Navigator.of(context)
                                            .pushReplacement(MaterialPageRoute(
                                          builder: (context) => PantallaMenu(),
                                          settings: RouteSettings(
                                            arguments: menu,
                                          ),
                                        ));
                                      },
                                    );

                                    // set up the AlertDialog
                                    AlertDialog alert = AlertDialog(
                                      backgroundColor: _colorsRV[0],
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(30)),
                                      title: Text("Confirmar",
                                          style: TextStyle(
                                              color: _colors[0],
                                              fontWeight: FontWeight.w800,
                                              fontFamily: 'Comfortaa')),
                                      content: Text(
                                          "??Seguro que quieres confirmar el pedido?\nLos datos de la cuenta se borraran",
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
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return alert;
                                      },
                                    );
                                  },
                                  child: const Text("CONFIRMAR PEDIDO",
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 18, 22, 134),
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w900,
                                          fontFamily: 'Comfortaa')),
                                ),
                              ))),
                    ],
                  );
                } else {
                  return ListView(
                    padding: EdgeInsets.all(10.0),
                    children: [
                      Card(
                          shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide:
                                  BorderSide(color: _colorsRV[1], width: 1)),
                          color: _colorsRV[1],
                          child: ListTile(
                              trailing: Text(formattedDate,
                                  style: TextStyle(
                                      color: _colors[1],
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'Comfortaa')))),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Card(
                          shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: _colors[1], width: 0)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("",
                                          //.replaceAll(new RegExp("[\n\]"), ''),
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 18, 22, 134),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w900,
                                              fontFamily: 'Comfortaa')),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("",
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 18, 22, 134),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w900,
                                              fontFamily: 'Comfortaa')),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 75.0),
                      ),
                      Card(
                          shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide:
                                  BorderSide(color: _colorsRV[1], width: 1)),
                          color: _colorsRV[1],
                          child: ListTile(
                              title: Text('TOTAL :',
                                  style: TextStyle(
                                      color: _colors[1],
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'Comfortaa')),
                              trailing: Text("0",
                                  style: TextStyle(
                                      color: _colors[1],
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'Comfortaa')))),
                      Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Card(
                              shape: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: _colorsRV[1], width: 0)),
                              child: Container(
                                width: double.infinity,
                                child: RawMaterialButton(
                                  fillColor: Color.fromARGB(255, 255, 255, 255),
                                  elevation: 0.0,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20.0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  onPressed: () async {
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
                                        menu.food = "";
                                        menu.prices = "";
                                        menu.total = 0;
                                        updateCuenta(menu);
                                        Navigator.of(context)
                                            .pushReplacement(MaterialPageRoute(
                                          builder: (context) => PantallaMenu(),
                                          settings: RouteSettings(
                                            arguments: menu,
                                          ),
                                        ));
                                      },
                                    );

                                    // set up the AlertDialog
                                    AlertDialog alert = AlertDialog(
                                      backgroundColor: _colorsRV[0],
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(30)),
                                      title: Text("Confirmar",
                                          style: TextStyle(
                                              color: _colors[0],
                                              fontWeight: FontWeight.w800,
                                              fontFamily: 'Comfortaa')),
                                      content: Text(
                                          "??Seguro que quieres confirmar el pedido?\nLos datos de la cuenta se borraran",
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
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return alert;
                                      },
                                    );
                                  },
                                  child: const Text("CONFIRMAR PEDIDO",
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 18, 22, 134),
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w900,
                                          fontFamily: 'Comfortaa')),
                                ),
                              ))),
                    ],
                  );
                }
              })),
    );
  }

  //con este metodo actualizamos los datos de la cuenta en la base de datos
  Future<void> updateCuenta(Menu menu) {
    CollectionReference cuenta =
        FirebaseFirestore.instance.collection('cuenta');
    //como sabemos el numero de mesa y este a su vez es el mismo que el documento actualizamos los datos de este
    return cuenta
        .doc(menu.numeroMesa)
        .update({'food': menu.food, 'prices': menu.prices, 'total': 0})
        .then((value) => print("Cuenta Updated"))
        .catchError((error) => print("Failed to update comida: $error"));
  }
}
