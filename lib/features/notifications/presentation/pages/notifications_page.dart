import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final _alerts = [
    _Alert(
      title: 'Card payment',
      description: 'You spent \$84.26 at Grocery Market.',
      time: 'Today · 10:42 AM',
      icon: Icons.shopping_bag_outlined,
      unread: true,
    ),
    _Alert(
      title: 'Salary received',
      description: 'Your monthly salary of \$4,500.00 has been deposited.',
      time: 'Yesterday',
      icon: Icons.account_balance_outlined,
      unread: true,
    ),
    _Alert(
      title: 'Transfer complete',
      description: 'Your transfer to Jamie Lee was successful.',
      time: 'Oct 24',
      icon: Icons.swap_horiz_rounded,
      unread: false,
    ),
    _Alert(
      title: 'Security reminder',
      description: 'Remember to keep your sign-in details private.',
      time: 'Oct 20',
      icon: Icons.shield_outlined,
      unread: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final unreadCount = _alerts.where((alert) => alert.unread).length;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: unreadCount == 0 ? null : _markAllRead,
            child: const Text('Mark all read'),
          ),
        ],
      ),
      body: _alerts.isEmpty
          ? const Center(child: Text('You’re all caught up.'))
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                if (unreadCount > 0) ...[
                  Text(
                    '$unreadCount new',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                ..._alerts.asMap().entries.map(
                  (entry) => _alertTile(context, entry.key, entry.value),
                ),
              ],
            ),
    );
  }

  Widget _alertTile(BuildContext context, int index, _Alert alert) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => _openAlert(index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: alert.unread ? const Color(0xFFF0EFF9) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: alert.unread
                ? const Color(0xFFD9D7F0)
                : const Color(0xFFEDEEF3),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: alert.unread
                  ? const Color(0xFFE0DFF3)
                  : const Color(0xFFF0F0F4),
              child: Icon(alert.icon, color: const Color(0xFF242269), size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          alert.title,
                          style: TextStyle(
                            fontWeight: alert.unread
                                ? FontWeight.w800
                                : FontWeight.w600,
                          ),
                        ),
                      ),
                      if (alert.unread)
                        const CircleAvatar(
                          radius: 4,
                          backgroundColor: Color(0xFF514FA8),
                        ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    alert.description,
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    alert.time,
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openAlert(int index) async {
    final alert = _alerts[index];
    setState(() => _alerts[index] = alert.copyWith(unread: false));
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(alert.icon, size: 34, color: const Color(0xFF242269)),
        title: Text(alert.title),
        content: Text(alert.description, textAlign: TextAlign.center),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _markAllRead() {
    setState(() {
      for (var index = 0; index < _alerts.length; index++) {
        _alerts[index] = _alerts[index].copyWith(unread: false);
      }
    });
  }
}

class _Alert {
  const _Alert({
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    required this.unread,
  });

  final String title;
  final String description;
  final String time;
  final IconData icon;
  final bool unread;

  _Alert copyWith({bool? unread}) => _Alert(
    title: title,
    description: description,
    time: time,
    icon: icon,
    unread: unread ?? this.unread,
  );
}
