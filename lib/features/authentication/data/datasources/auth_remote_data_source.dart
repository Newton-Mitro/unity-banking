import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/member_model.dart';

abstract class AuthRemoteDataSource {
  Future<String> login(String mobile, String password);
  Future<Map<String, dynamic>> verifyOtp(String verificationId, String otp);
  Future<void> logout();
  Future<MemberModel> getMe();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl(this.apiClient);

  @override
  Future<String> login(String mobile, String password) async {
    final response = await apiClient.post(
      ApiEndpoints.login,
      data: {'mobile': mobile, 'password': password},
    );
    return response.data['verificationId'];
  }

  @override
  Future<Map<String, dynamic>> verifyOtp(
    String verificationId,
    String otp,
  ) async {
    final response = await apiClient.post(
      ApiEndpoints.verifyOtp,
      data: {'verificationId': verificationId, 'otp': otp},
    );
    return response.data;
  }

  @override
  Future<void> logout() async {
    await apiClient.post(ApiEndpoints.logout);
  }

  @override
  Future<MemberModel> getMe() async {
    final response = await apiClient.get(ApiEndpoints.me);
    return MemberModel.fromJson(response.data);
  }
}
