import 'package:flutter/material.dart';
import '../../services/phishstats_api.dart';
import '../../services/security_status_service.dart';
import '../../screens/url_scan_screen.dart';
import '../../screens/watchlist_screen.dart';
import 'tip_of_the_day_banner.dart';
import 'phishing_alert_banner.dart';
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
  final GlobalKey<_RecentAlertsState> _recentAlertsKey =
      GlobalKey<_RecentAlertsState>();

  @override
  void initState() {
    super.initState();
    _latestPostFuture = fetchLatestPhishingPost();
  }

  Future<void> _openUrlScanScreen() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const UrlScanScreen(),
      ),
    );
    // Refresh alerts when returning from scan screen
    if (result == true || mounted) {
      _recentAlertsKey.currentState?.refreshAlerts();
    }
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
            _buildScanLinkCard(context),
            const SizedBox(height: 20),
            _buildSecuritySummaryCard(context),
            const SizedBox(height: 24),
            _buildWatchlistCard(context),
            const SizedBox(height: 24),
            RecentAlerts(
              key: _recentAlertsKey,
              onAlertTap: widget.onOpenDetails,
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildScanLinkCard(BuildContext context) {
    return GestureDetector(
      onTap: _openUrlScanScreen,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.greenAccent.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.greenAccent),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Scan a link',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Paste a suspicious URL from email or SMS and check it for phishing.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white54),
          ],
        ),
      ),
    );
  }

  Widget _buildSecuritySummaryCard(BuildContext context) {
    return FutureBuilder<SecurityStatus>(
      future: SecurityStatusService.calculate(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white12),
            ),
            child: const Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 12),
                Text('Checking your security status...'),
              ],
            ),
          );
        }

        final status = snapshot.data!;
        final bool isClear = status.activeAlerts == 0;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white12),
          ),
          child: Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 36,
                    height: 36,
                    child: CircularProgressIndicator(
                      value: status.score / 100,
                      strokeWidth: 4,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        status.score >= 80
                            ? Colors.greenAccent
                            : status.score >= 50
                                ? Colors.orangeAccent
                                : Colors.redAccent,
                      ),
                      backgroundColor: Colors.white12,
                    ),
                  ),
                  Text(
                    '${status.score}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isClear
                          ? 'You’re protected'
                          : '${status.activeAlerts} active alert${status.activeAlerts > 1 ? 's' : ''}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isClear
                          ? 'We’ll notify you here if we spot anything suspicious.'
                          : 'Review your alerts to keep your accounts secured.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: widget.onOpenDetails,
                child: const Text('View alerts'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWatchlistCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const WatchlistScreen(),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white12),
        ),
        child: Row(
          children: [
            const Icon(Icons.visibility_outlined, color: Colors.white70),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Domain watchlist',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Track phishing activity for banks, email providers, and other important sites.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white54),
          ],
        ),
      ),
    );
  }
}
