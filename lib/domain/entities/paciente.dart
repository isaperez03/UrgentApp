class Paciente {
  final String id;
  final String nombre;
  final int edad;
  final String tipoEmergencia;
  final String hospitalId;
  final String hospitalNombre;
  final String estado;
  final DateTime fechaRegistro;

  Paciente({
    required this.id,
    required this.nombre,
    required this.edad,
    required this.tipoEmergencia,
    required this.hospitalId,
    required this.hospitalNombre,
    required this.estado,
    required this.fechaRegistro,
  });
}