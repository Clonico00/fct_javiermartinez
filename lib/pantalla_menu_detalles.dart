// ignore_for_file: unused_field

import 'package:fct_javiermartinez/menu.dart';
import 'package:fct_javiermartinez/pantalla_menu.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PantallaMenuDetalles extends StatefulWidget {
  const PantallaMenuDetalles({Key? key}) : super(key: key);

  @override
  State<PantallaMenuDetalles> createState() => _PantallaMenuDetallesState();
}

class _PantallaMenuDetallesState extends State<PantallaMenuDetalles> {
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
    final Menu menu = ModalRoute.of(context)!.settings.arguments as Menu;
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
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
                      arguments: menu.numeroMesa,
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
              Text(
                  "Croissanteria Párraga: Mesa " +
                      menu.numeroMesa +
                      " " +
                      menu.categoria,
                  style: TextStyle(
                      color: _colorsRV[1],
                      fontSize: 15.0,
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
        child: ListView.builder(
          itemCount: 10,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return Container(
              height: 120,
              width: queryData.size.width - 100,
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 25.0,
                  ),
                  Image.asset(
                    'assets/images/cp.jpg',
                    height: 75,
                    width: 75,
                  ),
                  SizedBox(
                    width: queryData.size.width - 390,
                  ),
                  Text("COMIDA",
                      style: TextStyle(
                          color: _colorsRV[index % 2],
                          fontSize: 18.0,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Comfortaa')),
                  SizedBox(
                    width: queryData.size.width - 300,
                  ),
                  InkWell(
                    onTap: () {
                      Fluttertoast.showToast(
                        msg: "Comanda añadida", // message
                        toastLength: Toast.LENGTH_LONG, // length
                        gravity: ToastGravity.TOP, // location
                        timeInSecForIosWeb: 2,
                        backgroundColor: Color.fromARGB(255, 6, 9, 94),
                        fontSize: 15.0,
                        // duration
                      );
                    }, // Handle your callback
                    child: Image.asset(
                      'assets/images/anadir.png',
                      height: 25,
                      width: 25,
                      color: _colorsRV[index % 2],
                    ),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  InkWell(
                    onTap: () {
                      Fluttertoast.showToast(
                        msg: "Comida quitada", // message
                        toastLength: Toast.LENGTH_LONG, // length
                        gravity: ToastGravity.TOP, // location
                        timeInSecForIosWeb: 2,
                        backgroundColor: Color.fromARGB(255, 6, 9, 94),
                        fontSize: 15.0,
                        // duration
                      );
                    }, // Handle your callback
                    child: Image.asset(
                      'assets/images/quitar.png',
                      height: 25,
                      width: 25,
                      color: _colorsRV[index % 2],
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: _colors[index % 2],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
