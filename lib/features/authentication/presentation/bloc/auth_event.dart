import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AppStarted extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String mobile;
  final String password;

  const LoginRequested({required this.mobile, required this.password});

  @override
  List<Object?> get props => [mobile, password];
}

class OtpVerificationRequested extends AuthEvent {
  final String verificationId;
  final String otp;

  const OtpVerificationRequested({
    required this.verificationId,
    required this.otp,
  });

  @override
  List<Object?> get props => [verificationId, otp];
}

class LogoutRequested extends AuthEvent {}
