import '../../domain/entities/usuario_app.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> login({
    required String email,
    required String password,
  }) async {
    await remoteDataSource.login(email: email, password: password);
  }

  @override
  Future<void> register({
    required String nombre,
    required String email,
    required String password,
    required String rol,
    String hospitalId = '',
    String especialidad = '',
    String unidad = '',
  }) async {
    await remoteDataSource.register(
      nombre: nombre,
      email: email,
      password: password,
      rol: rol,
      hospitalId: hospitalId,
      especialidad: especialidad,
      unidad: unidad,
    );
  }

  @override
  Future<void> logout() async {
    await remoteDataSource.logout();
  }

  @override
  Future<UsuarioApp?> getCurrentUserData() async {
    return await remoteDataSource.getCurrentUserData();
  }
}