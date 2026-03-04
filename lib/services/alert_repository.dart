import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/alert.dart';
import 'auth_service.dart';

class AlertRepository {
  static const String _alertsKeyPrefix = 'alerts_';

  static Future<String> _getStorageKey() async {
    final currentUser = await AuthService.getCurrentUser();
    final userKey = currentUser ?? 'guest';
    return '$_alertsKeyPrefix$userKey';
  }

  static Future<List<Alert>> getAlerts() async {
    final prefs = await SharedPreferences.getInstance();
    final key = await _getStorageKey();
    final jsonString = prefs.getString(key);
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> decoded = jsonDecode(jsonString) as List<dynamic>;
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(Alert.fromJson)
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> _saveAlerts(List<Alert> alerts) async {
    final prefs = await SharedPreferences.getInstance();
    final key = await _getStorageKey();
    final jsonString = jsonEncode(alerts.map((a) => a.toJson()).toList());
    await prefs.setString(key, jsonString);
  }

  static Future<void> addAlert(Alert alert) async {
    final alerts = await getAlerts();
    final updated = List<Alert>.from(alerts)..add(alert);
    await _saveAlerts(updated);
  }

  static Future<void> updateAlert(Alert updatedAlert) async {
    final alerts = await getAlerts();
    final updated = alerts
        .map((a) => a.id == updatedAlert.id ? updatedAlert : a)
        .toList();
    await _saveAlerts(updated);
  }

  static Future<void> markResolved(String id) async {
    final alerts = await getAlerts();
    final updated = alerts
        .map(
          (a) => a.id == id
              ? a.copyWith(isResolved: true)
              : a,
        )
        .toList();
    await _saveAlerts(updated);
  }

  static Future<Alert?> getAlertById(String id) async {
    final alerts = await getAlerts();
    try {
      return alerts.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }
}

