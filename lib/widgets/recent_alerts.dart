import 'package:flutter/material.dart';
import 'alert_card.dart';

class RecentAlerts extends StatelessWidget {
  final VoidCallback? onAlertTap;

  const RecentAlerts({super.key, this.onAlertTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Alerts',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        AlertCard(
          title: 'Email Breach',
          subtitle: '2 hours ago',
          severity: 'high',
          onTap: onAlertTap,
        ),
        AlertCard(
          title: 'Password Leak',
          subtitle: '1 day ago',
          severity: 'medium',
          onTap: onAlertTap,
        ),
        AlertCard(
          title: 'Data Exposure',
          subtitle: '3 days ago',
          severity: 'low',
          onTap: onAlertTap,
        ),
      ],
    );
  }
}
