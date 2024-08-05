import 'dart:convert';

class TransportModel {
  final int id;
  final String nombre;
  final String tipo;
  final int capacidad;
  final double longitud;

  TransportModel({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.capacidad,
    required this.longitud,
  });

  factory TransportModel.fromJson(Map<String, dynamic> json) {
    return TransportModel(
      id: json['id'],
      nombre: json['nombre'],
      tipo: json['tipo'],
      capacidad: json['capacidad'],
      longitud: json['longitud'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'tipo': tipo,
      'capacidad': capacidad,
      'longitud': longitud,
    };
  }
}
