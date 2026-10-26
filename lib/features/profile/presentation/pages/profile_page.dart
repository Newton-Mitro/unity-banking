import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/banking_bottom_nav.dart';
import '../../../authentication/presentation/bloc/auth_bloc.dart';
import '../../../authentication/presentation/bloc/auth_event.dart';
import '../../../authentication/presentation/bloc/auth_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) context.go('/login');
        if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF242269), Color(0xFF514FA8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Text(
                      'N',
                      style: TextStyle(
                        color: Color(0xFF242269),
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Newton',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Member · UB-9847291',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.verified_user_outlined, color: Colors.white70),
                ],
              ),
            ),
            const SizedBox(height: 26),
            _heading(context, 'Personal information'),
            const SizedBox(height: 10),
            _settingTile(
              context,
              icon: Icons.person_outline_rounded,
              title: 'Personal details',
              subtitle: 'Name, email and phone',
              onTap: () => _showDetails(context, 'Personal details'),
            ),
            _settingTile(
              context,
              icon: Icons.credit_card_outlined,
              title: 'Cards & accounts',
              subtitle: 'Manage your linked accounts',
              onTap: () => context.push('/accounts'),
            ),
            _settingTile(
              context,
              icon: Icons.people_outline_rounded,
              title: 'Beneficiaries',
              subtitle: 'Manage saved transfer recipients',
              onTap: () => context.push('/beneficiaries'),
            ),
            const SizedBox(height: 22),
            _heading(context, 'Preferences'),
            const SizedBox(height: 10),
            _settingTile(
              context,
              icon: Icons.security_outlined,
              title: 'Security',
              subtitle: 'Password and biometric sign-in',
              onTap: () => _showDetails(context, 'Security'),
            ),
            _settingTile(
              context,
              icon: Icons.notifications_none_rounded,
              title: 'Notifications',
              subtitle: 'Your alerts and activity',
              onTap: () => context.push('/notifications'),
            ),
            _settingTile(
              context,
              icon: Icons.language_rounded,
              title: 'Language',
              subtitle: 'English (US)',
              onTap: () => _showDetails(context, 'Language'),
            ),
            _settingTile(
              context,
              icon: Icons.help_outline_rounded,
              title: 'Help & support',
              subtitle: 'FAQs and contact information',
              onTap: () => _showDetails(context, 'Help & support'),
            ),
            const SizedBox(height: 18),
            OutlinedButton.icon(
              onPressed: () => context.read<AuthBloc>().add(LogoutRequested()),
              icon: const Icon(Icons.logout_rounded),
              label: const Text('Log out'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFB93838),
                side: const BorderSide(color: Color(0xFFE7BABA)),
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 14),
            const Center(
              child: Text(
                'Unity Banking · Demo experience',
                style: TextStyle(color: Colors.black45, fontSize: 12),
              ),
            ),
          ],
        ),
        bottomNavigationBar: const BankingBottomNav(currentIndex: 3),
      ),
    );
  }

  Widget _heading(BuildContext context, String title) => Text(
    title,
    style: Theme.of(
      context,
    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
  );

  Widget _settingTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFEDEEF3)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: const Color(0xFF242269)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }

  Future<void> _showDetails(BuildContext context, String title) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: const Text(
          'This setting is part of the Unity Banking demo. No account details will be changed.',
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
