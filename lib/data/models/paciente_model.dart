import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/paciente.dart';

class PacienteModel extends Paciente {
  PacienteModel({
    required super.id,
    required super.nombre,
    required super.edad,
    required super.tipoEmergencia,
    required super.hospitalId,
    required super.hospitalNombre,
    required super.estado,
    required super.fechaRegistro,
  });

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'edad': edad,
      'tipoEmergencia': tipoEmergencia,
      'hospitalId': hospitalId,
      'hospitalNombre': hospitalNombre,
      'estado': estado,
      'fechaRegistro': Timestamp.fromDate(fechaRegistro),
    };
  }

  factory PacienteModel.fromMap(String id, Map<String, dynamic> map) {
    final dynamic fecha = map['fechaRegistro'];

    DateTime fechaConvertida;
    if (fecha is Timestamp) {
      fechaConvertida = fecha.toDate();
    } else if (fecha is String) {
      fechaConvertida = DateTime.tryParse(fecha) ?? DateTime.now();
    } else {
      fechaConvertida = DateTime.now();
    }

    return PacienteModel(
      id: id,
      nombre: (map['nombre'] ?? '').toString(),
      edad: (map['edad'] ?? 0) as int,
      tipoEmergencia: (map['tipoEmergencia'] ?? '').toString(),
      hospitalId: (map['hospitalId'] ?? '').toString(),
      hospitalNombre: (map['hospitalNombre'] ?? '').toString(),
      estado: (map['estado'] ?? '').toString(),
      fechaRegistro: fechaConvertida,
    );
  }
}