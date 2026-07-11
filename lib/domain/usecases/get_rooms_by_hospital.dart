import '../entities/habitacion.dart';
import '../repositories/habitacion_repository.dart';

class GetRoomsByHospital {
  final HabitacionRepository repository;

  GetRoomsByHospital(this.repository);

  Stream<List<Habitacion>> call(String hospitalId) {
    return repository.getHabitacionesByHospital(hospitalId);
  }
}