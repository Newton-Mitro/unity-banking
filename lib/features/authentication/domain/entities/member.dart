import 'package:equatable/equatable.dart';

class Member extends Equatable {
  final String id;
  final String memberNumber;
  final String name;
  final String mobile;
  final String email;
  final String status;

  const Member({
    required this.id,
    required this.memberNumber,
    required this.name,
    required this.mobile,
    required this.email,
    required this.status,
  });

  @override
  List<Object?> get props => [id, memberNumber, name, mobile, email, status];
}
