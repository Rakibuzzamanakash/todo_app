import '../user_entity/uesr_entity.dart';

abstract class AuthRepository {
  Future<User?> login(String username, String password);
}

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<User?> call(String username, String password) {
    return repository.login(username, password);
  }
}
