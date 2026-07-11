import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/atencion.dart';

class AtencionModel extends Atencion {
  AtencionModel({
    required super.id,
    required super.pacienteId,
    required super.pacienteNombre,
    required super.diagnostico,
    required super.medicamentos,
    required super.procedimiento,
    required super.observaciones,
    required super.fechaRegistro,
  });

  Map<String, dynamic> toMap() {
    return {
      'pacienteId': pacienteId,
      'pacienteNombre': pacienteNombre,
      'diagnostico': diagnostico,
      'medicamentos': medicamentos,
      'procedimiento': procedimiento,
      'observaciones': observaciones,
      'fechaRegistro': Timestamp.fromDate(fechaRegistro),
    };
  }

  factory AtencionModel.fromMap(String id, Map<String, dynamic> map) {
    final dynamic fecha = map['fechaRegistro'];

    DateTime fechaConvertida;
    if (fecha is Timestamp) {
      fechaConvertida = fecha.toDate();
    } else if (fecha is String) {
      fechaConvertida = DateTime.tryParse(fecha) ?? DateTime.now();
    } else {
      fechaConvertida = DateTime.now();
    }

    return AtencionModel(
      id: id,
      pacienteId: (map['pacienteId'] ?? '').toString(),
      pacienteNombre: (map['pacienteNombre'] ?? '').toString(),
      diagnostico: (map['diagnostico'] ?? '').toString(),
      medicamentos: (map['medicamentos'] ?? '').toString(),
      procedimiento: (map['procedimiento'] ?? '').toString(),
      observaciones: (map['observaciones'] ?? '').toString(),
      fechaRegistro: fechaConvertida,
    );
  }
}