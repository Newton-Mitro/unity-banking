class Beneficiary {
  const Beneficiary({
    required this.id,
    required this.name,
    required this.institution,
    required this.accountNumber,
    this.nickname = '',
  });

  final String id;
  final String name;
  final String institution;
  final String accountNumber;
  final String nickname;

  String get displayName => nickname.isEmpty ? name : nickname;

  String get maskedAccount {
    final visibleDigits = accountNumber.length <= 4
        ? accountNumber
        : accountNumber.substring(accountNumber.length - 4);
    return '•••• $visibleDigits';
  }
}
