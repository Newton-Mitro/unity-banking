import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/banking_bottom_nav.dart';

class TransfersPage extends StatefulWidget {
  const TransfersPage({super.key});

  @override
  State<TransfersPage> createState() => _TransfersPageState();
}

class _TransfersPageState extends State<TransfersPage> {
  final _formKey = GlobalKey<FormState>();
  final _recipientController = TextEditingController();
  final _accountController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  String _fromAccount = 'Everyday Checking · •••• 4829';

  @override
  void dispose() {
    _recipientController.dispose();
    _accountController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transfer money')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          children: [
            _stepHeader(),
            const SizedBox(height: 20),
            _label('From account'),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _fromAccount,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.account_balance_wallet_outlined),
              ),
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
                if (value != null) setState(() => _fromAccount = value);
              },
            ),
            const SizedBox(height: 18),
            _label('Recipient'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _recipientController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                hintText: 'Full name',
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Enter the recipient name'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _accountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Account number',
                prefixIcon: Icon(Icons.numbers_rounded),
              ),
              validator: (value) => value == null || value.trim().length < 6
                  ? 'Enter an account number (at least 6 digits)'
                  : null,
            ),
            const SizedBox(height: 18),
            _label('Amount'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                prefixText: '\$ ',
                hintText: '0.00',
              ),
              validator: (value) {
                final amount = double.tryParse(value?.trim() ?? '');
                if (amount == null || amount <= 0) {
                  return 'Enter an amount greater than zero';
                }
                final availableBalance = _fromAccount.startsWith('Everyday')
                    ? 35210.0
                    : 10020.50;
                if (amount > availableBalance) {
                  return 'Amount exceeds your available balance';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),
            TextFormField(
              controller: _noteController,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Note (optional)',
                hintText: 'What is this transfer for?',
                prefixIcon: Icon(Icons.edit_note_rounded),
              ),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFE9E8F7),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline_rounded, color: Color(0xFF242269)),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'This is a demo transfer. No real money will be moved.',
                      style: TextStyle(color: Color(0xFF35336F)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            ElevatedButton(
              onPressed: _reviewTransfer,
              child: const Text('Review transfer'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BankingBottomNav(currentIndex: 2),
    );
  }

  Widget _stepHeader() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFEDEEF3)),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            backgroundColor: Color(0xFFE9E8F7),
            child: Icon(Icons.swap_horiz_rounded, color: Color(0xFF242269)),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Send money',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 3),
                Text(
                  'Fill in the details, then review before sending.',
                  style: TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) => Text(
    text,
    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
  );

  Future<void> _reviewTransfer() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final amount = double.parse(_amountController.text.trim());
    final shouldSend = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Review transfer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _reviewRow('To', _recipientController.text.trim()),
            _reviewRow('Account', _accountController.text.trim()),
            _reviewRow('From', _fromAccount),
            _reviewRow('Amount', '\$${amount.toStringAsFixed(2)}'),
            if (_noteController.text.trim().isNotEmpty)
              _reviewRow('Note', _noteController.text.trim()),
            const SizedBox(height: 12),
            const Text(
              'Demo only — this will not move real money.',
              style: TextStyle(color: Colors.black54, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Edit'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Send demo transfer'),
          ),
        ],
      ),
    );

    if (!mounted || shouldSend != true) return;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const CircleAvatar(
          backgroundColor: Color(0xFFE4F4EE),
          child: Icon(Icons.check_rounded, color: Color(0xFF24845A)),
        ),
        title: const Text('Transfer complete'),
        content: Text(
          '\$${amount.toStringAsFixed(2)} was sent to ${_recipientController.text.trim()} in this demo.',
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

  Widget _reviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Text(label, style: const TextStyle(color: Colors.black54)),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
