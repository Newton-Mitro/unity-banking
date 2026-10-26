import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BillPaymentsPage extends StatefulWidget {
  const BillPaymentsPage({super.key});

  @override
  State<BillPaymentsPage> createState() => _BillPaymentsPageState();
}

class _BillPaymentsPageState extends State<BillPaymentsPage> {
  final _formKey = GlobalKey<FormState>();
  final _referenceController = TextEditingController();
  final _amountController = TextEditingController();
  String _biller = 'Electricity';
  String _account = 'Everyday Checking · •••• 4829';

  static const _billers = {
    'Electricity': (icon: Icons.bolt_rounded, company: 'City Power'),
    'Water': (icon: Icons.water_drop_outlined, company: 'City Water'),
    'Internet': (icon: Icons.wifi_rounded, company: 'FastNet'),
    'Mobile': (icon: Icons.phone_iphone_rounded, company: 'Unity Mobile'),
  };

  @override
  void dispose() {
    _referenceController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final biller = _billers[_biller]!;
    return Scaffold(
      appBar: AppBar(title: const Text('Pay a bill')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0DF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(biller.icon, color: const Color(0xFFAA6816)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          biller.company,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          'Pay securely from your account',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'Choose a biller',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _biller,
              items: _billers.keys
                  .map(
                    (item) => DropdownMenuItem(value: item, child: Text(item)),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _biller = value);
              },
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.receipt_long_outlined),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Customer reference',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _referenceController,
              decoration: const InputDecoration(
                hintText: 'Account or customer number',
                prefixIcon: Icon(Icons.tag_rounded),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Enter your customer reference'
                  : null,
            ),
            const SizedBox(height: 18),
            const Text(
              'Pay from',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _account,
              items: const [
                DropdownMenuItem(
                  value: 'Everyday Checking · •••• 4829',
                  child: Text('Everyday Checking · •••• 4829'),
                ),
                DropdownMenuItem(
                  value: 'High-yield Savings · •••• 9102',
                  child: Text('High-yield Savings · •••• 9102'),
                ),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _account = value);
              },
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.account_balance_wallet_outlined),
              ),
            ),
            const SizedBox(height: 18),
            const Text('Amount', style: TextStyle(fontWeight: FontWeight.w700)),
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
                  return 'Enter an amount greater than zero';
                }
                final availableBalance = _account.startsWith('Everyday')
                    ? 35210.0
                    : 10020.50;
                if (amount > availableBalance) {
                  return 'Amount exceeds the selected account balance';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),
            const Text(
              'This demo bill payment will not charge your account.',
              style: TextStyle(color: Colors.black54, fontSize: 12),
            ),
            const SizedBox(height: 22),
            ElevatedButton(
              onPressed: _reviewPayment,
              child: const Text('Review payment'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _reviewPayment() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final amount = double.parse(_amountController.text.trim());
    final details = _billers[_biller]!;
    final shouldPay = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm bill payment'),
        content: Text(
          '${details.company}\nReference: ${_referenceController.text.trim()}\nFrom: $_account\nAmount: ৳${amount.toStringAsFixed(2)}\n\nDemo only — no payment will be made.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Edit'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Pay demo bill'),
          ),
        ],
      ),
    );
    if (!mounted || shouldPay != true) return;

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const CircleAvatar(
          backgroundColor: Color(0xFFE4F4EE),
          child: Icon(Icons.check_rounded, color: Color(0xFF24845A)),
        ),
        title: const Text('Payment complete'),
        content: Text(
          '৳${amount.toStringAsFixed(2)} was paid to ${details.company} in this demo.',
          textAlign: TextAlign.center,
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              if (mounted) this.context.go('/dashboard');
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}
