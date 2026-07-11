import '../entities/hospital.dart';
import '../repositories/hospital_repository.dart';

class GetAvailableHospitals {
  final HospitalRepository repository;

  GetAvailableHospitals(this.repository);

  Stream<List<Hospital>> call() {
    return repository.getAvailableHospitalsStream();
  }
}