import '../repositories/paciente_repository.dart';

class RegisterPatient {
  final PacienteRepository repository;

  RegisterPatient(this.repository);

  Future<void> call({
    required String nombre,
    required int edad,
    required String tipoEmergencia,
    required String hospitalId,
    required String hospitalNombre,
  }) async {
    await repository.registrarPaciente(
      nombre: nombre,
      edad: edad,
      tipoEmergencia: tipoEmergencia,
      hospitalId: hospitalId,
      hospitalNombre: hospitalNombre,
    );
  }
}