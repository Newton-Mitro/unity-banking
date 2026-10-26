import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/payment_method_selector.dart';
import '../../../beneficiaries/domain/entities/beneficiary.dart';

enum MovementType { internal, creditUnion, agentWithdrawal }

class TransferHubPage extends StatelessWidget {
  const TransferHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Move money')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFE9E8F7),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Row(
              children: [
                Icon(Icons.swap_horiz_rounded, color: Color(0xFF242269)),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Choose how you want to move your money. All actions are demo only.',
                    style: TextStyle(color: Color(0xFF35336F)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Transfers and cash',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
          ),
          const SizedBox(height: 12),
          _MovementTile(
            icon: Icons.compare_arrows_rounded,
            title: 'Internal account transfer',
            subtitle: 'Move money between your Unity accounts',
            onTap: () => context.push('/internal-transfer'),
          ),
          _MovementTile(
            icon: Icons.account_balance_outlined,
            title: 'Inter credit union transfer',
            subtitle: 'Send money to another credit union',
            onTap: () => context.push('/credit-union-transfer'),
          ),
          _MovementTile(
            icon: Icons.people_outline_rounded,
            title: 'Manage beneficiaries',
            subtitle: 'Add, view, or remove saved recipients',
            onTap: () => context.push('/beneficiaries'),
          ),
          _MovementTile(
            icon: Icons.storefront_outlined,
            title: 'Withdraw from agent',
            subtitle: 'Get a one-time cash withdrawal code',
            onTap: () => context.push('/agent-withdrawal'),
          ),
          const SizedBox(height: 24),
          const Text(
            'Other payments',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
          ),
          const SizedBox(height: 12),
          _MovementTile(
            icon: Icons.receipt_long_outlined,
            title: 'Pay a bill',
            subtitle: 'Utilities, internet and more',
            onTap: () => context.push('/bill-payments'),
          ),
          _MovementTile(
            icon: Icons.real_estate_agent_outlined,
            title: 'Make a loan payment',
            subtitle: 'Choose a loan account to make a payment',
            onTap: () => context.push('/loans'),
          ),
        ],
      ),
    );
  }
}

class MovementFormPage extends StatefulWidget {
  const MovementFormPage({super.key, required this.type});

  final MovementType type;

  @override
  State<MovementFormPage> createState() => _MovementFormPageState();
}

