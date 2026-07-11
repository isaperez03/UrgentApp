import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/habitacion.dart';

class HabitacionModel extends Habitacion {
  HabitacionModel({
    required super.id,
    required super.idHospital,
    required super.numero,
    required super.piso,
    required super.tipo,
    required super.descripcion,
    required super.estado,
    required super.idPacienteActual,
    required super.idAsignacionActiva,
    required super.fechaActualizacion,
  });

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  factory HabitacionModel.fromMap(String id, Map<String, dynamic> map) {
    final dynamic fecha = map['fechaActualizacion'];

    DateTime fechaConvertida;
    if (fecha is Timestamp) {
      fechaConvertida = fecha.toDate();
    } else if (fecha is String) {
      fechaConvertida = DateTime.tryParse(fecha) ?? DateTime.now();
    } else {
      fechaConvertida = DateTime.now();
    }

    return HabitacionModel(
      id: id,
      idHospital: (map['idHospital'] ?? '').toString(),
      numero: (map['numero'] ?? '').toString(),
      piso: _toInt(map['piso']),
      tipo: (map['tipo'] ?? '').toString().toLowerCase(),
      descripcion: (map['descripcion'] ?? '').toString(),
      estado: (map['estado'] ?? '').toString().toLowerCase(),
      idPacienteActual: (map['idPacienteActual'] ?? '').toString(),
      idAsignacionActiva:
      (map['idAsignacionActiva'] ?? map['idAsignacionActual'] ?? '')
          .toString(),
      fechaActualizacion: fechaConvertida,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idHospital': idHospital,
      'numero': numero,
      'piso': piso,
      'tipo': tipo.toLowerCase(),
      'descripcion': descripcion,
      'estado': estado.toLowerCase(),
      'idPacienteActual': idPacienteActual,
      'idAsignacionActiva': idAsignacionActiva,
      'fechaActualizacion': Timestamp.fromDate(fechaActualizacion),
    };
  }
}