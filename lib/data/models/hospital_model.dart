import '../../domain/entities/hospital.dart';

class HospitalModel extends Hospital {
  HospitalModel({
    required super.id,
    required super.nombre,
    required super.direccion,
    required super.zona,
    required super.activo,
    required super.disponibleUrgencias,
    required super.habitacionesLibres,
    required super.habitacionesOcupadas,
    required super.uciLibres,
    required super.uciOcupadas,
    required super.telefono,
    required super.latitud,
    required super.longitud,
    required super.especialidades,
  });

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return 0;
  }

  factory HospitalModel.fromMap(String id, Map<String, dynamic> map) {
    return HospitalModel(
      id: id,
      nombre: (map['nombre'] ?? '').toString(),
      direccion: (map['direccion'] ?? '').toString(),
      zona: (map['zona'] ?? '').toString(),
      activo: map['activo'] ?? false,
      disponibleUrgencias: map['disponibleUrgencias'] ?? true,
      habitacionesLibres: _toInt(
        map['habitacionesLibres'] ?? map['habitacionesLibre'],
      ),
      habitacionesOcupadas: _toInt(map['habitacionesOcupadas']),
      uciLibres: _toInt(
        map['uciLibres'] ?? map['uicLibres'],
      ),
      uciOcupadas: _toInt(
        map['uciOcupadas'] ?? map['uicOcupadas'],
      ),
      telefono: (map['telefono'] ?? '').toString(),
      latitud: ((map['latitud'] ?? 0) as num).toDouble(),
      longitud: ((map['longitud'] ?? 0) as num).toDouble(),
      especialidades: List<String>.from(map['especialidades'] ?? []),
    );
  }
}