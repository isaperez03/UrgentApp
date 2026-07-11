import '../entities/atencion.dart';
import '../repositories/paciente_repository.dart';

class GetPatientHistory {
  final PacienteRepository repository;

  GetPatientHistory(this.repository);

  Stream<List<Atencion>> call(String pacienteId) {
    return repository.getAtencionesByPaciente(pacienteId);
  }
}