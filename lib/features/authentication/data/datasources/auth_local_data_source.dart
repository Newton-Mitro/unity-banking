import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/member_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  });
  Future<void> saveMember(MemberModel member);
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<MemberModel?> getMember();
  Future<void> clear();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const String _kAccessToken = 'access_token';
  static const String _kRefreshToken = 'refresh_token';
  static const String _kMember = 'member';

  AuthLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await sharedPreferences.setString(
      _kAccessToken,
      base64Encode(utf8.encode(accessToken)),
    );
    await sharedPreferences.setString(
      _kRefreshToken,
      base64Encode(utf8.encode(refreshToken)),
    );
  }

  @override
  Future<void> saveMember(MemberModel member) async {
    await sharedPreferences.setString(_kMember, jsonEncode(member.toJson()));
  }

  @override
  Future<String?> getAccessToken() async {
    final masked = sharedPreferences.getString(_kAccessToken);
    if (masked == null) return null;
    return utf8.decode(base64Decode(masked));
  }

  @override
  Future<String?> getRefreshToken() async {
    final masked = sharedPreferences.getString(_kRefreshToken);
    if (masked == null) return null;
    return utf8.decode(base64Decode(masked));
  }

  @override
  Future<MemberModel?> getMember() async {
    final jsonString = sharedPreferences.getString(_kMember);
    if (jsonString == null) return null;
    return MemberModel.fromJson(jsonDecode(jsonString));
  }

  @override
  Future<void> clear() async {
    await sharedPreferences.remove(_kAccessToken);
    await sharedPreferences.remove(_kRefreshToken);
    await sharedPreferences.remove(_kMember);
  }
}
