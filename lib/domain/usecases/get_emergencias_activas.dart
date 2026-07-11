import '../entities/paciente.dart';
import '../repositories/paciente_repository.dart';

class GetEmergenciasActivas {
  final PacienteRepository repository;

  GetEmergenciasActivas(this.repository);

  Stream<List<Paciente>> call() {
    return repository.getEmergenciasActivasStream();
  }
}