import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BankingBottomNav extends StatelessWidget {
  const BankingBottomNav({super.key, required this.currentIndex});

  final int currentIndex;

  static const _routes = ['/dashboard', '/accounts', '/transfers', '/profile'];

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: (index) => context.go(_routes[index]),
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
        NavigationDestination(
          icon: Icon(Icons.account_balance_wallet_outlined),
          label: 'Accounts',
        ),
        NavigationDestination(
          icon: Icon(Icons.swap_horiz_rounded),
          label: 'Transfer',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline_rounded),
          label: 'Profile',
        ),
      ],
    );
  }
}
