class Hospital {
  final String id;
  final String nombre;
  final String direccion;
  final String zona;
  final bool activo;
  final bool disponibleUrgencias;
  final int habitacionesLibres;
  final int habitacionesOcupadas;
  final int uciLibres;
  final int uciOcupadas;
  final String telefono;
  final double latitud;
  final double longitud;
  final List<String> especialidades;

  Hospital({
    required this.id,
    required this.nombre,
    required this.direccion,
    required this.zona,
    required this.activo,
    required this.disponibleUrgencias,
    required this.habitacionesLibres,
    required this.habitacionesOcupadas,
    required this.uciLibres,
    required this.uciOcupadas,
    required this.telefono,
    required this.latitud,
    required this.longitud,
    required this.especialidades,
  });
}