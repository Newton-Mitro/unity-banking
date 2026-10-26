import '../models/member_model.dart';
import 'auth_remote_data_source.dart';

class MockAuthRemoteDataSource implements AuthRemoteDataSource {
  static const verificationId = 'unity-demo-verification';
  static const demoOtp = '123456';

  @override
  Future<String> login(String mobile, String password) async {
    return verificationId;
  }

  @override
  Future<Map<String, dynamic>> verifyOtp(
    String verificationId,
    String otp,
  ) async {
    if (verificationId != MockAuthRemoteDataSource.verificationId ||
        otp != demoOtp) {
      throw Exception('Use the demo verification code 123456.');
    }

    return {
      'member': {
        'id': 'demo-member-01',
        'memberNumber': 'UB-9847291',
        'name': 'Newton',
        'mobile': '5550101234',
        'email': 'newton@example.com',
        'status': 'active',
      },
      'accessToken': 'unity-demo-access-token',
      'refreshToken': 'unity-demo-refresh-token',
    };
  }

  @override
  Future<void> logout() async {}

  @override
  Future<MemberModel> getMe() async {
    return MemberModel.fromJson({
      'id': 'demo-member-01',
      'memberNumber': 'UB-9847291',
      'name': 'Newton',
      'mobile': '5550101234',
      'email': 'newton@example.com',
      'status': 'active',
    });
  }
}
