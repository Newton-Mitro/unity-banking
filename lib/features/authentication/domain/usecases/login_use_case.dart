import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<String> call(String mobile, String password) {
    return repository.login(mobile, password);
  }
}
