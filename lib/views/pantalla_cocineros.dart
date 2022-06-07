import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fct_javiermartinez/controls/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CocinerosScreen extends StatefulWidget {
  const CocinerosScreen({Key? key}) : super(key: key);

  @override
  State<CocinerosScreen> createState() => _CocinerosScreenState();
}

class _CocinerosScreenState extends State<CocinerosScreen> {
  late SharedPreferences login;
  @override
  void initState() {
    super.initState();
    //iniciamos la pantalla y recogemos las preferencias

    initial();
  }

  void initial() async {
    login = await SharedPreferences.getInstance();
  }
  //creamos dos listas de colores para asi poder ir variando con los distintos widgets

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
                  // el siguiente alertdialog servira para cerrar la sesion de camareros y volver a la seccion de
                  // login, tambien en el objeto creado anteriormente de Shared Preferences ponemos true para asi inidcar que se ha cerrado la sesion
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
                      login.setBool('login', true);

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
                    useSafeArea: true,
                    context: context,
                    builder: (BuildContext context) {
                      return alert;
                    },
                  );
                },
                child: Container(
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: Color.fromARGB(255, 6, 9, 94),
                    size: 30.0,
                  ),
                ), // Handle your callback
              ),
              SizedBox(width: 20),
              ClipRRect(
                child: Text("Croissanteria Párraga: Comandas",
                    style: TextStyle(
                        color: _colorsRV[1],
                        fontSize: 16,
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
        //con el widget Stream Builder creamos la instancia de nuestra base de datos de Firebase, indicando de que coleccion
        // leeremos los datos

        child: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection("comandas").snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              //comprobamos que nuestra consulta tiene datos, de lo contrario se mostrara vacio

              if (snapshot.hasData) {
                //nos creamos un ListView para asi definir nuestra longitud de items, que sera el numero de documentos en Firebase

                return ListTileTheme(
                  contentPadding: EdgeInsets.all(25),
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    shrinkWrap: false,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      //aqui para ir recorriendo todos los documentos de la consulta usamos el index del ListView.builder
                      // que sera igual al numero de documentos

                      return Card(
                        color: _colorsRV[index % 2],
                        shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: _colorsRV[index % 2], width: 1)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        'MESA ' +
                                            //aqui mostramos la informacion de nuestra coleccion comandas, mostrando el parametro que nos interese

                                            snapshot.data?.docs[index]
                                                ['numeromesa'],
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: _colors[index % 2],
                                            fontSize: 15,
                                            fontWeight: FontWeight.w900,
                                            fontFamily: 'Comfortaa')),
                                  ),
                                ),
                                SizedBox(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        snapshot.data?.docs[index]['food'],
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: _colors[index % 2],
                                            fontSize: 15,
                                            fontWeight: FontWeight.w900,
                                            fontFamily: 'Comfortaa')),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 60,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      // el siguiente alertdialog sirve para confirmar si se quiere borrar la comanda seleccionada
                                      Widget cancelButton = TextButton(
                                        child: Text("No",
                                            style: TextStyle(
                                                color: _colors[index % 2],
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
                                                color: _colors[index % 2],
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'Comfortaa')),
                                        onPressed: () async {
                                          //si quiere borrarla creamos una transaccion de nuestra base de datos para asi borrala simultaneamente
                                          //para ello simplemente le pasamos el index para identificarla en nuestra base de datos
                                          await FirebaseFirestore.instance
                                              .runTransaction((Transaction
                                                  myTransaction) async {
                                            await myTransaction.delete(snapshot
                                                .data!.docs[index].reference);
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      );

                                      // set up the AlertDialog
                                      AlertDialog alert = AlertDialog(
                                        backgroundColor: _colorsRV[index % 2],
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(30)),
                                        title: Text("Eliminar Comanda",
                                            style: TextStyle(
                                                color: _colors[index % 2],
                                                fontWeight: FontWeight.w800,
                                                fontFamily: 'Comfortaa')),
                                        content: Text(
                                            "¿Seguro que quieres eliminar esta comanda",
                                            style: TextStyle(
                                                color: _colors[index % 2],
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
                                    child: Image.asset(
                                      'assets/images/icons/basura.png',
                                      height: 20,
                                      width: 20,
                                      color: _colors[index % 2],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              } else {
                return Container();
              }
            }),
      ),
    );
  }
}
