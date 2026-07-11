import '../entities/habitacion.dart';

abstract class HabitacionRepository {
  Stream<List<Habitacion>> getHabitacionesStream();

  Stream<List<Habitacion>> getHabitacionesByHospital(String hospitalId);

  Future<void> actualizarEstadoHabitacion({
    required String habitacionId,
    required String nuevoEstado,
  });
}