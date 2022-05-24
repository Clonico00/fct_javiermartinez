// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fct_javiermartinez/pantalla_menu.dart';

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
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        toolbarHeight: 50,
        elevation: 2,
        shadowColor: Color.fromARGB(255, 255, 255, 255),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(10))),
        title: Center(
            child: Text("Croissanteria Párraga",
                style: TextStyle(
                    color: _colorsRV[1],
                    fontSize: 28.0,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Comfortaa'))),
      ),
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
                BoxShadow(
                    color: _colors[index % 2], blurRadius: 2, spreadRadius: 5)
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
