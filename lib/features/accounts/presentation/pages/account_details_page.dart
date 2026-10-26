import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/payment_method_selector.dart';

typedef _DepositAccount = ({
  String name,
  String type,
  String number,
  String balance,
  String available,
  String rate,
});

const _depositAccounts = <String, _DepositAccount>{
  'checking-4829': (
    name: 'Everyday Checking',
    type: 'Checking account',
    number: '•••• 4829',
    balance: '৳35,210.00',
    available: '৳35,210.00',
    rate: '0.10%',
  ),
  'savings-9102': (
    name: 'High-yield Savings',
    type: 'Savings account',
    number: '•••• 9102',
    balance: '৳10,020.50',
    available: '৳10,020.50',
    rate: '3.85%',
  ),
};

class DepositAccountDetailsPage extends StatelessWidget {
  const DepositAccountDetailsPage({super.key, required this.accountId});

  final String accountId;

  @override
  Widget build(BuildContext context) {
    final account = _depositAccounts[accountId];
    if (account == null) return const _NotFoundPage(title: 'Account not found');

    return Scaffold(
      appBar: AppBar(title: const Text('Account details')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          _BalanceCard(
            eyebrow: account.type.toUpperCase(),
            title: account.name,
            balance: account.balance,
            number: account.number,
          ),
          const SizedBox(height: 22),
          _InfoCard(
            title: 'Account information',
            rows: [
              ('Available balance', account.available),
              ('Account number', account.number),
              ('Account type', account.type),
              ('Interest rate', '${account.rate} APY'),
              ('Status', 'Active'),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            'Manage account',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          _ActionTile(
            icon: Icons.add_card_outlined,
            title: 'Deposit to this account',
            subtitle: 'Add funds with bKash or another payment method',
            onTap: () => context.push('/deposit/$accountId'),
          ),
          _ActionTile(
            icon: Icons.description_outlined,
            title: 'Deposit statements',
            subtitle: 'View monthly account statements',
            onTap: () => context.push('/deposit-statements/$accountId'),
          ),
          _ActionTile(
            icon: Icons.swap_horiz_rounded,
            title: 'Transfer from this account',
            subtitle: 'Move money between your accounts',
            onTap: () => context.push('/internal-transfer'),
          ),
        ],
      ),
    );
  }
}

class DepositAccountPaymentPage extends StatefulWidget {
  const DepositAccountPaymentPage({super.key, required this.accountId});

  final String accountId;

  @override
  State<DepositAccountPaymentPage> createState() =>
      _DepositAccountPaymentPageState();
}

class _DepositAccountPaymentPageState extends State<DepositAccountPaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  PaymentMethod _paymentMethod = PaymentMethod.bkash;
  String? _sourceAccountId;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final account = _depositAccounts[widget.accountId];
    if (account == null) return const _NotFoundPage(title: 'Account not found');
    final sourceAccounts = _depositAccounts.entries
        .where((entry) => entry.key != widget.accountId)
        .toList();
    final sourceAccountId = _sourceAccountId ?? sourceAccounts.first.key;
    final sourceAccount = _depositAccounts[sourceAccountId]!;

