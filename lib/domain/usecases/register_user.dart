import '../repositories/auth_repository.dart';

class RegisterUser {
  final AuthRepository repository;

  RegisterUser(this.repository);

  Future<void> call({
    required String nombre,
    required String email,
    required String password,
    required String rol,
    String hospitalId = '',
    String especialidad = '',
    String unidad = '',
  }) async {
    await repository.register(
      nombre: nombre,
      email: email,
      password: password,
      rol: rol,
      hospitalId: hospitalId,
      especialidad: especialidad,
      unidad: unidad,
    );
  }
}