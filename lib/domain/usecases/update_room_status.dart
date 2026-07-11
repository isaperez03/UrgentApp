import '../repositories/habitacion_repository.dart';

class UpdateRoomStatus {
  final HabitacionRepository repository;

  UpdateRoomStatus(this.repository);

  Future<void> call({
    required String habitacionId,
    required String nuevoEstado,
  }) async {
    await repository.actualizarEstadoHabitacion(
      habitacionId: habitacionId,
      nuevoEstado: nuevoEstado,
    );
  }
}