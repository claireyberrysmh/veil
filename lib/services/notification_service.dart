import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;

import '../screens/alert_detail_screen.dart';
import 'alert_repository.dart';
import 'navigation_service.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  Future<void> init() async {
    tzdata.initializeTimeZones();

    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: androidInitializationSettings,
          iOS: iosInitializationSettings,
        );

    await _notificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Запросить разрешение на уведомления для Android 13+
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  // Обработка клика на уведомление
  void _onNotificationTap(NotificationResponse notificationResponse) {
    final payload = notificationResponse.payload;
    if (payload == null || payload.isEmpty) {
      return;
    }

    final navigator = NavigationService.navigatorKey.currentState;
    if (navigator == null) return;

    _openAlertFromPayload(navigator, payload);
  }

  Future<void> _openAlertFromPayload(
    NavigatorState navigator,
    String payload,
  ) async {
    // Ожидаем payload вида 'alert:<id>'
    if (!payload.startsWith('alert:')) return;
    final id = payload.substring('alert:'.length);
    if (id.isEmpty) return;

    final alert = await AlertRepository.getAlertById(id);
    if (alert == null) return;

    navigator.push(
      MaterialPageRoute(
        builder: (_) => AlertDetailScreen(alert: alert),
      ),
    );
  }

  // Показать простое уведомление
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'phishing_alerts',
          'Phishing Alerts',
          channelDescription: 'Notifications about phishing threats',
          importance: Importance.high,
          priority: Priority.high,
          showWhen: true,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
      payload: payload,
    );
  }

  // Показать уведомление через определённое время
  Future<void> showScheduledNotification({
    required int id,
    required String title,
    required String body,
    required Duration delay,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'phishing_alerts',
          'Phishing Alerts',
          channelDescription: 'Notifications about phishing threats',
          importance: Importance.high,
          priority: Priority.high,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.now(tz.local).add(delay),
      notificationDetails: notificationDetails,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: payload,
    );
  }

  // Отменить уведомление
  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id: id);
  }

  // Отменить все уведомления
  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }
}
