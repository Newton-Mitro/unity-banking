import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/banking_bottom_nav.dart';

typedef _BankAccount = ({
  String title,
  String number,
  String balance,
  IconData icon,
  String type,
});

class AccountsPage extends StatelessWidget {
  const AccountsPage({super.key});

  static const _accounts = [
    (
      title: 'Everyday Checking',
      number: '•••• 4829',
      balance: '\$35,210.00',
      icon: Icons.account_balance_wallet_outlined,
      type: 'Checking account',
    ),
    (
      title: 'High-yield Savings',
      number: '•••• 9102',
      balance: '\$10,020.50',
      icon: Icons.savings_outlined,
      type: 'Savings account',
    ),
    (
      title: 'Investment Portfolio',
      number: '•••• 3847',
      balance: '\$7,200.00',
      icon: Icons.show_chart_rounded,
      type: 'Investment account',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My accounts')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF242269), Color(0xFF514FA8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'TOTAL ASSETS',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '\$52,430.50',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 18),
                const Divider(color: Colors.white24),
                const SizedBox(height: 8),
                const Row(
                  children: [
                    Expanded(
                      child: _BalanceDetail(label: 'Accounts', value: '3'),
                    ),
                    Expanded(
                      child: _BalanceDetail(
                        label: 'Available credit',
                        value: '\$5,000',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          Text(
            'Your accounts',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          ..._accounts.map((account) => _accountCard(context, account)),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => _showDemoMessage(context),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Open a new account'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              foregroundColor: const Color(0xFF242269),
              side: const BorderSide(color: Color(0xFF242269)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BankingBottomNav(currentIndex: 1),
    );
  }

  Widget _accountCard(BuildContext context, _BankAccount account) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => _showAccountDetails(context, account),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFEDEEF3)),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9E8F7),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(account.icon, color: const Color(0xFF242269)),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        account.title,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${account.type}  ·  ${account.number}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  account.balance,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showAccountDetails(
    BuildContext context,
    _BankAccount account,
  ) async {
    final pageContext = context;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                account.title,
                style: Theme.of(
                  sheetContext,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text('${account.type} · ${account.number}'),
              const SizedBox(height: 18),
              Text(
                account.balance,
                style: Theme.of(sheetContext).textTheme.headlineSmall?.copyWith(
                  color: const Color(0xFF242269),
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(sheetContext);
                        pageContext.push('/statements');
                      },
                      child: const Text('Statements'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(sheetContext);
                        pageContext.push('/transfers');
                      },
                      child: const Text('Transfer'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDemoMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('New account opening is a demo feature.')),
    );
  }
}

class _BalanceDetail extends StatelessWidget {
  const _BalanceDetail({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
