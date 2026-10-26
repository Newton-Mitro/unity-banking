import 'package:flutter/material.dart';

class StatementsPage extends StatelessWidget {
  const StatementsPage({super.key});

  static const _statements = [
    ('October 2026', 'Oct 1 – Oct 31, 2026', '2.4 MB'),
    ('September 2026', 'Sep 1 – Sep 30, 2026', '2.1 MB'),
    ('August 2026', 'Aug 1 – Aug 31, 2026', '2.2 MB'),
    ('July 2026', 'Jul 1 – Jul 31, 2026', '1.9 MB'),
    ('June 2026', 'Jun 1 – Jun 30, 2026', '2.0 MB'),
    ('May 2026', 'May 1 – May 31, 2026', '1.8 MB'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Statements')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFE7F0FB),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.description_outlined, color: Color(0xFF315B93)),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Your monthly statements are ready to view in this demo.',
                    style: TextStyle(color: Color(0xFF294B79)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Monthly statements',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          ..._statements.map((statement) => _statementTile(context, statement)),
        ],
      ),
    );
  }

  Widget _statementTile(BuildContext context, (String, String, String) item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEDEEF3)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFE9E8F7),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
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
                  item.$1,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 3),
                Text(
                  '${item.$2}  ·  PDF  ·  ${item.$3}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Open statement preview',
            onPressed: () => _showPreview(context, item.$1),
            icon: const Icon(
              Icons.visibility_outlined,
              color: Color(0xFF242269),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showPreview(BuildContext context, String month) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(
          Icons.picture_as_pdf_outlined,
          size: 38,
          color: Color(0xFF242269),
        ),
        title: Text('$month statement'),
        content: const Text(
          'Statement preview is available in the demo. No file will be downloaded.',
          textAlign: TextAlign.center,
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close preview'),
          ),
        ],
      ),
    );
  }
}
