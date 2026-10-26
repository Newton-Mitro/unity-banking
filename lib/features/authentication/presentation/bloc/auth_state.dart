import 'package:equatable/equatable.dart';
import '../../domain/entities/member.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class OtpSent extends AuthState {
  final String verificationId;

  const OtpSent({required this.verificationId});

  @override
  List<Object?> get props => [verificationId];
}

class Authenticated extends AuthState {
  final Member member;

  const Authenticated({required this.member});

  @override
  List<Object?> get props => [member];
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}
