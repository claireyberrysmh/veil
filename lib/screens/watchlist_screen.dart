import 'package:flutter/material.dart';

import '../models/alert.dart';
import '../models/watched_domain.dart';
import '../services/alert_repository.dart';
import '../services/phishstats_api.dart';
import '../services/watchlist_repository.dart';
import '../services/notification_service.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  final TextEditingController _domainController = TextEditingController();
  final TextEditingController _labelController = TextEditingController();
  bool _isChecking = false;
  List<WatchedDomain> _items = [];

  @override
  void initState() {
    super.initState();
    _loadWatchlist();
  }

  @override
  void dispose() {
    _domainController.dispose();
    _labelController.dispose();
    super.dispose();
  }

  Future<void> _loadWatchlist() async {
    final items = await WatchlistRepository.getWatchlist();
    setState(() {
      _items = items;
    });
  }

  Future<void> _addDomain() async {
    final domain = _domainController.text.trim();
    if (domain.isEmpty) return;
    final label = _labelController.text.trim().isEmpty
        ? domain
        : _labelController.text.trim();

    final now = DateTime.now();
    final item = WatchedDomain(
      id: 'watch_${now.millisecondsSinceEpoch}',
      domain: domain,
      label: label,
      createdAt: now,
      enabled: true,
    );

    await WatchlistRepository.addDomain(item);
    _domainController.clear();
    _labelController.clear();
    await _loadWatchlist();
  }

  Future<void> _removeDomain(String id) async {
    await WatchlistRepository.removeDomain(id);
    await _loadWatchlist();
  }

  Future<void> _checkNow() async {
    if (_items.isEmpty) return;
    setState(() {
      _isChecking = true;
    });

    int alertsCreated = 0;

    for (final item in _items) {
      if (!item.enabled) continue;

      final posts = await searchPhishingByDomain(item.domain);
      if (posts.isEmpty) continue;

      final first = posts.first;
      final now = DateTime.now();

      final alert = Alert(
        id: 'watch_${item.domain}_${now.millisecondsSinceEpoch}',
        title: 'Watchlist domain reported',
        severity: 'high',
        timeAgo: 'Just now',
        summary: 'Recent phishing activity for ${item.domain}',
        details: {
          'Domain': item.domain,
          'Title': first.title,
          'URL': first.url,
          if (first.countrycode != null) 'Country': first.countrycode!,
          if (first.score != null) 'Risk score': '${first.score}%',
        },
        recommendations: const [
          'Be extra careful with emails or messages mentioning this domain.',
          'Always access the site by typing the address manually.',
          'Report suspicious messages to your provider.',
        ],
        isResolved: false,
        type: 'watchlist',
      );

      await AlertRepository.addAlert(alert);
      alertsCreated++;

      await NotificationService().showNotification(
        id: now.millisecondsSinceEpoch % 100000,
        title: 'Watchlist alert for ${item.domain}',
        body: first.url,
        payload: 'alert:${alert.id}',
      );
    }

    setState(() {
      _isChecking = false;
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          alertsCreated > 0
              ? '$alertsCreated alert(s) created from your watchlist.'
              : 'No new phishing records found for your watchlist.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Domain watchlist'),
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
                'Add important domains (banks, email providers, workplaces) and we’ll help you keep an eye on phishing campaigns using them.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _domainController,
                      decoration: const InputDecoration(
                        hintText: 'example.com',
                        labelText: 'Domain',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _labelController,
                      decoration: const InputDecoration(
                        hintText: 'Label (optional)',
                        labelText: 'Label',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _addDomain,
                  child: const Text('Add to watchlist'),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your domains',
                    style: theme.textTheme.titleMedium,
                  ),
                  TextButton.icon(
                    onPressed: _isChecking ? null : _checkNow,
                    icon: _isChecking
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.sync),
                    label: const Text('Check now'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: _items.isEmpty
                    ? const Center(
                        child: Text(
                          'No domains yet. Add a domain above to start monitoring.',
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.separated(
                        itemBuilder: (context, index) {
                          final item = _items[index];
                          return ListTile(
                            title: Text(item.label),
                            subtitle: Text(item.domain),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => _removeDomain(item.id),
                            ),
                          );
                        },
                        separatorBuilder: (_, __) =>
                            const Divider(height: 1),
                        itemCount: _items.length,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

