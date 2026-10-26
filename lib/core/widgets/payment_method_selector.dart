import 'package:flutter/material.dart';

enum PaymentMethod {
  bkash('bkash', 'bKash', Icons.account_balance_wallet_outlined),
  nagad('nagad', 'Nagad', Icons.wallet_outlined),
  rocket('rocket', 'Rocket', Icons.rocket_launch_outlined),
  card('card', 'Debit / credit card', Icons.credit_card_outlined),
  depositAccount(
    'deposit_account',
    'Transfer from deposit account',
    Icons.account_balance_wallet_outlined,
  ),
  bankTransfer(
    'bank_transfer',
    'Bank transfer',
    Icons.account_balance_outlined,
  );

  const PaymentMethod(this.apiCode, this.label, this.icon);

  final String apiCode;
  final String label;
  final IconData icon;
}

class PaymentMethodSelector extends StatelessWidget {
  const PaymentMethodSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final PaymentMethod selected;
  final ValueChanged<PaymentMethod> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment method',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
        const SizedBox(height: 8),
        ...PaymentMethod.values.map((method) {
          final isSelected = method == selected;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              child: InkWell(
                onTap: () => onChanged(method),
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13,
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF514FA8)
                          : const Color(0xFFEDEEF3),
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: isSelected
                            ? const Color(0xFFE9E8F7)
                            : const Color(0xFFF4F4F7),
                        child: Icon(
                          method.icon,
                          size: 19,
                          color: const Color(0xFF242269),
                        ),
                      ),
                      const SizedBox(width: 11),
                      Expanded(
                        child: Text(
                          method.label,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      Radio<PaymentMethod>(
                        value: method,
                        groupValue: selected,
                        onChanged: (value) {
                          if (value != null) onChanged(value);
                        },
                        activeColor: const Color(0xFF514FA8),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

class PaymentDemoNotice extends StatelessWidget {
  const PaymentDemoNotice({super.key, required this.message});

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
