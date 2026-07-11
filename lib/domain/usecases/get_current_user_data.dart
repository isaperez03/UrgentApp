import '../entities/usuario_app.dart';
import '../repositories/auth_repository.dart';

class GetCurrentUserData {
  final AuthRepository repository;

  GetCurrentUserData(this.repository);

  Future<UsuarioApp?> call() async {
    return await repository.getCurrentUserData();
  }
}