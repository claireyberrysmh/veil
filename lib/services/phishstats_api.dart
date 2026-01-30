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

/// Получает последний пост из PhishStats (или null при ошибке)
Future<PhishPost?> fetchLatestPhishingPost() async {
  try {
    final response = await http.get(
      Uri.parse('https://api.phishstats.info/api/phishing?_sort=-date&_size=1'),
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
