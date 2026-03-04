import 'package:flutter/material.dart';

import '../models/alert.dart';
import '../services/alert_repository.dart';
import '../services/phishstats_api.dart';
import '../services/notification_service.dart';

class UrlScanScreen extends StatefulWidget {
  const UrlScanScreen({super.key});

  @override
  State<UrlScanScreen> createState() => _UrlScanScreenState();
}

class _UrlScanScreenState extends State<UrlScanScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  List<PhishPost> _results = [];
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _scan() async {
    final input = _controller.text.trim();
    if (input.isEmpty) return;

    setState(() {
      _isLoading = true;
      _results = [];
      _error = null;
    });

    try {
      final uri = Uri.tryParse(input);
      final domain =
          uri != null && uri.host.isNotEmpty ? uri.host : input;

      final posts = await searchPhishingByDomain(domain);
      setState(() {
        _results = posts;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to scan link. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveAsAlert() async {
    if (_results.isEmpty) return;
    final first = _results.first;
    final now = DateTime.now();

    final alert = Alert(
      id: 'scan_${now.millisecondsSinceEpoch}',
      title: 'Suspicious link detected',
      severity: 'high',
      timeAgo: 'Just now',
      summary: first.title,
      details: {
        'URL': first.url,
        if (first.countrycode != null) 'Country': first.countrycode!,
        if (first.score != null) 'Risk score': '${first.score}%',
      },
      recommendations: const [
        'Do not click this link or enter any personal data.',
        'Verify the sender and website via official channels.',
        'Report this message as phishing if it was unsolicited.',
      ],
      isResolved: false,
      type: 'scan',
      timestamp: now,
    );

    await AlertRepository.addAlert(alert);

    await NotificationService().showNotification(
      id: now.millisecondsSinceEpoch % 100000,
      title: 'Suspicious link detected',
      body: first.url,
      payload: 'alert:${alert.id}',
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Alert saved to your inbox'),
        ),
      );
      // Return to home screen and signal to refresh alerts
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan a link'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Paste a link from email, SMS, or web and we’ll check it against recent phishing reports.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'https://example.com/login',
                  prefixIcon: Icon(Icons.link),
                ),
                keyboardType: TextInputType.url,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _scan(),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _scan,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Scan link'),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _buildResults(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResults(BuildContext context) {
    final theme = Theme.of(context);

    if (_error != null) {
      return Center(
        child: Text(
          _error!,
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: Colors.redAccent),
          textAlign: TextAlign.center,
        ),
      );
    }

    if (_results.isEmpty) {
      return const Center(
        child: Text(
          'No known phishing reports for this link.\nStill, be cautious and verify the sender.',
          textAlign: TextAlign.center,
        ),
      );
    }

    final first = _results.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.warning_amber_rounded,
                color: Colors.redAccent),
            const SizedBox(width: 8),
            Text(
              'This link looks risky',
              style: theme.textTheme.titleMedium,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.redAccent.withOpacity(0.4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                first.url,
                style: theme.textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              if (first.score != null)
                Text(
                  'Risk score: ${first.score}%',
                  style: theme.textTheme.bodyMedium,
                ),
              if (first.countrycode != null)
                Text(
                  'Reported from: ${first.countrycode}',
                  style: theme.textTheme.bodyMedium,
                ),
              if (first.date != null)
                Text(
                  'First seen: ${first.date}',
                  style: theme.textTheme.bodyMedium,
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: _saveAsAlert,
            child: const Text('Save as alert'),
          ),
        ),
      ],
    );
  }
}

