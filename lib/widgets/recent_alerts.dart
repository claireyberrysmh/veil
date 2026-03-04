import 'package:flutter/material.dart';
import '../services/alert_repository.dart';
import '../models/alert.dart';
import 'alert_card.dart';

class RecentAlerts extends StatefulWidget {
  final VoidCallback? onAlertTap;

  const RecentAlerts({super.key, this.onAlertTap});

  @override
  State<RecentAlerts> createState() => _RecentAlertsState();
}

class _RecentAlertsState extends State<RecentAlerts> {
  late Future<List<Alert>> _alertsFuture;

  @override
  void initState() {
    super.initState();
    _refreshAlerts();
  }

  void refreshAlerts() {
    _refreshAlerts();
  }

  void _refreshAlerts() {
    setState(() {
      _alertsFuture = AlertRepository.getAlerts();
    });
  }

  String _calculateTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

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
        FutureBuilder<List<Alert>>(
          future: _alertsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error loading alerts',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.redAccent),
                ),
              );
            }

            final alerts = snapshot.data ?? [];

            if (alerts.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[800]!),
                ),
                child: Center(
                  child: Text(
                    'No alerts yet. Your accounts are safe!',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white60,
                        ),
                  ),
                ),
              );
            }

            // Sort alerts by timestamp (newest first) and take top 3
            final sortedAlerts = List<Alert>.from(alerts)
              ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
            final recentAlerts =
                sortedAlerts.take(3).toList();

            return Column(
              children: recentAlerts.map((alert) {
                final timeAgo = _calculateTimeAgo(alert.timestamp);
                return AlertCard(
                  title: alert.title,
                  subtitle: timeAgo,
                  severity: alert.severity,
                  onTap: widget.onAlertTap,
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
