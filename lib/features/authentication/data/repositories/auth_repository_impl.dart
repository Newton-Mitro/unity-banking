import '../../domain/entities/member.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/member_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<String> login(String mobile, String password) async {
    return await remoteDataSource.login(mobile, password);
  }

  @override
  Future<Member> verifyOtp(String verificationId, String otp) async {
    final result = await remoteDataSource.verifyOtp(verificationId, otp);

    final member = MemberModel.fromJson(result['member']);
    final accessToken = result['accessToken'];
    final refreshToken = result['refreshToken'];

    await localDataSource.saveMember(member);
    await localDataSource.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );

    return member;
  }

  @override
  Future<void> logout() async {
    try {
      await remoteDataSource.logout();
    } catch (_) {
      // Even if remote logout fails, we clear local session
    } finally {
      await localDataSource.clear();
    }
  }

  @override
  Future<Member?> getSession() async {
    final member = await localDataSource.getMember();
    final token = await localDataSource.getAccessToken();

    if (member != null && token != null) {
      return member;
    }
    return null;
  }
}
