// ignore_for_file: prefer_const_constructors

import 'package:fct_javiermartinez/main.dart';
import 'package:flutter/material.dart';
import 'package:fct_javiermartinez/pantalla_menu.dart';
import 'package:fct_javiermartinez/menu.dart';

class CamarerosScreen extends StatefulWidget {
  const CamarerosScreen({Key? key}) : super(key: key);

  @override
  State<CamarerosScreen> createState() => _CamarerosScreenState();
}

class _CamarerosScreenState extends State<CamarerosScreen> {
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
            mainAxisSize: MainAxisSize.max,
            children: [
              ClipRRect(
                child: InkWell(
                  onTap: () {
                    // set up the buttons
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
      body: ListView.builder(
        itemCount: 10,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return Container(
            height: 100,
            alignment: Alignment.center,
            child: Row(
              children: [
                SizedBox(
                  width: 25.0,
                ),
                Text("MESA ${index + 1}",
                    style: TextStyle(
                        color: _colorsRV[index % 2],
                        fontSize: 18.0,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Comfortaa')),
                SizedBox(
                  width: queryData.size.width - 150.0,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => PantallaMenu(),
                      settings: RouteSettings(
                        arguments: (index + 1).toString(),
                      ),
                    ));
                  }, // Handle your callback
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: _colorsRV[index % 2],
                    size: 30.0,
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
      ),
    );
  }
}
