import '../entities/atencion.dart';
import '../entities/paciente.dart';

abstract class PacienteRepository {
  Future<void> registrarPaciente({
    required String nombre,
    required int edad,
    required String tipoEmergencia,
    required String hospitalId,
    required String hospitalNombre,
  });

  Stream<List<Paciente>> getPacientesStream();

  Stream<List<Paciente>> getEmergenciasActivasStream();

  Future<void> cambiarEstadoPaciente({
    required String pacienteId,
    required String nuevoEstado,
  });

  Future<void> guardarAtencion({
    required String pacienteId,
    required String pacienteNombre,
    required String diagnostico,
    required String medicamentos,
    required String procedimiento,
    required String observaciones,
  });

  Future<void> darEgresoPaciente({
    required String pacienteId,
    required String hospitalId,
  });

  Stream<List<Atencion>> getAtencionesByPaciente(String pacienteId);
}