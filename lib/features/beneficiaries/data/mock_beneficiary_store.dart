import '../domain/entities/beneficiary.dart';

class MockBeneficiaryStore {
  MockBeneficiaryStore._();

  static final List<Beneficiary> beneficiaries = [
    const Beneficiary(
      id: 'beneficiary-jamie',
      name: 'Jamie Lee',
      institution: 'Unity Cooperative',
      accountNumber: '1234567890',
      nickname: 'Jamie',
    ),
    const Beneficiary(
      id: 'beneficiary-river',
      name: 'River Tan',
      institution: 'Community First Credit Union',
      accountNumber: '9876543210',
    ),
  ];

  static void add(Beneficiary beneficiary) {
    beneficiaries.add(beneficiary);
  }

  static void remove(String id) {
    beneficiaries.removeWhere((beneficiary) => beneficiary.id == id);
  }
}
