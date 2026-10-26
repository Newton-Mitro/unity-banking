import 'package:go_router/go_router.dart';
import '../../features/authentication/presentation/pages/login_page.dart';
import '../../features/authentication/presentation/pages/otp_verification_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/accounts/presentation/pages/accounts_page.dart';
import '../../features/accounts/presentation/pages/account_details_page.dart';
import '../../features/loans/presentation/pages/loans_page.dart';
import '../../features/transfers/presentation/pages/bill_payments_page.dart';
import '../../features/transfers/presentation/pages/money_movement_pages.dart';
import '../../features/beneficiaries/presentation/pages/beneficiaries_page.dart';
import '../../features/statements/presentation/pages/statements_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(
      path: '/otp-verify',
      builder: (context, state) {
        final verificationId = state.extra as String? ?? '';
        return OtpVerificationPage(verificationId: verificationId);
      },
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardPage(),
    ),
    GoRoute(
      path: '/accounts',
      builder: (context, state) => const AccountsPage(),
    ),
    GoRoute(
      path: '/deposit-accounts',
      redirect: (context, state) => '/accounts',
    ),
    GoRoute(
      path: '/deposit-accounts/:accountId',
      builder: (context, state) => DepositAccountDetailsPage(
        accountId: state.pathParameters['accountId']!,
      ),
    ),
    GoRoute(
      path: '/deposit/:accountId',
      builder: (context, state) => DepositAccountPaymentPage(
        accountId: state.pathParameters['accountId']!,
      ),
    ),
    GoRoute(
      path: '/deposit-statements/:accountId',
      builder: (context, state) =>
          DepositStatementsPage(accountId: state.pathParameters['accountId']!),
    ),
    GoRoute(
      path: '/transfers',
      builder: (context, state) => const TransferHubPage(),
    ),
    GoRoute(
      path: '/beneficiaries',
      builder: (context, state) => BeneficiariesPage(
        selectMode: state.uri.queryParameters['select'] == 'true',
      ),
    ),
    GoRoute(
      path: '/beneficiaries/new',
      builder: (context, state) => const AddBeneficiaryPage(),
    ),
    GoRoute(
      path: '/internal-transfer',
      builder: (context, state) =>
          const MovementFormPage(type: MovementType.internal),
    ),
    GoRoute(
      path: '/credit-union-transfer',
      builder: (context, state) =>
          const MovementFormPage(type: MovementType.creditUnion),
    ),
    GoRoute(
      path: '/agent-withdrawal',
      builder: (context, state) =>
          const MovementFormPage(type: MovementType.agentWithdrawal),
    ),
    GoRoute(
      path: '/bill-payments',
      builder: (context, state) => const BillPaymentsPage(),
    ),
    GoRoute(path: '/loans', builder: (context, state) => const LoansPage()),
    GoRoute(
      path: '/loans/:loanId',
      builder: (context, state) =>
          LoanDetailsPage(loanId: state.pathParameters['loanId']!),
    ),
    GoRoute(
      path: '/loan-statements/:loanId',
      builder: (context, state) =>
          LoanStatementsPage(loanId: state.pathParameters['loanId']!),
    ),
    GoRoute(
      path: '/loan-payment/:loanId',
      builder: (context, state) =>
          LoanPaymentPage(loanId: state.pathParameters['loanId']!),
    ),
    GoRoute(
      path: '/statements',
      builder: (context, state) => const StatementsPage(),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsPage(),
    ),
    GoRoute(path: '/profile', builder: (context, state) => const ProfilePage()),
  ],
);
