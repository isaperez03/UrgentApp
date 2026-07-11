import '../repositories/paciente_repository.dart';

class UpdatePatientStatus {
  final PacienteRepository repository;

  UpdatePatientStatus(this.repository);

  Future<void> call({
    required String pacienteId,
    required String nuevoEstado,
  }) async {
    await repository.cambiarEstadoPaciente(
      pacienteId: pacienteId,
      nuevoEstado: nuevoEstado,
    );
  }
}
