import '../entities/hospital.dart';

abstract class HospitalRepository {
  Stream<List<Hospital>> getAvailableHospitalsStream();
}
