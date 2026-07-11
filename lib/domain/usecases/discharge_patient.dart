import '../repositories/paciente_repository.dart';

class DischargePatient {
  final PacienteRepository repository;

  DischargePatient(this.repository);

  Future<void> call({
    required String pacienteId,
    required String hospitalId,
  }) async {
    await repository.darEgresoPaciente(
      pacienteId: pacienteId,
      hospitalId: hospitalId,
    );
  }
}