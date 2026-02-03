import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';

class AuthService {
  static const String _usersKey = 'users';
  static const String _currentUserKey = 'currentUser';

  // Получить хэш пароля
  static String _hashPassword(String password) {
    return sha256.convert(password.codeUnits).toString();
  }

  // Регистрация нового пользователя
  static Future<bool> register(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();

    // Получить существующих пользователей
    final usersJson = prefs.getString(_usersKey) ?? '{}';
    final users = _parseUsers(usersJson);

    // Проверить, существует ли такой логин
    if (users.containsKey(username)) {
      return false; // Логин уже существует
    }

    // Сохранить нового пользователя с хэшированным паролем
    users[username] = _hashPassword(password);

    final success = await prefs.setString(_usersKey, _encodeUsers(users));
    return success;
  }

  // Вход пользователя
  static Future<bool> login(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();

    // Получить существующих пользователей
    final usersJson = prefs.getString(_usersKey) ?? '{}';
    final users = _parseUsers(usersJson);

    // Проверить наличие пользователя
    if (!users.containsKey(username)) {
      return false; // Логин не существует
    }

    // Проверить пароль
    final hashedPassword = _hashPassword(password);
    if (users[username] != hashedPassword) {
      return false; // Пароль неверный
    }

    // Сохранить текущего пользователя
    await prefs.setString(_currentUserKey, username);
    return true;
  }

  // Выход из учетной записи
  static Future<bool> logout() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.remove(_currentUserKey);
  }

  // Получить текущего пользователя
  static Future<String?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentUserKey);
  }

  // Проверить, авторизован ли пользователь
  static Future<bool> isLoggedIn() async {
    final user = await getCurrentUser();
    return user != null;
  }

  // Вспомогательный метод для парсинга пользователей
  static Map<String, String> _parseUsers(String json) {
    try {
      if (json.isEmpty || json == '{}') {
        return {};
      }
      // Простой парсинг JSON-подобной строки
      final map = <String, String>{};
      final pairs = json.replaceAll('{', '').replaceAll('}', '').split(',');
      for (final pair in pairs) {
        if (pair.isNotEmpty) {
          final parts = pair.split(':');
          if (parts.length == 2) {
            final key = parts[0].replaceAll('"', '').trim();
            final value = parts[1].replaceAll('"', '').trim();
            map[key] = value;
          }
        }
      }
      return map;
    } catch (e) {
      return {};
    }
  }

  // Вспомогательный метод для кодирования пользователей
  static String _encodeUsers(Map<String, String> users) {
    final pairs = users.entries.map((e) => '"${e.key}":"${e.value}"').toList();
    return '{${pairs.join(',')}}';
  }
}
