import 'package:http/http.dart' as http;
import 'dart:convert';

/// Модель для одного поста из PhishStats
class PhishPost {
  final String id;
  final String title;
  final String url;
  final String? countrycode;
  final num? score;
  final String? date;
  final String? ip;
  final String? tld;

  PhishPost({
    required this.id,
    required this.title,
    required this.url,
    this.countrycode,
    this.score,
    this.date,
    this.ip,
    this.tld,
  });

  factory PhishPost.fromJson(Map<String, dynamic> json) {
    return PhishPost(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      countrycode: json['countrycode']?.toString(),
      score: json['score'],
      date: json['date']?.toString(),
      ip: json['ip']?.toString(),
      tld: json['tld']?.toString(),
    );
  }
}

const String _basePhishStatsUrl =
    'https://api.phishstats.info/api/phishing';

/// Получает последний пост из PhishStats (или null при ошибке)
Future<PhishPost?> fetchLatestPhishingPost() async {
  try {
    final response = await http.get(
      Uri.parse('$_basePhishStatsUrl?_sort=-date&_size=1'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List && data.isNotEmpty) {
        return PhishPost.fromJson(data[0]);
      }
      return null;
    } else {
      // Неудачный ответ
      return null;
    }
  } catch (e) {
    // Ошибка сети / парсинга
    return null;
  }
}

/// Получает несколько недавних фишинговых записей с возможной фильтрацией.
Future<List<PhishPost>> fetchRecentPhishingPosts({
  int size = 10,
  num? minScore,
  String? countryCode,
  String? query,
}) async {
  final params = <String, String>{
    '_sort': '-date',
    '_size': size.toString(),
  };

  if (minScore != null) {
    params['score_gt'] = minScore.toString();
  }
  if (countryCode != null && countryCode.isNotEmpty) {
    params['countrycode_eq'] = countryCode;
  }
  if (query != null && query.isNotEmpty) {
    params['title_like'] = query;
  }

  final uri = Uri.parse(_basePhishStatsUrl).replace(queryParameters: params);

  try {
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map(PhishPost.fromJson)
            .toList();
      }
      return [];
    } else {
      return [];
    }
  } catch (_) {
    return [];
  }
}

/// Ищет фишинговые записи по домену (или части URL).
Future<List<PhishPost>> searchPhishingByDomain(String domain) async {
  if (domain.isEmpty) return [];

  final params = <String, String>{
    '_sort': '-date',
    '_size': '20',
    'url_like': domain,
  };

  final uri = Uri.parse(_basePhishStatsUrl).replace(queryParameters: params);

  try {
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map(PhishPost.fromJson)
            .toList();
      }
      return [];
    } else {
      return [];
    }
  } catch (_) {
    return [];
  }
}

