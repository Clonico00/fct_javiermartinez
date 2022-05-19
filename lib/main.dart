// ignore_for_file: unused_import, prefer_const_constructors, unnecessary_const, sized_box_for_whitespace, use_full_hex_values_for_flutter_colors, unused_local_variable, unused_element, avoid_print, body_might_complete_normally_nullable, unnecessary_new
import 'dart:math';

import 'package:fct_javiermartinez/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  //login
  static Future<User?> loginUsingEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        print("No user found for that email");
      }
    }
    return user;
  }

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
    return Color(0xFF42A5F5);
  }

  Future<String> signUp(String email, String password) async {
    try {
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
    } on FirebaseAuthException catch (e) {
      print(e.code.toString());
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    //textfield controler
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

    return DefaultTextStyle(
      style: Theme.of(context).textTheme.bodyText2!,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child :Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        // ignore: prefer_const_literals_to_create_immutables

        children: [
          Center(
            child: Image.asset(
              'assets/images/cp.jpg',
              height: 175,
              width: 175,
            ),
          ),
          const SizedBox(
            height: 44.0,
          ),
          Center(
            child: const Text("Croissanteria Parraga",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: Color.fromARGB(255, 18, 22, 134),
                  fontSize: 30.0,
                  fontFamily: 'Comfortaa',
                )),
          ),
          const SizedBox(
            height: 44.0,
          ),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
                hintText: "Email",
                prefixIcon:
                    Icon(Icons.mail, color: Color.fromARGB(255, 18, 22, 134))),
          ),
          const SizedBox(
            height: 44.0,
          ),
          TextField(
            controller: _passwordController,
            keyboardType: TextInputType.emailAddress,
            obscureText: true,
            decoration: const InputDecoration(
                hintText: "Contraseña",
                prefixIcon:
                    Icon(Icons.lock, color: Color.fromARGB(255, 18, 22, 134))),
          ),
          const SizedBox(
            height: 12.0,
          ),
          const SizedBox(
            height: 40.0,
          ),
          Container(
              width: double.infinity,
              child: RawMaterialButton(
                fillColor: const Color(0XFFEEF08D),
                elevation: 0.0,
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                onPressed: () async {
                  User? user = await loginUsingEmailPassword(
                      email: _emailController.text,
                      password: _passwordController.text,
                      context: context);
                  print(user);
                  if (user != null) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => ProfileScreen()));
                  } else if (_emailController.text.isEmpty ||
                      _passwordController.text.isEmpty) {
                    Fluttertoast.showToast(
                      msg: "Please write an email and a password", // message
                      toastLength: Toast.LENGTH_LONG, // length
                      gravity: ToastGravity.TOP, // location
                      timeInSecForIosWeb: 2,
                      backgroundColor: Color.fromARGB(255, 18, 22, 134),
                      fontSize: 12.0,
                      // duration
                    );
                  } else {
                    Fluttertoast.showToast(
                        msg: "This email or password are incorrect", // message
                        toastLength: Toast.LENGTH_LONG, // length
                        gravity: ToastGravity.TOP, // location
                        timeInSecForIosWeb: 2,
                        backgroundColor: Color.fromARGB(255, 18, 22, 134),
                        fontSize: 15.0 // duration
                        );
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
                fillColor: const Color(0XFFEEF08D),
                elevation: 0.0,
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                onPressed: () async {
                  String pattern =
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regExp = new RegExp(pattern);
                  if (_passwordController.text.length >= 6) {
                    if (regExp.hasMatch(_emailController.text)) {
                      User? user = await loginUsingEmailPassword(
                          email: _emailController.text,
                          password: _passwordController.text,
                          context: context);
                      if (user == null) {
                        await signUp(
                          _emailController.text.trim(),
                          _passwordController.text.trim(),
                        ).then((value) async {
                          user = FirebaseAuth.instance.currentUser;
                          await FirebaseFirestore.instance
                              .collection("users")
                              .doc(user?.uid)
                              .set({
                            'uid': user?.uid,
                            'email': _emailController.text,
                            'password': _passwordController.text,
                          });
                        });
                      } else {
                        Fluttertoast.showToast(
                            msg: "Email already exists", // message
                            toastLength: Toast.LENGTH_LONG, // length
                            gravity: ToastGravity.TOP, // location
                            timeInSecForIosWeb: 2,
                            backgroundColor: Color.fromARGB(255, 18, 22, 134),
                            fontSize: 12.0 // duration
                            );
                      }
                    } else if (_emailController.text.isEmpty ||
                        _passwordController.text.isEmpty) {
                      Fluttertoast.showToast(
                          msg:
                              "Please write an email and a password", // message
                          toastLength: Toast.LENGTH_LONG, // length
                          gravity: ToastGravity.TOP, // location
                          timeInSecForIosWeb: 2,
                          backgroundColor: Color.fromARGB(255, 18, 22, 134),
                          fontSize: 12.0 // duration
                          );
                    } else {
                      Fluttertoast.showToast(
                          msg:
                              "This email or password are incorrect", // message
                          toastLength: Toast.LENGTH_LONG, // length
                          gravity: ToastGravity.TOP, // location
                          timeInSecForIosWeb: 2,
                          backgroundColor: Color.fromARGB(255, 18, 22, 134),
                          fontSize: 12.0 // duration
                          );
                    }
                  } else {
                    Fluttertoast.showToast(
                        msg:
                            "The minimun lenght for the password is 6", // message
                        toastLength: Toast.LENGTH_LONG, // length
                        gravity: ToastGravity.TOP, // location
                        timeInSecForIosWeb: 2,
                        backgroundColor: Color.fromARGB(255, 18, 22, 134),
                        fontSize: 12.0 // duration
                        );
                  }
                },
                child: const Text("CREAR USUARIO",
                    style: TextStyle(
                        color: Color.fromARGB(255, 18, 22, 134),
                        fontSize: 18.0,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Comfortaa')),
              ))
        ],
      ),
    )));
      
}));}}
