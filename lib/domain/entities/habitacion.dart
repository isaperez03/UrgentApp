class Habitacion {
  final String id;
  final String idHospital;
  final String numero;
  final int piso;
  final String tipo;
  final String descripcion;
  final String estado;
  final String idPacienteActual;
  final String idAsignacionActiva;
  final DateTime fechaActualizacion;

  Habitacion({
    required this.id,
    required this.idHospital,
    required this.numero,
    required this.piso,
    required this.tipo,
    required this.descripcion,
    required this.estado,
    required this.idPacienteActual,
    required this.idAsignacionActiva,
    required this.fechaActualizacion,
  });
}