// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:fct_javiermartinez/pantalla_camareros.dart';

class PantallaMenu extends StatefulWidget {
  const PantallaMenu({Key? key}) : super(key: key);

  @override
  State<PantallaMenu> createState() => _PantallaMenuState();
}

class _PantallaMenuState extends State<PantallaMenu> {
  List<Color> _colors = [
    Color.fromARGB(255, 6, 9, 94),
    Color.fromARGB(255, 255, 255, 255),
  ];
  List<Color> _colorsRV = [
    Color.fromARGB(255, 255, 255, 255),
    Color.fromARGB(255, 6, 9, 94),
  ];
  List menuList = [
    _MenuItem('assets/images/BEBIDAS.png', 'BEBIDAS'),
    _MenuItem('assets/images/dieta.png', 'COMIDAS'),
    _MenuItem('assets/images/cafe.png', 'CAFES'),
    _MenuItem('assets/images/postre.png', 'POSTRES'),
    _MenuItem('assets/images/menu.png', 'MENUS'),
    _MenuItem('assets/images/cuenta.png', 'CUENTA'),
  ];

  @override
  Widget build(BuildContext context) {
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
                      builder: (context) => CamarerosScreen()));
                }, // Handle your callback
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: Color.fromARGB(255, 6, 9, 94),
                  size: 30.0,
                ),
              ),
              SizedBox(width: 10),
              Text("volver",
                  style: TextStyle(
                      color: _colorsRV[1],
                      fontSize: 15.0,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Comfortaa')),
              SizedBox(width: 30),
              Text("Croissanteria Párraga",
                  style: TextStyle(
                      color: _colorsRV[1],
                      fontSize: 20.0,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Comfortaa'))
            ],
          )),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (context, position) {
            return Padding(
                padding: const EdgeInsets.all(20.0),
                child: InkWell(
                    onTap: () {},
                    child: Center(
                      child: Column(
                        children: [
                          Center(
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100.0)),
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Image.asset(
                                  menuList[position].s,
                                  height: 75,
                                  width: 75,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                menuList[position].title,
                                textAlign: TextAlign.center,
                                style: TextStyle(),
                              ),
                            ),
                          )
                        ],
                      ),
                    )));
          },
          itemCount: menuList.length,
        ),
      ),
    );
  }
}

class _MenuItem {
  final String s;
  final String title;

  _MenuItem(this.s, this.title);
}
