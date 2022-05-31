// ignore_for_file: unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fct_javiermartinez/comidas_model.dart';
import 'package:fct_javiermartinez/insert_data.dart';
import 'package:fct_javiermartinez/menu.dart';
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
  dynamic data;

  @override
  void initState() {
    super.initState();
    //getDatas();
    //getDocumentData();
  }

  // CollectionReference _collectionRef =
  //     FirebaseFirestore.instance.collection('comidas');

  // Future<void> getDatas() async {
  //   // Get docs from collection reference
  //   QuerySnapshot querySnapshot = await _collectionRef.get();

  //   // Get data from docs and convert map to List
  //   final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
  //   print(allData.toSet());
  // }

  //
  // _docData
  //     .forEach((element) => print(element.toString().replaceAll("\{", "")))
  //     ;
  // for (var item in _docData) {
  //   //x = item.toString().replaceAll("\{", "");
  //   Comidas c =
  //       Comidas.fromJson(jsonDecode(item.toString().replaceAll("\{", "\{ ")));
  //   print(c);
  // }
  //print(x.toString());
  //}

  @override
  Widget build(BuildContext context) {
    final Menu menu = ModalRoute.of(context)!.settings.arguments as Menu;
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
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("comidas")
                .where("categoria", isEqualTo: menu.categoria.toLowerCase())
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                List<Comidas> listacomidas = [];
                int unidades = 0;
                for (int i = 0; i < snapshot.data!.docs.length; i++) {
                  Comidas comida = Comidas(
                      snapshot.data?.docs[i]['categoria'],
                      snapshot.data?.docs[i]['_id'],
                      snapshot.data?.docs[i]['imagen'],
                      snapshot.data?.docs[i]['nombre'],
                      snapshot.data?.docs[i]['stock'],
                      snapshot.data?.docs[i]['precio']);
                  listacomidas.add(comida);
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  shrinkWrap: false,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    String document =
                        (snapshot.data?.docs[index].id).toString();

                    return Card(
                      color: _colorsRV[index % 2],
                      shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: BorderSide(
                              color: _colorsRV[index % 2], width: 1)),
                      child: ListTile(
                        leading: Image.asset(
                          snapshot.data?.docs[index]['imagen'],
                          height: 100,
                          width: 100,
                        ),
                        title: Text(
                            (snapshot.data?.docs[index]['nombre'])
                                .toString()
                                .toUpperCase(),
                            style: TextStyle(
                                color: _colors[index % 2],
                                fontSize: 13.0,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'Comfortaa')),
                        trailing: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                //si queremos añadir mas datos llamamos a este metodo
                                //addUser();
                                Comidas comida1 = listacomidas[index];
                                if (comida1.stock <= 0) {
                                  showSnackBar(
                                      context, "No hay mas stock", index);
                                } else {
                                  comida1.stock -= 1;
                                  unidades = unidades + 1;
                                  listacomidas.forEach(
                                      (element) => print(element.toString()));
                                  updateComida(document, comida1.stock);
                                  showSnackBar(
                                      context, "Comanda añadida", index);
                                }
                              }, // Handle your callback
                              child: Image.asset(
                                'assets/images/icons/mas.png',
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
                                Comidas comida1 = listacomidas[index];
                                unidades = unidades + -1;

                                comida1.stock += 1;
                                listacomidas.forEach(
                                    (element) => print(element.toString()));
                                updateComida(document, comida1.stock);

                                showSnackBar(context, "Comanda quitada", index);
                              }, // Handle your callback
                              child: Image.asset(
                                'assets/images/icons/menos.png',
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
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }

  Future<void> updateComida(String document, int stock) {
    CollectionReference comidas =
        FirebaseFirestore.instance.collection('comidas');

    return comidas
        .doc(document)
        .update({'stock': stock})
        .then((value) => print("Comida Updated"))
        .catchError((error) => print("Failed to update comida: $error"));
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
