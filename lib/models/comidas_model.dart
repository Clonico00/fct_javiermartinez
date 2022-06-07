
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class Comidas {
  String categoria;
  int _id;
  String imagen;
  String nombre;
  int stock;
  double precio;

  Comidas(this.categoria, this._id, this.imagen, this.nombre, this.stock,
      this.precio);
      
  @override
  String toString() {
    return ' ${this.nombre}, ${this.categoria}, ${this.imagen}, ${this._id}, ${this.precio}, ${this.stock} ';
  }


}
