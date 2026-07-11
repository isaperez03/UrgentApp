import '../../domain/entities/hospital.dart';
import '../../domain/repositories/hospital_repository.dart';
import '../datasources/hospital_remote_datasource.dart';

class HospitalRepositoryImpl implements HospitalRepository {
  final HospitalRemoteDataSource remoteDataSource;

  HospitalRepositoryImpl(this.remoteDataSource);

  @override
  Stream<List<Hospital>> getAvailableHospitalsStream() {
    return remoteDataSource.getAvailableHospitalsStream();
  }
}