class _MovementFormPageState extends State<MovementFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _recipientController = TextEditingController();
  final _accountController = TextEditingController();
  final _institutionController = TextEditingController();
  final _agentController = TextEditingController();
  final _amountController = TextEditingController();
  String _fromAccount = 'Everyday Checking · •••• 4829';
  String? _toAccount;

  bool get _isInternal => widget.type == MovementType.internal;
  bool get _isExternal => widget.type == MovementType.creditUnion;

  String get _title => switch (widget.type) {
    MovementType.internal => 'Internal account transfer',
    MovementType.creditUnion => 'Inter credit union transfer',
    MovementType.agentWithdrawal => 'Withdraw from agent',
  };

  @override
  void dispose() {
    _recipientController.dispose();
    _accountController.dispose();
    _institutionController.dispose();
    _agentController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_title)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          children: [
            _accountSelector(),
            if (_isInternal) ...[
              const SizedBox(height: 18),
              const _FieldLabel('To account'),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _toAccount,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.account_balance_wallet_outlined),
                ),
                items: [
                  if (_fromAccount != 'Everyday Checking · •••• 4829')
                    const DropdownMenuItem(
                      value: 'Everyday Checking · •••• 4829',
                      child: Text('Everyday Checking · •••• 4829'),
                    ),
                  if (_fromAccount != 'High-yield Savings · •••• 9102')
                    const DropdownMenuItem(
                      value: 'High-yield Savings · •••• 9102',
                      child: Text('High-yield Savings · •••• 9102'),
                    ),
                ],
                validator: (value) =>
                    value == null ? 'Choose a destination account' : null,
                onChanged: (value) => setState(() => _toAccount = value),
              ),
            ] else ...[
              if (_isExternal) ...[
                OutlinedButton.icon(
                  onPressed: _chooseBeneficiary,
                  icon: const Icon(Icons.people_outline_rounded),
                  label: const Text('Choose saved beneficiary'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    foregroundColor: const Color(0xFF242269),
                    side: const BorderSide(color: Color(0xFF242269)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
              ],
              const SizedBox(height: 18),
              const _FieldLabel('Recipient name'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _recipientController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  hintText: 'Enter full name',
                  prefixIcon: Icon(Icons.person_outline_rounded),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Enter the recipient name'
                    : null,
              ),
              const SizedBox(height: 16),
              _FieldLabel(
                _isExternal ? 'Receiving credit union' : 'Agent location',
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _institutionController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  hintText: _isExternal
                      ? 'Credit union name'
                      : 'e.g. Unity Main Street',
                  prefixIcon: Icon(
                    _isExternal
                        ? Icons.account_balance_outlined
                        : Icons.location_on_outlined,
                  ),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? _isExternal
                          ? 'Enter the receiving credit union'
                          : 'Enter the agent location'
                    : null,
              ),
              if (_isExternal) ...[
                const SizedBox(height: 16),
                const _FieldLabel('Recipient account number'),
                const SizedBox(height: 8),
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
              ],
              if (!_isExternal) ...[
                const SizedBox(height: 16),
                const _FieldLabel('Agent code (optional)'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _agentController,
                  decoration: const InputDecoration(
                    hintText: 'Enter agent code, if known',
                    prefixIcon: Icon(Icons.tag_rounded),
                  ),
                ),
              ],
            ],
            const SizedBox(height: 18),
            const _FieldLabel('Amount'),
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
                final limit = _fromAccount.startsWith('Everyday')
                    ? 35210.0
                    : 10020.50;
                if (amount > limit) return 'Amount exceeds available balance';
                return null;
              },
            ),
            const SizedBox(height: 20),
            const _DemoNotice(
              message:
                  'Demo only. No real transfer or cash withdrawal will be made.',
            ),
            const SizedBox(height: 22),
            ElevatedButton(
              onPressed: _review,
              child: const Text('Review request'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _chooseBeneficiary() async {
    final beneficiary = await context.push<Beneficiary>(
      '/beneficiaries?select=true',
    );
    if (beneficiary == null || !mounted) return;
    setState(() {
      _recipientController.text = beneficiary.name;
      _institutionController.text = beneficiary.institution;
      _accountController.text = beneficiary.accountNumber;
    });
  }

  Widget _accountSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FieldLabel('From account'),
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
            if (value == null) return;
            setState(() {
              _fromAccount = value;
              _toAccount = null;
            });
          },
        ),
      ],
    );
  }

  Future<void> _review() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final amount = double.parse(_amountController.text.trim());
    final details = _isInternal
        ? 'To: $_toAccount'
        : _isExternal
        ? 'Recipient: ${_recipientController.text.trim()}\nCredit union: ${_institutionController.text.trim()}\nAccount: ${_accountController.text.trim()}'
        : 'Recipient: ${_recipientController.text.trim()}\nAgent: ${_institutionController.text.trim()}${_agentController.text.trim().isEmpty ? '' : '\nAgent code: ${_agentController.text.trim()}'}\nA one-time pickup code will be shown.';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Review $_title'),
        content: Text(
          'From: $_fromAccount\n$details\nAmount: ৳${amount.toStringAsFixed(2)}\n\nDemo only — nothing will be sent or withdrawn.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Edit'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Confirm demo request'),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;

    if (widget.type == MovementType.agentWithdrawal) {
      await _showPickupCode();
    } else {
      await _showSuccess(amount);
    }
  }

  Future<void> _showSuccess(double amount) async {
    final pageContext = context;
    final successTitle = _isInternal
        ? 'Transfer complete'
        : 'Transfer submitted';
    final message = _isInternal
        ? '৳${amount.toStringAsFixed(2)} was transferred to $_toAccount in this demo.'
        : 'Your demo transfer of ৳${amount.toStringAsFixed(2)} to ${_recipientController.text.trim()} was submitted.';
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const CircleAvatar(
          backgroundColor: Color(0xFFE4F4EE),
          child: Icon(Icons.check_rounded, color: Color(0xFF24845A)),
        ),
        title: Text(successTitle),
        content: Text(message, textAlign: TextAlign.center),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              if (mounted) pageContext.go('/dashboard');
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  Future<void> _showPickupCode() async {
    final pageContext = context;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const CircleAvatar(
          backgroundColor: Color(0xFFE4F4EE),
          child: Icon(Icons.check_rounded, color: Color(0xFF24845A)),
        ),
        title: const Text('Demo pickup code'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Show this one-time code to the selected agent.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),
            Text(
              '482 915',
              style: Theme.of(dialogContext).textTheme.headlineMedium?.copyWith(
                color: const Color(0xFF242269),
                fontWeight: FontWeight.w800,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Withdrawal amount: ৳${double.parse(_amountController.text.trim()).toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              if (mounted) pageContext.go('/dashboard');
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}

class LoanPaymentPage extends StatefulWidget {
  const LoanPaymentPage({super.key, required this.loanId});

  final String loanId;

  @override
  State<LoanPaymentPage> createState() => _LoanPaymentPageState();
}

class _LoanPaymentPageState extends State<LoanPaymentPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  PaymentMethod _paymentMethod = PaymentMethod.bkash;
  String _sourceAccountId = 'checking-4829';

  static const _paymentAccounts = [
    (
      id: 'checking-4829',
      name: 'Everyday Checking · •••• 4829',
      balance: 35210.0,
    ),
    (
      id: 'savings-9102',
      name: 'High-yield Savings · •••• 9102',
      balance: 10020.50,
    ),
  ];

  String get _loanName => widget.loanId == 'home-2048'
      ? 'Home loan · •••• 2048'
      : 'Auto loan · •••• 7721';

  String get _scheduledPayment =>
      widget.loanId == 'home-2048' ? '1420.00' : '430.00';

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: _scheduledPayment);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Make a loan payment')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFE9E8F7),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.real_estate_agent_outlined,
                      color: Color(0xFF242269),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Paying toward',
                          style: TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          _loanName,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            PaymentMethodSelector(
              selected: _paymentMethod,
              onChanged: (method) => setState(() => _paymentMethod = method),
            ),
            if (_paymentMethod == PaymentMethod.depositAccount) ...[
              const SizedBox(height: 10),
              const _FieldLabel('Pay from deposit account'),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _sourceAccountId,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.account_balance_wallet_outlined),
                ),
                items: _paymentAccounts
                    .map(
                      (account) => DropdownMenuItem(
                        value: account.id,
                        child: Text(account.name),
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
            const SizedBox(height: 18),
            const _FieldLabel('Payment amount'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                prefixText: '৳ ',
                helperText: 'You can edit the scheduled monthly payment.',
              ),
              validator: (value) {
                final amount = double.tryParse(value?.trim() ?? '');
                if (amount == null || amount <= 0) {
                  return 'Enter a payment amount greater than zero';
                }
                final amountLimit =
                    _paymentMethod == PaymentMethod.depositAccount
                    ? _paymentAccounts
                          .firstWhere(
                            (account) => account.id == _sourceAccountId,
                          )
                          .balance
                    : 500000.0;
                if (amount > amountLimit) {
                  return _paymentMethod == PaymentMethod.depositAccount
                      ? 'Amount exceeds the selected account balance'
                      : 'Demo payments are limited to ৳500,000';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),
            const _DemoNotice(
              message:
                  'Payment provider checkout will connect to your CCUSS API later. This demo does not process payments or change your loan balance.',
            ),
            const SizedBox(height: 22),
            ElevatedButton(
              onPressed: _reviewPayment,
              child: const Text('Review loan payment'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _reviewPayment() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final amount = double.parse(_amountController.text.trim());
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirm loan payment'),
        content: Text(
          'Loan: $_loanName\nAmount: ৳${amount.toStringAsFixed(2)}\n${_paymentMethod == PaymentMethod.depositAccount ? 'From deposit account: ${_paymentAccounts.firstWhere((account) => account.id == _sourceAccountId).name}' : 'Payment method: ${_paymentMethod.label}'}\n\nDemo only — no payment will be processed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Edit'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              _paymentMethod == PaymentMethod.depositAccount
                  ? 'Confirm demo transfer'
                  : 'Continue to demo checkout',
            ),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;
    final pageContext = context;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const CircleAvatar(
          backgroundColor: Color(0xFFE4F4EE),
          child: Icon(Icons.check_rounded, color: Color(0xFF24845A)),
        ),
        title: Text(
          _paymentMethod == PaymentMethod.depositAccount
              ? 'Demo transfer ready'
              : 'Demo checkout ready',
        ),
        content: Text(
          _paymentMethod == PaymentMethod.depositAccount
              ? 'A demo transfer of ৳${amount.toStringAsFixed(2)} from ${_paymentAccounts.firstWhere((account) => account.id == _sourceAccountId).name} toward $_loanName would be made. No balances will change.'
              : 'A ${_paymentMethod.label} checkout for ৳${amount.toStringAsFixed(2)} toward $_loanName would open here. CCUSS payment integration is not connected yet.',
          textAlign: TextAlign.center,
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              if (mounted) pageContext.go('/dashboard');
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}

class _MovementTile extends StatelessWidget {
  const _MovementTile({
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
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFEDEEF3)),
        borderRadius: BorderRadius.circular(17),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE9E8F7),
          child: Icon(icon, color: const Color(0xFF242269)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
  );
}

class _DemoNotice extends StatelessWidget {
  const _DemoNotice({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE9E8F7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, color: Color(0xFF242269)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Color(0xFF35336F)),
            ),
          ),
        ],
      ),
    );
  }
}
