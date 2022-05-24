// ignore_for_file: unused_field

import 'package:fct_javiermartinez/pantalla_menu.dart';
import 'package:flutter/material.dart';

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
    final todo = ModalRoute.of(context)!.settings.arguments as String;

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
              Text("Croissanteria Párraga: Mesa " + todo.toString(),
                  style: TextStyle(
                      color: _colorsRV[1],
                      fontSize: 19.0,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Comfortaa'))
            ],
          )),
    );
  }
}
