import '../../domain/entities/member.dart';

class MemberModel extends Member {
  const MemberModel({
    required super.id,
    required super.memberNumber,
    required super.name,
    required super.mobile,
    required super.email,
    required super.status,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      id: json['id'] ?? '',
      memberNumber: json['memberNumber'] ?? '',
      name: json['name'] ?? '',
      mobile: json['mobile'] ?? '',
      email: json['email'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'memberNumber': memberNumber,
      'name': name,
      'mobile': mobile,
      'email': email,
      'status': status,
    };
  }
}
