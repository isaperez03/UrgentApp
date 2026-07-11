import '../entities/paciente.dart';
import '../repositories/paciente_repository.dart';

class GetPacientes {
  final PacienteRepository repository;

  GetPacientes(this.repository);

  Stream<List<Paciente>> call() {
    return repository.getPacientesStream();
  }
}