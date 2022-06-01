// ignore_for_file: unused_import, prefer_const_constructors, unnecessary_const, sized_box_for_whitespace, use_full_hex_values_for_flutter_colors, unused_local_variable, unused_element, avoid_print, body_might_complete_normally_nullable, unnecessary_new, unused_catch_clause
import 'dart:io';
import 'dart:math';

import 'package:connection_status_bar/connection_status_bar.dart';
import 'package:fct_javiermartinez/pantalla_camareros.dart';
import 'package:fct_javiermartinez/pantalla_cocineros.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  //check_if_already_login();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

/* 
  Step 1 : create the main layout of the app (only the UI)
  Step 2 : Login to my firebase account
  Step 3 : Create a new firebase proyect
  Step 4 : Add firebase depenedeicies for flutter
  Step 5 : Init the firebase app
  Step 6 : Create the login function
  Step 7 : create a user and test the app
  IMPORTANTE:NO OLVIDAR IMPLMENTAR PREFERENCIAS
*/
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //iniatialze firebase app
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: _initializeFirebase(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return LoginScreen();
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    ));
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late SharedPreferences login;
  late bool newuser;
  //login
  @override
  void initState() {
    super.initState();
    check_if_already_login();
  }

  static Future<User?> loginUsingEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    User? user;
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
            email: email, password: password);
        user = userCredential.user;
      }
    } on FirebaseException catch (e) {
      if (e.code == "user-not-found") {
        print("No user found for that email");
      }
    } on SocketException catch (_) {
      final snackBar = SnackBar(
        backgroundColor: Color.fromARGB(255, 252, 252, 252),
        margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 100,
            right: 20,
            left: 20),
        padding: EdgeInsets.all(5.0),
        behavior: SnackBarBehavior.floating,
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        content: Text("Revise su conexion a internet",
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
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    return user;
  }

  Future signUp(String email, String password) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        FirebaseAuth auth = FirebaseAuth.instance;
        await auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) async {
          User? user = FirebaseAuth.instance.currentUser;
          await FirebaseFirestore.instance
              .collection("users")
              .doc(user!.uid)
              .set({
            'uid': user.uid,
            'email': email,
            'password': password,
          });
        });
      }
    } on SocketException catch (e) {
      showSnackBar(context, "Revise su conexion a internet");
    }
  }

  @override
  Widget build(BuildContext context) {
    //textfield controler
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

    return DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyText2!,
        child: LayoutBuilder(builder:
            (BuildContext context, BoxConstraints viewportConstraints) {
          return Container(
            decoration: new BoxDecoration(
                gradient: LinearGradient(colors: [
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 18, 22, 134),
            ], begin: Alignment.topCenter, end: Alignment(0.0, 1.0))),
            child: SingleChildScrollView(
                child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: viewportConstraints.maxHeight,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(30.0),
                                bottomRight: Radius.circular(30.0),
                                topLeft: Radius.circular(30.0),
                                topRight: Radius.circular(30.0),
                              ),
                              child: Image.asset(
                                'assets/images/cp.jpg',
                                height: 175,
                                width: 175,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 44.0,
                          ),
                          TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'Comfortaa'),
                            decoration: const InputDecoration(
                                hintText: "Email",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                  ),
                                ),
                                hintStyle: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255)),
                                prefixIcon: Icon(Icons.mail,
                                    color: Color.fromARGB(255, 255, 255, 255))),
                          ),
                          const SizedBox(
                            height: 44.0,
                          ),
                          TextField(
                            controller: _passwordController,
                            keyboardType: TextInputType.emailAddress,
                            obscureText: true,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'Comfortaa'),
                            decoration: const InputDecoration(
                                hintText: "Contraseña",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                  ),
                                ),
                                hintStyle: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255)),
                                prefixIcon: Icon(Icons.lock,
                                    color: Color.fromARGB(255, 255, 255, 255))),
                          ),
                          const SizedBox(
                            height: 80.0,
                          ),
                          Container(
                              width: double.infinity,
                              child: RawMaterialButton(
                                fillColor: Color.fromARGB(255, 255, 255, 255),
                                elevation: 0.0,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20.0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0)),
                                onPressed: () async {
                                  if (!_emailController.text.isEmpty ||
                                      !_passwordController.text.isEmpty) {
                                    User? user = await loginUsingEmailPassword(
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                        context: context);
                                    if (user != null) {
                                      if (_emailController.text ==
                                          "waitress@gmail.com") {
                                        login.setBool('login', false);
                                        login.setString('user', 'waitress');
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CamarerosScreen()));
                                      } else {
                                        login.setBool('login', false);
                                        login.setString('user', 'cook');
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CocinerosScreen()));
                                      }
                                    } else {
                                      showSnackBar(context,
                                          "Email y contraseña incorrectos");
                                    }
                                  } else {
                                    showSnackBar(context,
                                        "Por favor escribe un email y una contraseña");
                                  }
                                },
                                child: const Text("ACCEDER",
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 18, 22, 134),
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w900,
                                        fontFamily: 'Comfortaa')),
                              )),
                          const SizedBox(
                            height: 25.0,
                          ),
                          Container(
                              width: double.infinity,
                              child: RawMaterialButton(
                                fillColor: Color.fromARGB(255, 255, 255, 255),
                                elevation: 0.0,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20.0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0)),
                                onPressed: () async {
                                  // set up the buttons
                                  Widget cancelButton = TextButton(
                                    child: Text("No",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 18, 22, 134),
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
                                            color: Color.fromARGB(
                                                255, 18, 22, 134),
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Comfortaa')),
                                    onPressed: () {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CamarerosScreen()));
                                    },
                                  );

                                  // set up the AlertDialog
                                  AlertDialog alert = AlertDialog(
                                    backgroundColor:
                                        Color.fromARGB(255, 255, 255, 255),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(30)),
                                    title: Text("Aviso",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 18, 22, 134),
                                            fontWeight: FontWeight.w800,
                                            fontFamily: 'Comfortaa')),
                                    content: Text(
                                        "¿Seguro que quieres acceder en modo sin conexion?\nAccederas directamente a la seccion de Camareros pero las comandas no se enviaran hasta que tengas conexion",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 18, 22, 134),
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
                                },
                                child: const Text("ACCEDER SIN CONEXION",
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 18, 22, 134),
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w900,
                                        fontFamily: 'Comfortaa')),
                              ))
                        ],
                      ),
                    ))),
          );
        }));
  }

  void check_if_already_login() async { 
    login = await SharedPreferences.getInstance();
    newuser = (login.getBool('login') ?? true);
    String user = (login.getString('user').toString());
    if (newuser == false) {
      if (user == 'waitress') {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => CamarerosScreen()));
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => CocinerosScreen()));
      }
    }
  }

  void showSnackBar(BuildContext context, String error) {
    final snackBar = SnackBar(
      backgroundColor: Color.fromARGB(255, 252, 252, 252),
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 100,
          right: 20,
          left: 20),
      padding: EdgeInsets.all(5.0),
      behavior: SnackBarBehavior.floating,
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      content: Text(error,
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
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
