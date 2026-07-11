import '../entities/usuario_app.dart';

abstract class AuthRepository {
  Future<void> login({
    required String email,
    required String password,
  });

  Future<void> register({
    required String nombre,
    required String email,
    required String password,
    required String rol,
    String hospitalId,
    String especialidad,
    String unidad,
  });

  Future<void> logout();

  Future<UsuarioApp?> getCurrentUserData();
}