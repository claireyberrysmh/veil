import 'package:flutter/material.dart';
import '../../services/phishstats_api.dart';
import 'tip_of_the_day_banner.dart';
import 'phishing_alert_banner.dart';
import 'quick_action_buttons.dart';
import 'protection_status_banner.dart';
import 'recent_alerts.dart';

class HomeScreenSection extends StatefulWidget {
  final VoidCallback? onOpenDetails;
  const HomeScreenSection({super.key, this.onOpenDetails});

  @override
  State<HomeScreenSection> createState() => _HomeScreenSectionState();
}

class _HomeScreenSectionState extends State<HomeScreenSection> {
  late Future<PhishPost?> _latestPostFuture;

  @override
  void initState() {
    super.initState();
    _latestPostFuture = fetchLatestPhishingPost();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'VEIL',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const ProtectionStatusBanner(),
            const SizedBox(height: 20),
            const TipOfTheDayBanner(),
            const SizedBox(height: 12),
            PhishingAlertBanner(latestPostFuture: _latestPostFuture),
            const SizedBox(height: 20),
            QuickActionButtons(
              onCheckMail: () {},
              onViewAlerts: widget.onOpenDetails,
              onSettings: () {},
            ),
            const SizedBox(height: 24),
            RecentAlerts(onAlertTap: widget.onOpenDetails),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
