class Atencion {
  final String id;
  final String pacienteId;
  final String pacienteNombre;
  final String diagnostico;
  final String medicamentos;
  final String procedimiento;
  final String observaciones;
  final DateTime fechaRegistro;

  Atencion({
    required this.id,
    required this.pacienteId,
    required this.pacienteNombre,
    required this.diagnostico,
    required this.medicamentos,
    required this.procedimiento,
    required this.observaciones,
    required this.fechaRegistro,
  });
}