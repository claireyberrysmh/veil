import 'package:flutter/material.dart';

import '../models/alert.dart';
import '../services/alert_repository.dart';
import '../widgets/details_widgets/alert_details_card.dart';
import '../widgets/details_widgets/recommendation_item.dart';

class AlertDetailScreen extends StatelessWidget {
  final Alert alert;

  const AlertDetailScreen({super.key, required this.alert});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alert Details'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AlertDetailsCard(
                title: alert.title,
                severity: alert.severity,
                detectedTime: alert.timeAgo,
                details: alert.details,
              ),
              const SizedBox(height: 24),
              Text(
                'Recommendations',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              ...alert.recommendations.map(
                (rec) => RecommendationItem(
                  title: 'Recommendation',
                  description: rec,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  await AlertRepository.markResolved(alert.id);
                  if (context.mounted) {
                    Navigator.of(context).pop(true);
                  }
                },
                child: const Text('Mark as Resolved'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () {},
                child: const Text('Get more help'),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

