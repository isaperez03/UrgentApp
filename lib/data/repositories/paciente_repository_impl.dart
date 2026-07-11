import '../../domain/entities/atencion.dart';
import '../../domain/entities/paciente.dart';
import '../../domain/repositories/paciente_repository.dart';
import '../datasources/paciente_remote_datasource.dart';

class PacienteRepositoryImpl implements PacienteRepository {
  final PacienteRemoteDataSource remoteDataSource;

  PacienteRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> registrarPaciente({
    required String nombre,
    required int edad,
    required String tipoEmergencia,
    required String hospitalId,
    required String hospitalNombre,
  }) async {
    await remoteDataSource.registrarPaciente(
      nombre: nombre,
      edad: edad,
      tipoEmergencia: tipoEmergencia,
      hospitalId: hospitalId,
      hospitalNombre: hospitalNombre,
    );
  }

  @override
  Stream<List<Paciente>> getPacientesStream() {
    return remoteDataSource.getPacientesStream();
  }

  @override
  Stream<List<Paciente>> getEmergenciasActivasStream() {
    return remoteDataSource.getEmergenciasActivasStream();
  }

  @override
  Future<void> cambiarEstadoPaciente({
    required String pacienteId,
    required String nuevoEstado,
  }) async {
    await remoteDataSource.cambiarEstadoPaciente(
      pacienteId: pacienteId,
      nuevoEstado: nuevoEstado,
    );
  }

  @override
  Future<void> guardarAtencion({
    required String pacienteId,
    required String pacienteNombre,
    required String diagnostico,
    required String medicamentos,
    required String procedimiento,
    required String observaciones,
  }) async {
    await remoteDataSource.guardarAtencion(
      pacienteId: pacienteId,
      pacienteNombre: pacienteNombre,
      diagnostico: diagnostico,
      medicamentos: medicamentos,
      procedimiento: procedimiento,
      observaciones: observaciones,
    );
  }

  @override
  Future<void> darEgresoPaciente({
    required String pacienteId,
    required String hospitalId,
  }) async {
    await remoteDataSource.darEgresoPaciente(
      pacienteId: pacienteId,
      hospitalId: hospitalId,
    );
  }

  @override
  Stream<List<Atencion>> getAtencionesByPaciente(String pacienteId) {
    return remoteDataSource.getAtencionesByPaciente(pacienteId);
  }
}