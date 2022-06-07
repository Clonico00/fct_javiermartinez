// ignore_for_file: unused_import, prefer_const_constructors, unnecessary_const, sized_box_for_whitespace, use_full_hex_values_for_flutter_colors, unused_local_variable, unused_element, avoid_print, body_might_complete_normally_nullable, unnecessary_new, unused_catch_clause
import 'dart:io';
import 'dart:math';

import 'package:connection_status_bar/connection_status_bar.dart';
import 'package:fct_javiermartinez/views/pantalla_camareros.dart';
import 'package:fct_javiermartinez/views/pantalla_cocineros.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
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


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //inicializamos Firebase a la vez que la aplicacion
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
        //si se puede conectar a Firebase iniciazmoa con el login
        if (snapshot.connectionState == ConnectionState.done) {
          return LoginScreen();
        }
        //si no ponemos un indicador de progreso
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
    //con el uso de las preferencias de flutter, comprobramos que el usuario no haya cerrado sesion
    check_if_already_login();
  }
//metodo para comprobar el login con Firebase Auth
  static Future<User?> loginUsingEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    User? user;
    try {
      //comprobamos que hay internet
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        //si hay internet leemos el usuario y comprobamos si existe, llamando al metodo de creacion de usuario
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
            email: email, password: password);
        // si no existe ese usuario nos devolvera null de lo contrario nos devolvera un obejto de tipo usuario
        //con totos los datos de este    
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
  //metodo para crear un usuario auque no se usa en nuestra app
  Future signUp(String email, String password) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        //si hay internet creamos un usuario con el correo y contraseña
        FirebaseAuth auth = FirebaseAuth.instance;
        await auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) async {
          // lo añadimos a nuestra coleccion de users
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
                                  //primero comprobamos que hay datos en los dos TextFields
                                  if (!_emailController.text.isEmpty ||
                                      !_passwordController.text.isEmpty) {
                                    //ahora vemos si el usuario existe en nuestra Base de Datos, si no existe user valdra null
                                    //tambien guardamos en las preferencias dependiendo de quien se haya logeado un id, para asi poder mantenter la sesion 
                                    //abierta aunque se salga de la app
                                    User? user = await loginUsingEmailPassword(
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                        context: context);
                                    if (user != null) {
                                      // si es el correo y contraseña de camareros lo mandamos a su seccion                       
                                      if (_emailController.text ==
                                          "waitress@gmail.com") {
                                        login.setBool('login', false);
                                        login.setString('user', 'waitress');
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CamarerosScreen()));
                                      } else {
                                         // si es el correo y contraseña de cocineros lo mandamos a su seccion
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
                                  // para crear el alertdialog, nos hace falta crear los widget de los botones por separado
                                  // si pulsa que no cerramos el alertdialog
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
                                  // si pulsa que si lo mandamos a la seccion de camareros
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
                                  // mostramos el alertdialog
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
  //metodo para comprobar en base a las preferencias si el usuario se ha logeado anteriormente y no ha cerrado sesion
  void check_if_already_login() async { 
    // nos creamos una instancia de la clase SHARED PREFERENCES para ver los datos almacenados en ella
    login = await SharedPreferences.getInstance();
    newuser = (login.getBool('login') ?? true);
    String user = (login.getString('user').toString());
    if (newuser == false) {
      // si es true comprobamos quien se ha logeado si el camarero o el cocinero y asi iniciar la aplicacion en el menu principal de cada uno
      if (user == 'waitress') {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => CamarerosScreen()));
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => CocinerosScreen()));
      }
    }
  }
  // metodo que lo llamamos para crear un mensaje y al cual le pasamos solamento el contexto y el String del 
  // mensaje
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
