import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
  factory Comidas.fromJson(dynamic json) {
    return Comidas(
      json['categoria'] as String,
      json['_id'] as int,
      json['imagen'] as String,
      json['nombre'] as String,
      json['stock'] as int,
      json['precio'] as double,
    );
  }
  @override
  String toString() {
    return '{ ${this.nombre}, ${this.categoria}, ${this.imagen}, ${this._id}, ${this.precio}, ${this.stock} }';
  }
}
