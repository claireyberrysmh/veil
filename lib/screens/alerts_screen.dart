import 'package:flutter/material.dart';

import '../models/alert.dart';
import '../services/alert_repository.dart';
import '../widgets/alerts_widgets/alert_list_item.dart';
import 'alert_detail_screen.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  int _selectedFilterIndex = 0; // 0 = All, 1 = Active, 2 = Resolved, 3 = Critical
  List<Alert> _alerts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAlerts();
  }

  Future<void> _loadAlerts() async {
    final alerts = await AlertRepository.getAlerts();
    setState(() {
      _alerts = alerts;
      _isLoading = false;
    });
  }

  List<Alert> get _filteredAlerts {
    switch (_selectedFilterIndex) {
      case 1: // Active (not resolved)
        return _alerts.where((a) => !a.isResolved).toList();
      case 2: // Resolved
        return _alerts.where((a) => a.isResolved).toList();
      case 3: // Critical / high severity
        return _alerts.where((a) => a.severity == 'high').toList();
      default:
        return _alerts;
    }
  }

  @override
  Widget build(BuildContext context) {
    final int activeCount =
        _alerts.where((alert) => !alert.isResolved).length;
    final filtered = _filteredAlerts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alerts'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                ),
              )
            : _alerts.isEmpty
                ? Center(
                    child: Text(
                      'No alerts yet.\nYou’re all clear.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  )
                : Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              activeCount > 0
                                  ? '$activeCount active alert${activeCount > 1 ? 's' : ''}'
                                  : 'You’re all clear',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              activeCount > 0
                                  ? 'Review and resolve alerts to keep your accounts secure.'
                                  : 'We’ll let you know here if we detect anything suspicious.',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 12),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  _buildFilterChip(context, 0, 'All'),
                                  const SizedBox(width: 8),
                                  _buildFilterChip(context, 1, 'Active'),
                                  const SizedBox(width: 8),
                                  _buildFilterChip(context, 2, 'Resolved'),
                                  const SizedBox(width: 8),
                                  _buildFilterChip(context, 3, 'Critical'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: Colors.white10),
                      Expanded(
                        child: filtered.isEmpty
                            ? Center(
                                child: Text(
                                  'No alerts for this filter.',
                                  style:
                                      Theme.of(context).textTheme.bodyMedium,
                                ),
                              )
                            : RefreshIndicator(
                                onRefresh: _loadAlerts,
                                child: ListView.separated(
                                  padding: const EdgeInsets.all(16),
                                  itemBuilder: (context, index) {
                                    final alert = filtered[index];
                                    return AlertListItem(
                                      alert: alert,
                                      onTap: () async {
                                        await Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                AlertDetailScreen(alert: alert),
                                          ),
                                        );
                                        await _loadAlerts();
                                      },
                                    );
                                  },
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(height: 4),
                                  itemCount: filtered.length,
                                ),
                              ),
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    int index,
    String label,
  ) {
    final bool isSelected = _selectedFilterIndex == index;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        setState(() {
          _selectedFilterIndex = index;
        });
      },
      labelStyle: TextStyle(
        color: isSelected ? Colors.black : Colors.white70,
        fontSize: 12,
      ),
      selectedColor: Colors.greenAccent,
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? Colors.greenAccent : Colors.white24,
        ),
      ),
    );
  }
}

