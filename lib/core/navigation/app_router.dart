import 'package:go_router/go_router.dart';
import '../../features/authentication/presentation/pages/login_page.dart';
import '../../features/authentication/presentation/pages/otp_verification_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/accounts/presentation/pages/accounts_page.dart';
import '../../features/transfers/presentation/pages/transfers_page.dart';
import '../../features/loans/presentation/pages/loans_page.dart';
import '../../features/transfers/presentation/pages/bill_payments_page.dart';
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
      path: '/transfers',
      builder: (context, state) => const TransfersPage(),
    ),
    GoRoute(
      path: '/bill-payments',
      builder: (context, state) => const BillPaymentsPage(),
    ),
    GoRoute(path: '/loans', builder: (context, state) => const LoansPage()),
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
