import '../../domain/entities/habitacion.dart';
import '../../domain/repositories/habitacion_repository.dart';
import '../datasources/habitacion_remote_datasource.dart';

class HabitacionRepositoryImpl implements HabitacionRepository {
  final HabitacionRemoteDataSource remoteDataSource;

  HabitacionRepositoryImpl(this.remoteDataSource);

  @override
  Stream<List<Habitacion>> getHabitacionesStream() {
    return remoteDataSource.getHabitacionesStream();
  }

  @override
  Stream<List<Habitacion>> getHabitacionesByHospital(String hospitalId) {
    return remoteDataSource.getHabitacionesByHospital(hospitalId);
  }

  @override
  Future<void> actualizarEstadoHabitacion({
    required String habitacionId,
    required String nuevoEstado,
  }) async {
    await remoteDataSource.actualizarEstadoHabitacion(
      habitacionId: habitacionId,
      nuevoEstado: nuevoEstado,
    );
  }
}