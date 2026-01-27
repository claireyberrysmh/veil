import 'package:http/http.dart' as http;
import 'dart:convert';

/// Пример получения данных из PhishStats API
Future<void> fetchPhishingData() async {
  try {
    // Запрос последнего поста с сортировкой по дате
    final response = await http.get(
      Uri.parse('https://api.phishstats.info/api/phishing?_sort=-date&_size=1'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Получаем первый результат
      if (data.isNotEmpty) {
        final post = data[0];

        print('=== PhishStats API Result ===');
        print('ID: ${post['id']}');
        print('Заголовок: ${post['title']}');
        print('URL: ${post['url']}');
        print('Страна: ${post['countrycode']}');
        print('Оценка: ${post['score']}');
        print('Дата: ${post['date']}');
        print('IP: ${post['ip']}');
        print('TLD: ${post['tld']}');
      }
    } else {
      print('Ошибка: ${response.statusCode}');
    }
  } catch (e) {
    print('Ошибка сети: $e');
  }
}
