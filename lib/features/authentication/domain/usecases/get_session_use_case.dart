import '../entities/member.dart';
import '../repositories/auth_repository.dart';

class GetSessionUseCase {
  final AuthRepository repository;

  GetSessionUseCase(this.repository);

  Future<Member?> call() {
    return repository.getSession();
  }
}
