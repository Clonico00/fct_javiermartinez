import 'package:cloud_firestore/cloud_firestore.dart';
//creamos la instancia de la base de datos
FirebaseFirestore firestore = FirebaseFirestore.instance;
//creamos la instancia de la collecion que queramos añadir elementos identificada por su id
CollectionReference comidas = firestore.collection('comidas');
Future<void> addUser() {
  
  return comidas
  //los datos han sido añadidos uno a uno a traves del siguiente metodo, cambiando unicamente los valores
      .add({
        '_id': 35,
        'nombre': 'helado fresa',
        'imagen': 'assets/images/postres/heladofresa.png',
        'categoria': 'postres',
        'precio': 2.50,
        'stock': 200,
      })
      .then((value) => print("Comida añadida"))
      .catchError((error) => print("Failed to add user: $error"));
}
