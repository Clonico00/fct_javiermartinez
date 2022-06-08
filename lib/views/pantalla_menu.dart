// ignore_for_file: unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fct_javiermartinez/models/menu_model.dart';

import 'package:fct_javiermartinez/views/pantalla_camareros.dart';
import 'package:fct_javiermartinez/views/pantalla_cuenta.dart';
import 'package:fct_javiermartinez/views/pantalla_menu_detalles.dart';

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
  //creamos dos listas, la primera con la ruta relativa de nuestros iconos del menu, y en la misma posicion pero en otra lista estaran los nombres de las distintas categorias
  //para asi cuando las llamemos con el ListView.Builder vayan apareciendo juntas
  List imagesList = [
    ('assets/images/icons/BEBIDAS.png'),
    ('assets/images/icons/cafe.png'),
    ('assets/images/icons/comida.png'),
    ('assets/images/icons/postre.png'),
    ('assets/images/icons/menu.png'),
    ('assets/images/icons/dulces.png'),
    ('assets/images/icons/cuenta.png'),
    ('assets/images/icons/cocina.png'),
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
    //guardamos nuestro objeto menu que nos hemos pasado anteriormente para identificar los datos
    final menu = ModalRoute.of(context)!.settings.arguments as Menu;

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
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              Expanded(
                child: Text("Croissanteria Párraga: Mesa " + menu.numeroMesa,
                    style: TextStyle(
                        color: _colorsRV[1],
                        fontSize: 16.0,
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
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: GridView.builder(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (context, position) {
              return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: InkWell(
                      onTap: () {
                        // si el usuario pulsa en la opcion de envra a cocina y ha añadido algo a las comandas, añadimos esta comanda a nuestra base de datos con el metodo addComanda, de no haber nada le avisamos
                        if (categoryList[position] == 'Enviar a Cocina') {
                          if (menu.food != "") {
                            addComanda(menu);
                            final snackBar = SnackBar(
                              backgroundColor:
                                  Color.fromARGB(255, 252, 252, 252),
                              padding: EdgeInsets.all(5.0),
                              behavior: SnackBarBehavior.floating,
                              elevation: 2.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              content: Text("Comanda enviada a cocina",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 18, 22, 134),
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
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else {
                            final snackBar = SnackBar(
                              backgroundColor:
                                  Color.fromARGB(255, 252, 252, 252),
                              padding: EdgeInsets.all(5.0),
                              behavior: SnackBarBehavior.floating,
                              elevation: 2.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              content: Text("Añada una comanda por favor",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 18, 22, 134),
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
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        } else if (categoryList[position] == 'Cuenta') {
                          // si el usuario elige la opcion de cuenta lo enviamos a su pantalla correspondiente y le pasamos a esta el objeto menu
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => PantallaCuenta(),
                            settings: RouteSettings(
                              arguments: menu,
                            ),
                          ));
                        } else {
                          // si el usuario elige cualquier otra opcion sera enviado a la pantalla del MenuDetalles donde saldra la comida dependiendo de la seccion pulsada
                          //para ello guardamos en nuestro objeto menu la categoria pulsada, y este se lo pasamos a la pantalla siguiente
                          menu.categoria = categoryList[position];
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => PantallaMenuDetalles(),
                            settings: RouteSettings(
                              arguments: menu,
                            ),
                          ));
                        }
                      },
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Center(
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(100.0)),
                                  elevation: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Image.asset(
                                      imagesList[position],
                                      height: 120,
                                      width: 120,
                                      color: _colorsRV[1],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    categoryList[position],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: _colors[1],
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w900,
                                        fontFamily: 'Comfortaa'),
                                  ),
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
      ),
    );
  }

  Future<void> addComanda(Menu menu) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
//creamos la instancia de la collecion que queramos añadir elementos identificada por su id
    CollectionReference comidas = firestore.collection('comandas');
    return comidas
        //los datos han sido añadidos uno a uno a traves del siguiente metodo, cambiando unicamente los valores
        .add({
          'numeromesa': menu.numeroMesa,
          'food': menu.food,
          'prices': menu.prices,
          'total': menu.total,
        })
        .then((value) => print("Comanda añadida"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}
