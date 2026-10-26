import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

typedef _Loan = ({
  String id,
  String title,
  String subtitle,
  String original,
  String remaining,
  double progress,
  String rate,
  String due,
});

class LoansPage extends StatelessWidget {
  const LoansPage({super.key});

  static const _loans = [
    (
      id: 'home-2048',
      title: 'Home loan',
      subtitle: 'Mortgage · •••• 2048',
      original: '৳250,000',
      remaining: '৳185,400',
      progress: 0.26,
      rate: '3.9%',
      due: '৳1,420.00',
    ),
    (
      id: 'auto-7721',
      title: 'Auto loan',
      subtitle: 'Vehicle · •••• 7721',
      original: '৳35,000',
      remaining: '৳12,200',
      progress: 0.65,
      rate: '4.6%',
      due: '৳430.00',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Loan accounts')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFE9E8F7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.calendar_month_outlined, color: Color(0xFF242269)),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Next payment · Nov 15',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '৳1,850.00 total due',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Your active loans',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          ..._loans.map((loan) => _loanCard(context, loan)),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => _showDemoMessage(context),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Explore loan options'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              foregroundColor: const Color(0xFF242269),
              side: const BorderSide(color: Color(0xFF242269)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Loan overview',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFEDEEF3)),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Column(
              children: [
                _MetricRow(label: 'Monthly payments', value: '৳1,850.00'),
                Divider(height: 1),
                _MetricRow(label: 'Average interest rate', value: '4.25% p.a.'),
                Divider(height: 1),
                _MetricRow(label: 'Total repaid', value: '৳87,400.00'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _loanCard(BuildContext context, _Loan loan) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFEDEEF3)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFFE9E8F7),
                child: Icon(
                  loan.title == 'Home loan'
                      ? Icons.home_outlined
                      : Icons.directions_car_outlined,
                  color: const Color(0xFF242269),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loan.title,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      loan.subtitle,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFE4F4EE),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  'Active',
                  style: TextStyle(
                    color: Color(0xFF24845A),
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: _LoanAmount(label: 'REMAINING', value: loan.remaining),
              ),
              _LoanAmount(
                label: 'ORIGINAL',
                value: loan.original,
                alignEnd: true,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: loan.progress,
              minHeight: 7,
              backgroundColor: const Color(0xFFEDEEF3),
              color: const Color(0xFF514FA8),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Rate ${loan.rate}  ·  Due ${loan.due}',
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                ),
              ),
              TextButton(
                onPressed: () => context.push('/loans/${loan.id}'),
                child: const Text('Details'),
              ),
              TextButton(
                onPressed: () => context.push('/loan-payment/${loan.id}'),
                child: const Text('Pay now'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDemoMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Loan applications are a demo feature.')),
    );
  }
}

class _LoanAmount extends StatelessWidget {
  const _LoanAmount({
    required this.label,
    required this.value,
    this.alignEnd = false,
  });

  final String label;
  final String value;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w700,
            fontSize: 10,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
      ],
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: Colors.black54)),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
