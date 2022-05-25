// ignore_for_file: unused_field, unused_import

import 'package:fct_javiermartinez/pantalla_menu.dart';
import 'package:flutter/material.dart';
import 'package:fct_javiermartinez/pantalla_camareros.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

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
    final todo = ModalRoute.of(context)!.settings.arguments as String;
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
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => PantallaMenu(),
                    settings: RouteSettings(
                      arguments: todo.toString(),
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
              Text("Croissanteria Párraga: Mesa " + todo.toString() + " Cuenta",
                  style: TextStyle(
                      color: _colorsRV[1],
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Comfortaa'))
            ],
          )),
      body: Container(
          decoration: new BoxDecoration(
              gradient: LinearGradient(colors: [
            Color.fromARGB(255, 255, 255, 255),
            Color.fromARGB(255, 18, 22, 134),
          ], begin: Alignment.topCenter, end: Alignment(0.0, 1.0))),
          child: ListView(
            padding: EdgeInsets.all(10.0),
            children: [
              Card(
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: BorderSide(color: _colorsRV[1], width: 1)),
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
                      borderSide: BorderSide(color: _colors[1], width: 0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('5x Cocacola\n\n3x Fantas',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 18, 22, 134),
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
                          const SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("3,95\$\n\n3,25\$",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 18, 22, 134),
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
                child: Card(
                    shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide(color: _colorsRV[1], width: 1)),
                    color: _colorsRV[1],
                    child: ListTile(
                        title: Text('I.V.A (11%) :',
                            style: TextStyle(
                                color: _colors[1],
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'Comfortaa')),
                        trailing: Text("AQUI VA IR EL TOTAL DEL IVAL",
                            style: TextStyle(
                                color: _colors[1],
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'Comfortaa')))),
              ),
              Card(
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: BorderSide(color: _colorsRV[1], width: 1)),
                  color: _colorsRV[1],
                  child: ListTile(
                      title: Text('TOTAL :',
                          style: TextStyle(
                              color: _colors[1],
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'Comfortaa')),
                      trailing: Text("AQUI VA IR EL TOTAL",
                          style: TextStyle(
                              color: _colors[1],
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'Comfortaa')))),
              Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Card(
                      shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: _colorsRV[1], width: 0)),
                      child: Container(
                        width: double.infinity,
                        child: RawMaterialButton(
                          fillColor: Color.fromARGB(255, 255, 255, 255),
                          elevation: 0.0,
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          onPressed: () async {},
                          child: const Text("CONFIRMAR PEDIDO",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 18, 22, 134),
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Comfortaa')),
                        ),
                      ))),
            ],
          )),
    );
  }
}
