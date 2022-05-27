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
        child: ListTileTheme(
          contentPadding: EdgeInsets.all(25),
          child: ListView.builder(
            itemCount: 10,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return Card(
                color: _colorsRV[index % 2],
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide:
                        BorderSide(color: _colorsRV[index % 2], width: 1)),
                child: ListTile(
                  leading: Image.asset(
                    'assets/images/cp.jpg',
                    height: 75,
                    width: 75,
                  ),
                  title: Text("COMIDAS RICAS",
                      style: TextStyle(
                          color: _colors[index % 2],
                          fontSize: 13.0,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Comfortaa')),
                  trailing: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          showSnackBar(context, "Comanda añadida", index);
                        }, // Handle your callback
                        child: Image.asset(
                          'assets/images/mas.png',
                          height: 20,
                          width: 20,
                          color: _colors[index % 2],
                        ),
                      ),
                      SizedBox(
                        width: 30.0,
                        height: 15.0,
                      ),
                      InkWell(
                        onTap: () {
                          showSnackBar(context, "Comanda quitada", index);
                        }, // Handle your callback
                        child: Image.asset(
                          'assets/images/menos.png',
                          height: 20,
                          width: 20,
                          color: _colors[index % 2],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void showSnackBar(BuildContext context, String error, int index) {
    final snackBar = SnackBar(
      backgroundColor: _colorsRV[index % 2],
      padding: EdgeInsets.all(5.0),
      behavior: SnackBarBehavior.floating,
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      content: Text(error,
          style: TextStyle(
              color: _colors[index % 2],
              fontSize: 12.0,
              fontWeight: FontWeight.w900,
              fontFamily: 'Comfortaa')),
      action: SnackBarAction(
        label: 'Ok',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
