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
    initial();
  }

  void initial() async {
    login = await SharedPreferences.getInstance();
  }

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
            children: [
              InkWell(
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
              Text("Croissanteria Párraga: Comandas",
                  style: TextStyle(
                      color: _colorsRV[1],
                      fontSize: 18,
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
        child: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection("comandas").snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return ListTileTheme(
                  contentPadding: EdgeInsets.all(25),
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    shrinkWrap: false,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      
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
                                      // set up the buttons
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
