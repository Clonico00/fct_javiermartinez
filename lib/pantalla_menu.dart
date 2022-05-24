// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:fct_javiermartinez/menu.dart';

import 'package:fct_javiermartinez/pantalla_camareros.dart';
import 'package:fct_javiermartinez/pantalla_cuenta.dart';
import 'package:fct_javiermartinez/pantalla_menu_detalles.dart';

import 'package:fluttertoast/fluttertoast.dart';

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
  List imagesList = [
    ('assets/images/BEBIDAS.png'),
    ('assets/images/cafe.png'),
    ('assets/images/comida.png'),
    ('assets/images/postre.png'),
    ('assets/images/menu.png'),
    ('assets/images/dulces.png'),
    ('assets/images/cuenta.png'),
    ('assets/images/cocina.png'),
  ];
  List categoryList = [
    ('Bebidas'),
    ('Cafes'),
    ('Comidas'),
    ('Postres'),
    ('Menus'),
    ('Dulces'),
    ('Cuenta'),
    ('Enviar a Cocina'),
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
                      builder: (context) => CamarerosScreen()));
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
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (context, position) {
            return Padding(
                padding: const EdgeInsets.all(20.0),
                child: InkWell(
                    onTap: () {
                      if (categoryList[position] == 'Enviar a Cocina') {
                        Fluttertoast.showToast(
                          msg: "Comanda enviada a cocina", // message
                          toastLength: Toast.LENGTH_LONG, // length
                          gravity: ToastGravity.TOP, // location
                          timeInSecForIosWeb: 2,
                          backgroundColor: Color.fromARGB(255, 6, 9, 94),
                          fontSize: 15.0,
                          // duration
                        );
                      } else if (categoryList[position] == 'Cuenta') {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => PantallaCuenta(),
                          settings: RouteSettings(
                            arguments: todo.toString(),
                          ),
                        ));
                      } else {
                        Menu menu = Menu(todo, categoryList[position]);

                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => PantallaMenuDetalles(),
                          settings: RouteSettings(
                            arguments: menu,
                          ),
                        ));
                      }
                    },
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
                                  imagesList[position],
                                  height: 90,
                                  width: 90,
                                  color: _colorsRV[1],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                categoryList[position],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: _colorsRV[1],
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Comfortaa'),
                              ),
                            ),
                          )
                        ],
                      ),
                    )));
          },
          itemCount: categoryList.length,
        ),
      ),
    );
  }
}
