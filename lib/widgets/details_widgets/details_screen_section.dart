import 'package:flutter/material.dart';
import 'alert_details_card.dart';
import 'recommendation_item.dart';

class DetailsScreenSection extends StatelessWidget {
  const DetailsScreenSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Alert Details',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            AlertDetailsCard(
              title: 'Email Breach Detected',
              severity: 'high',
              detectedTime: '2 hours ago',
              details: {
                'Affected Email': 'user@example.com',
                'Breach Source': 'Unknown Database',
                'Data Exposed': 'Email, Password Hash',
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Recommendations',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            RecommendationItem(
              title: 'Change your password',
              description:
                  'Update your password immediately on the affected service and any other accounts using the same password.',
            ),
            RecommendationItem(
              title: 'Enable 2FA',
              description:
                  'Add two-factor authentication to strengthen your account security.',
            ),
            RecommendationItem(
              title: 'Monitor your accounts',
              description:
                  'Keep an eye on your account activity for any suspicious behavior.',
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                minimumSize: const Size.fromHeight(48),
              ),
              child: const Text('Mark as Resolved'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                side: const BorderSide(color: Colors.white12),
              ),
              child: const Text(
                'Get more Help',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
