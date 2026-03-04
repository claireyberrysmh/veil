import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/watched_domain.dart';
import 'auth_service.dart';

class WatchlistRepository {
  static const String _watchlistKeyPrefix = 'watchlist_';

  static Future<String> _getStorageKey() async {
    final currentUser = await AuthService.getCurrentUser();
    final userKey = currentUser ?? 'guest';
    return '$_watchlistKeyPrefix$userKey';
  }

  static Future<List<WatchedDomain>> getWatchlist() async {
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
          .map(WatchedDomain.fromJson)
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> _saveWatchlist(List<WatchedDomain> items) async {
    final prefs = await SharedPreferences.getInstance();
    final key = await _getStorageKey();
    final jsonString =
        jsonEncode(items.map((item) => item.toJson()).toList());
    await prefs.setString(key, jsonString);
  }

  static Future<void> addDomain(WatchedDomain domain) async {
    final items = await getWatchlist();
    final updated = List<WatchedDomain>.from(items)..add(domain);
    await _saveWatchlist(updated);
  }

  static Future<void> removeDomain(String id) async {
    final items = await getWatchlist();
    final updated =
        items.where((item) => item.id != id).toList();
    await _saveWatchlist(updated);
  }
}

