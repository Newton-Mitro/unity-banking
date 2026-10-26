import '../entities/member.dart';

abstract class AuthRepository {
  Future<String> login(String mobile, String password);
  Future<Member> verifyOtp(String verificationId, String otp);
  Future<void> logout();
  Future<Member?> getSession();
}
