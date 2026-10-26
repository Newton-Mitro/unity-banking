class ApiEndpoints {
  static const String baseUrl = 'https://webapi.cccul.com/api';

  // Auth
  static const String login = '/auth/login';
  static const String verifyOtp = '/auth/verify-otp';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String me = '/auth/me';

  // Accounts
  static const String accounts = '/accounts';
  static String accountDetails(int accountId) => '/accounts/$accountId';
  static String accountBalance(int accountId) => '/accounts/$accountId/balance';
  static String accountTransactions(int accountId) =>
      '/accounts/$accountId/transactions';

  // Transactions
  static String transactionDetails(int transactionId) =>
      '/transactions/$transactionId';

  // Beneficiaries
  static const String beneficiaries = '/beneficiaries';
  static const String verifyBeneficiary = '/beneficiaries/verify';
  static String deleteBeneficiary(int beneficiaryId) =>
      '/beneficiaries/$beneficiaryId';

  // Transfers
  static const String validateTransfer = '/transfers/validate';
  static const String createTransfer = '/transfers';

  // Loans
  static const String loans = '/loans';
  static String loanDetails(int loanId) => '/loans/$loanId';
  static String loanSchedule(int loanId) => '/loans/$loanId/schedule';
  static String validateLoanPayment(int loanId) =>
      '/loans/$loanId/payments/validate';
  static String makeLoanPayment(int loanId) => '/loans/$loanId/payments';

  // Deposits
  static const String deposits = '/deposits';
  static String depositDetails(int depositId) => '/deposits/$depositId';

  // Bill Payments
  static const String billers = '/billers';
  static const String validateBillPayment = '/bill-payments/validate';
  static const String executeBillPayment = '/bill-payments';

  // Statements
  static const String generateStatement = '/statements/generate';

  // Notifications
  static const String notifications = '/notifications';
  static String markNotificationRead(int notificationId) =>
      '/notifications/$notificationId/read';

  // Profile
  static const String profile = '/profile';
}
