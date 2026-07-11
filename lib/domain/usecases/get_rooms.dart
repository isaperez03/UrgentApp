import '../entities/habitacion.dart';
import '../repositories/habitacion_repository.dart';

class GetRooms {
  final HabitacionRepository repository;

  GetRooms(this.repository);

  Stream<List<Habitacion>> call() {
    return repository.getHabitacionesStream();
  }
}