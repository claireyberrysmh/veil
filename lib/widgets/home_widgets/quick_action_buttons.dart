import 'package:flutter/material.dart';

class QuickActionButtons extends StatelessWidget {
  final VoidCallback? onCheckMail;
  final VoidCallback? onViewAlerts;
  final VoidCallback? onSettings;

  const QuickActionButtons({
    super.key,
    this.onCheckMail,
    this.onViewAlerts,
    this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: onCheckMail ?? () {},
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            backgroundColor: Colors.green[600],
          ),
          child: const Text('Check mail'),
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: onViewAlerts,
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            side: const BorderSide(color: Colors.white12),
          ),
          child: const Text(
            'View alerts',
            style: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: onSettings ?? () {},
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            side: const BorderSide(color: Colors.white12),
          ),
          child: const Text('Settings', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
