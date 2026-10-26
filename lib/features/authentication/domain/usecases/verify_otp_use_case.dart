import '../entities/member.dart';
import '../repositories/auth_repository.dart';

class VerifyOtpUseCase {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<Member> call(String verificationId, String otp) {
    return repository.verifyOtp(verificationId, otp);
  }
}
