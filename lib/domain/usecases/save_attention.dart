import '../repositories/paciente_repository.dart';

class SaveAttention {
  final PacienteRepository repository;

  SaveAttention(this.repository);

  Future<void> call({
    required String pacienteId,
    required String pacienteNombre,
    required String diagnostico,
    required String medicamentos,
    required String procedimiento,
    required String observaciones,
  }) async {
    await repository.guardarAtencion(
      pacienteId: pacienteId,
      pacienteNombre: pacienteNombre,
      diagnostico: diagnostico,
      medicamentos: medicamentos,
      procedimiento: procedimiento,
      observaciones: observaciones,
    );
  }
}
