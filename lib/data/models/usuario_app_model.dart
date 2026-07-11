import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/usuario_app.dart';

class UsuarioAppModel extends UsuarioApp {
  UsuarioAppModel({
    required super.uid,
    required super.nombre,
    required super.correo,
    required super.rol,
    required super.activo,
    required super.hospitalId,
    required super.especialidad,
    required super.unidad,
    required super.fechaRegistro,
  });

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'correo': correo,
      'rol': rol,
      'activo': activo,
      'hospitalId': hospitalId,
      'especialidad': especialidad,
      'unidad': unidad,
      'fechaRegistro': Timestamp.fromDate(fechaRegistro),
    };
  }

  factory UsuarioAppModel.fromMap(String uid, Map<String, dynamic> map) {
    final dynamic fecha = map['fechaRegistro'];

    DateTime fechaConvertida;
    if (fecha is Timestamp) {
      fechaConvertida = fecha.toDate();
    } else if (fecha is String) {
      fechaConvertida = DateTime.tryParse(fecha) ?? DateTime.now();
    } else {
      fechaConvertida = DateTime.now();
    }

    return UsuarioAppModel(
      uid: uid,
      nombre: (map['nombre'] ?? '').toString(),
      correo: (map['correo'] ?? '').toString(),
      rol: (map['rol'] ?? '').toString(),
      activo: map['activo'] ?? false,
      hospitalId: (map['hospitalId'] ?? '').toString(),
      especialidad: (map['especialidad'] ?? '').toString(),
      unidad: (map['unidad'] ?? '').toString(),
      fechaRegistro: fechaConvertida,
    );
  }
}