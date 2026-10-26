import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/banking_bottom_nav.dart';

typedef _Transaction = ({
  String title,
  String subtitle,
  String amount,
  IconData icon,
  bool income,
});

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  static const _transactions = [
    (
      title: 'Grocery Market',
      subtitle: 'Shopping · Today, 10:42 AM',
      amount: '-\$84.26',
      icon: Icons.shopping_basket_outlined,
      income: false,
    ),
    (
      title: 'Monthly salary',
      subtitle: 'Income · Yesterday',
      amount: '+\$4,500.00',
      icon: Icons.account_balance_outlined,
      income: true,
    ),
    (
      title: 'Blue Bottle Coffee',
      subtitle: 'Food & drink · Oct 24',
      amount: '-\$12.50',
      icon: Icons.local_cafe_outlined,
      income: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
              sliver: SliverToBoxAdapter(child: _header(context)),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(child: _balanceCard(context)),
            ),
            SliverToBoxAdapter(child: _sectionTitle(context, 'Quick actions')),
            SliverToBoxAdapter(child: _quickActions(context)),
            SliverToBoxAdapter(
              child: _sectionTitle(
                context,
                'Recent activity',
                action: 'See all',
                onAction: () => context.push('/statements'),
              ),
            ),
            SliverList.builder(
              itemCount: _transactions.length,
              itemBuilder: (context, index) =>
                  _transactionTile(context, _transactions[index]),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
      bottomNavigationBar: const BankingBottomNav(currentIndex: 0),
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: const Color(0xFFE9E8F7),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.account_balance_rounded,
            color: Color(0xFF242269),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good morning,',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
              ),
              Text(
                'Newton',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
        IconButton.filledTonal(
          tooltip: 'Notifications',
          onPressed: () => context.push('/notifications'),
          icon: const Icon(Icons.notifications_none_rounded),
        ),
      ],
    );
  }

  Widget _balanceCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF242269), Color(0xFF514FA8)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x25242269),
            blurRadius: 22,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'TOTAL BALANCE',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
              Icon(
                Icons.more_horiz_rounded,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '\$45,230.50',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(
                Icons.trending_up_rounded,
                color: Color(0xFF9CF0C4),
                size: 17,
              ),
              const SizedBox(width: 5),
              const Text(
                '+\$2,840.20',
                style: TextStyle(
                  color: Color(0xFF9CF0C4),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'this month',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const Spacer(),
              const Text(
                '•••• 4829',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(
    BuildContext context,
    String title, {
    String? action,
    VoidCallback? onAction,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 26, 20, 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          if (action != null)
            TextButton(onPressed: onAction, child: Text(action)),
        ],
      ),
    );
  }

  Widget _quickActions(BuildContext context) {
    final actions = [
      (
        label: 'Transfer',
        icon: Icons.swap_horiz_rounded,
        route: '/transfers',
        color: Color(0xFFE9E8F7),
      ),
      (
        label: 'Pay bills',
        icon: Icons.receipt_long_outlined,
        route: '/bill-payments',
        color: Color(0xFFFFF0DF),
      ),
      (
        label: 'Loans',
        icon: Icons.real_estate_agent_outlined,
        route: '/loans',
        color: Color(0xFFE4F4EE),
      ),
      (
        label: 'Statements',
        icon: Icons.description_outlined,
        route: '/statements',
        color: Color(0xFFE7F0FB),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: actions
            .map(
              (action) => Expanded(
                child: InkWell(
                  onTap: () => context.push(action.route),
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      children: [
                        Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            color: action.color,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Icon(
                            action.icon,
                            color: const Color(0xFF242269),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          action.label,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _transactionTile(BuildContext context, _Transaction transaction) {
    final isIncome = transaction.income;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFEDEEF3)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 23,
              backgroundColor: isIncome
                  ? const Color(0xFFE4F4EE)
                  : const Color(0xFFF0F0F6),
              child: Icon(
                transaction.icon,
                color: isIncome
                    ? const Color(0xFF24845A)
                    : const Color(0xFF242269),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.title,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    transaction.subtitle,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),
            ),
            Text(
              transaction.amount,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: isIncome
                    ? const Color(0xFF24845A)
                    : const Color(0xFF171A33),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