    return Scaffold(
      appBar: AppBar(title: const Text('Deposit to account')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            _AccountBanner(
              name: account.name,
              detail: '${account.type} · ${account.number}',
            ),
            const SizedBox(height: 22),
            const Text(
              'Deposit amount',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                prefixText: '৳ ',
                hintText: '0.00',
              ),
              validator: (value) {
                final amount = double.tryParse(value?.trim() ?? '');
                if (amount == null || amount <= 0) {
                  return 'Enter a deposit amount greater than zero';
                }
                if (amount > 500000) {
                  return 'Demo deposits are limited to ৳500,000';
                }
                if (_paymentMethod == PaymentMethod.depositAccount &&
                    amount >
                        double.parse(
                          sourceAccount.available.replaceAll(
                            RegExp(r'[^\d.]'),
                            '',
                          ),
                        )) {
                  return 'Amount exceeds ${sourceAccount.name} balance';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            PaymentMethodSelector(
              selected: _paymentMethod,
              onChanged: (method) => setState(() => _paymentMethod = method),
            ),
            if (_paymentMethod == PaymentMethod.depositAccount) ...[
              const SizedBox(height: 10),
              const Text(
                'Transfer from account',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: sourceAccountId,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.account_balance_wallet_outlined),
                ),
                items: sourceAccounts
                    .map(
                      (entry) => DropdownMenuItem(
                        value: entry.key,
                        child: Text(
                          '${entry.value.name} · ${entry.value.number}',
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _sourceAccountId = value);
                  }
                },
              ),
            ],
            const SizedBox(height: 12),
            const PaymentDemoNotice(
              message:
                  'Payment provider checkout will connect to your CCUSS API later. This demo does not collect payment or add funds.',
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _reviewDeposit(account),
              child: const Text('Review deposit'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _reviewDeposit(_DepositAccount account) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final amount = double.parse(_amountController.text.trim());
    final sourceAccount = _depositAccounts[_sourceAccountId ?? ''];
    final isAccountTransfer = _paymentMethod == PaymentMethod.depositAccount;
    final paymentDescription = isAccountTransfer
        ? 'From: ${sourceAccount!.name} · ${sourceAccount.number}'
        : 'Payment method: ${_paymentMethod.label}';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Review deposit'),
        content: Text(
          'To: ${account.name} · ${account.number}\nAmount: ৳${amount.toStringAsFixed(2)}\n$paymentDescription\n\nDemo only — no funds will be moved.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Edit'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              isAccountTransfer
                  ? 'Confirm demo transfer'
                  : 'Continue to demo checkout',
            ),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const CircleAvatar(
          backgroundColor: Color(0xFFE4F4EE),
          child: Icon(Icons.check_rounded, color: Color(0xFF24845A)),
        ),
        title: Text(
          isAccountTransfer ? 'Demo transfer ready' : 'Demo checkout ready',
        ),
        content: Text(
          isAccountTransfer
              ? 'A demo transfer of ৳${amount.toStringAsFixed(2)} from ${sourceAccount!.name} to ${account.name} would be made. No balances will change.'
              : 'A ${_paymentMethod.label} checkout for ৳${amount.toStringAsFixed(2)} would open here. CCUSS payment integration is not connected yet.',
          textAlign: TextAlign.center,
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              if (mounted) context.pop();
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}

class DepositStatementsPage extends StatelessWidget {
  const DepositStatementsPage({super.key, required this.accountId});

  final String accountId;

  static const _months = [
    ('October 2026', 'Oct 1 – Oct 31, 2026', '2.4 MB'),
    ('September 2026', 'Sep 1 – Sep 30, 2026', '2.1 MB'),
    ('August 2026', 'Aug 1 – Aug 31, 2026', '2.2 MB'),
    ('July 2026', 'Jul 1 – Jul 31, 2026', '1.9 MB'),
    ('June 2026', 'Jun 1 – Jun 30, 2026', '2.0 MB'),
  ];

  @override
  Widget build(BuildContext context) {
    final account = _depositAccounts[accountId];
    if (account == null) return const _NotFoundPage(title: 'Account not found');

    return Scaffold(
      appBar: AppBar(title: const Text('Deposit statements')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          _AccountBanner(
            name: account.name,
            detail: '${account.type} · ${account.number}',
          ),
          const SizedBox(height: 22),
          const Text(
            'Monthly statements',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          ..._months.map(
            (month) => _StatementTile(
              month: month.$1,
              period: month.$2,
              size: month.$3,
              type: 'deposit',
            ),
          ),
        ],
      ),
    );
  }
}

class LoanDetailsPage extends StatelessWidget {
  const LoanDetailsPage({super.key, required this.loanId});

  final String loanId;

  @override
  Widget build(BuildContext context) {
    final loan = _loanForId(loanId);
    if (loan == null) return const _NotFoundPage(title: 'Loan not found');

    return Scaffold(
      appBar: AppBar(title: const Text('Loan details')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          _BalanceCard(
            eyebrow: loan.type.toUpperCase(),
            title: loan.name,
            balance: loan.remaining,
            number: loan.number,
          ),
          const SizedBox(height: 22),
          _InfoCard(
            title: 'Loan information',
            rows: [
              ('Original amount', loan.original),
              ('Remaining balance', loan.remaining),
              ('Interest rate', '${loan.rate} p.a.'),
              ('Monthly payment', loan.payment),
              ('Next payment date', 'November 15, 2026'),
              ('Status', 'Active'),
            ],
          ),
          const SizedBox(height: 18),
          ElevatedButton.icon(
            onPressed: () => context.push('/loan-payment/$loanId'),
            icon: const Icon(Icons.payments_outlined),
            label: const Text('Make a loan payment'),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () => context.push('/loan-statements/$loanId'),
            icon: const Icon(Icons.description_outlined),
            label: const Text('View loan statements'),
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
    );
  }
}

class LoanStatementsPage extends StatelessWidget {
  const LoanStatementsPage({super.key, required this.loanId});

  final String loanId;

  static const _months = [
    ('October 2026', 'Oct 1 – Oct 31, 2026', '1.4 MB'),
    ('September 2026', 'Sep 1 – Sep 30, 2026', '1.3 MB'),
    ('August 2026', 'Aug 1 – Aug 31, 2026', '1.3 MB'),
    ('July 2026', 'Jul 1 – Jul 31, 2026', '1.2 MB'),
    ('June 2026', 'Jun 1 – Jun 30, 2026', '1.2 MB'),
  ];

  @override
  Widget build(BuildContext context) {
    final loan = _loanForId(loanId);
    if (loan == null) return const _NotFoundPage(title: 'Loan not found');

    return Scaffold(
      appBar: AppBar(title: const Text('Loan statements')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          _AccountBanner(
            name: loan.name,
            detail: '${loan.type} · ${loan.number}',
          ),
          const SizedBox(height: 22),
          const Text(
            'Monthly statements',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          ..._months.map(
            (month) => _StatementTile(
              month: month.$1,
              period: month.$2,
              size: month.$3,
              type: 'loan',
            ),
          ),
        ],
      ),
    );
  }
}

typedef _LoanData = ({
  String name,
  String type,
  String number,
  String original,
  String remaining,
  String rate,
  String payment,
});

_LoanData? _loanForId(String loanId) {
  return switch (loanId) {
    'home-2048' => (
      name: 'Home loan',
      type: 'Mortgage',
      number: '•••• 2048',
      original: '৳250,000.00',
      remaining: '৳185,400.00',
      rate: '3.90%',
      payment: '৳1,420.00',
    ),
    'auto-7721' => (
      name: 'Auto loan',
      type: 'Vehicle loan',
      number: '•••• 7721',
      original: '৳35,000.00',
      remaining: '৳12,200.00',
      rate: '4.60%',
      payment: '৳430.00',
    ),
    _ => null,
  };
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({
    required this.eyebrow,
    required this.title,
    required this.balance,
    required this.number,
  });

  final String eyebrow;
  final String title;
  final String balance;
  final String number;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF242269), Color(0xFF514FA8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            eyebrow,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            balance,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Text(number, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.rows});

  final String title;
  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFEDEEF3)),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          ...rows.map(
            (row) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 11),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      row.$1,
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      row.$2,
                      textAlign: TextAlign.end,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountBanner extends StatelessWidget {
  const _AccountBanner({required this.name, required this.detail});

  final String name;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE9E8F7),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(
              Icons.account_balance_outlined,
              color: Color(0xFF242269),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 3),
                Text(
                  detail,
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatementTile extends StatelessWidget {
  const _StatementTile({
    required this.month,
    required this.period,
    required this.size,
    required this.type,
  });

  final String month;
  final String period;
  final String size;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFEDEEF3)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFFE9E8F7),
            child: Icon(
              Icons.picture_as_pdf_outlined,
              color: Color(0xFF242269),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  month,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 3),
                Text(
                  '$period · PDF · $size',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Preview $type statement',
            onPressed: () => showDialog<void>(
              context: context,
              builder: (dialogContext) => AlertDialog(
                icon: const Icon(
                  Icons.description_outlined,
                  color: Color(0xFF242269),
                ),
                title: Text('$month $type statement'),
                content: const Text(
                  'This demo statement is ready to preview. No file is downloaded.',
                  textAlign: TextAlign.center,
                ),
                actions: [
                  FilledButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
            icon: const Icon(
              Icons.visibility_outlined,
              color: Color(0xFF242269),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
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
}

class _NotFoundPage extends StatelessWidget {
  const _NotFoundPage({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title)),
    );
  }
}
