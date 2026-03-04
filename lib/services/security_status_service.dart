import 'alert_repository.dart';
import 'watchlist_repository.dart';

class SecurityStatus {
  final int score; // 0–100
  final int activeAlerts;
  final bool hasWatchlist;

  const SecurityStatus({
    required this.score,
    required this.activeAlerts,
    required this.hasWatchlist,
  });
}

class SecurityStatusService {
  static Future<SecurityStatus> calculate() async {
    final alerts = await AlertRepository.getAlerts();
    final watchlist = await WatchlistRepository.getWatchlist();

    final activeAlerts =
        alerts.where((a) => !a.isResolved).toList();
    final int highCount =
        activeAlerts.where((a) => a.severity == 'high').length;
    final int totalActive = activeAlerts.length;
    final bool hasWatchlist = watchlist.isNotEmpty;

    // Simple scoring heuristic
    int score = 100;

    if (totalActive > 0) {
      score -= 20;
    }
    if (highCount > 0) {
      score -= 20;
    }
    if (!hasWatchlist) {
      score -= 10;
    }

    if (score < 0) score = 0;

    return SecurityStatus(
      score: score,
      activeAlerts: totalActive,
      hasWatchlist: hasWatchlist,
    );
  }
}

