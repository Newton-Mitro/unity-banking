import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/mock_beneficiary_store.dart';
import '../../domain/entities/beneficiary.dart';

class BeneficiariesPage extends StatefulWidget {
  const BeneficiariesPage({super.key, this.selectMode = false});

  final bool selectMode;

  @override
  State<BeneficiariesPage> createState() => _BeneficiariesPageState();
}

class _BeneficiariesPageState extends State<BeneficiariesPage> {
  List<Beneficiary> get _beneficiaries =>
      List.unmodifiable(MockBeneficiaryStore.beneficiaries);

  @override
  Widget build(BuildContext context) {
    final beneficiaries = _beneficiaries;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.selectMode ? 'Choose beneficiary' : 'Beneficiaries'),
        actions: [
          if (!widget.selectMode)
            IconButton(
              tooltip: 'Add beneficiary',
              onPressed: _addBeneficiary,
              icon: const Icon(Icons.person_add_alt_1_outlined),
            ),
        ],
      ),
      body: beneficiaries.isEmpty
          ? _emptyState(context)
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                if (!widget.selectMode) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9E8F7),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.verified_user_outlined,
                          color: Color(0xFF242269),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Saved recipients are demo data stored only for this app session.',
                            style: TextStyle(color: Color(0xFF35336F)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '${beneficiaries.length} saved ${beneficiaries.length == 1 ? 'beneficiary' : 'beneficiaries'}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                ...beneficiaries.map(
                  (beneficiary) => _beneficiaryTile(context, beneficiary),
                ),
                if (!widget.selectMode) ...[
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: _addBeneficiary,
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Add a beneficiary'),
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
              ],
            ),
    );
  }

  Widget _beneficiaryTile(BuildContext context, Beneficiary beneficiary) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFEDEEF3)),
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        onTap: widget.selectMode
            ? () => context.pop(beneficiary)
            : () => _showDetails(beneficiary),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE9E8F7),
          child: Text(
            beneficiary.displayName.substring(0, 1).toUpperCase(),
            style: const TextStyle(
              color: Color(0xFF242269),
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        title: Text(
          beneficiary.displayName,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          '${beneficiary.institution} · ${beneficiary.maskedAccount}',
          maxLines: 2,
        ),
        trailing: widget.selectMode
            ? const Icon(Icons.chevron_right_rounded)
            : PopupMenuButton<String>(
                tooltip: 'Beneficiary actions',
                onSelected: (action) {
                  if (action == 'delete') _confirmDelete(beneficiary);
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'delete', child: Text('Remove')),
                ],
              ),
      ),
    );
  }

  Widget _emptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 34,
              backgroundColor: Color(0xFFE9E8F7),
              child: Icon(
                Icons.people_outline_rounded,
                size: 32,
                color: Color(0xFF242269),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.selectMode
                  ? 'No saved beneficiaries'
                  : 'No beneficiaries yet',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add a recipient to make future transfers easier.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: _addBeneficiary,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add beneficiary'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addBeneficiary() async {
    final wasAdded = await context.push<bool>('/beneficiaries/new');
    if (wasAdded == true && mounted) setState(() {});
  }

  Future<void> _showDetails(Beneficiary beneficiary) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                beneficiary.displayName,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 16),
              _DetailRow(label: 'Full name', value: beneficiary.name),
              _DetailRow(label: 'Credit union', value: beneficiary.institution),
              _DetailRow(
                label: 'Account number',
                value: beneficiary.maskedAccount,
              ),
              const SizedBox(height: 16),
              const Text(
                'Beneficiary details are demo data and are not verified against a bank.',
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(Beneficiary beneficiary) async {
    final remove = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove beneficiary?'),
        content: Text(
          '${beneficiary.displayName} will be removed from this demo list.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (remove != true || !mounted) return;
    setState(() => MockBeneficiaryStore.remove(beneficiary.id));
  }
}

class AddBeneficiaryPage extends StatefulWidget {
  const AddBeneficiaryPage({super.key});

  @override
  State<AddBeneficiaryPage> createState() => _AddBeneficiaryPageState();
}

class _AddBeneficiaryPageState extends State<AddBeneficiaryPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _institutionController = TextEditingController();
  final _accountController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _nicknameController.dispose();
    _institutionController.dispose();
    _accountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add beneficiary')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          children: [
            const Text(
              'Recipient details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            const Text(
              'Save recipient information for future inter-credit-union transfers.',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 20),
            _field(
              label: 'Full name',
              controller: _nameController,
              hint: 'Recipient full name',
              icon: Icons.person_outline_rounded,
              capitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            _field(
              label: 'Nickname (optional)',
              controller: _nicknameController,
              hint: 'How you know them',
              icon: Icons.badge_outlined,
              capitalization: TextCapitalization.words,
              required: false,
            ),
            const SizedBox(height: 16),
            _field(
              label: 'Credit union',
              controller: _institutionController,
              hint: 'Receiving institution',
              icon: Icons.account_balance_outlined,
              capitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            _field(
              label: 'Account number',
              controller: _accountController,
              hint: 'At least 6 digits',
              icon: Icons.numbers_rounded,
              keyboardType: TextInputType.number,
              validator: (value) => value == null || value.trim().length < 6
                  ? 'Enter an account number (at least 6 characters)'
                  : null,
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0DF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline_rounded, color: Color(0xFFAA6816)),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'This demo does not verify account ownership or save beneficiary details to a server.',
                      style: TextStyle(color: Color(0xFF76501E)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            ElevatedButton(
              onPressed: _save,
              child: const Text('Save beneficiary'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextCapitalization capitalization = TextCapitalization.none,
    TextInputType? keyboardType,
    bool required = true,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          textCapitalization: capitalization,
          keyboardType: keyboardType,
          decoration: InputDecoration(hintText: hint, prefixIcon: Icon(icon)),
          validator:
              validator ??
              (value) => required && (value == null || value.trim().isEmpty)
                  ? 'Enter $label'
                  : null,
        ),
      ],
    );
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final accountNumber = _accountController.text.trim();
    if (MockBeneficiaryStore.beneficiaries.any(
      (beneficiary) => beneficiary.accountNumber == accountNumber,
    )) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This account is already saved as a beneficiary.'),
        ),
      );
      return;
    }

    MockBeneficiaryStore.add(
      Beneficiary(
        id: 'beneficiary-${DateTime.now().microsecondsSinceEpoch}',
        name: _nameController.text.trim(),
        institution: _institutionController.text.trim(),
        accountNumber: accountNumber,
        nickname: _nicknameController.text.trim(),
      ),
    );
    context.pop(true);
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 7),
    child: Row(
      children: [
        SizedBox(
          width: 120,
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
