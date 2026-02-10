import 'package:flutter/material.dart';
import '../services/notification_service.dart';

class NotificationTestWidget extends StatelessWidget {
  const NotificationTestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            'Тестирование уведомлений',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              NotificationService().showNotification(
                id: 1,
                title: 'Предупреждение о фишинге',
                body:
                    'Обнаружена подозрительная ссылка в вашем письме. Будьте осторожны!',
                payload: 'phishing_alert',
              );
            },
            icon: const Icon(Icons.notifications),
            label: const Text('Показать уведомление'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () {
              NotificationService().showScheduledNotification(
                id: 2,
                title: 'Плановое уведомление',
                body: 'Это уведомление появится через 5 секунд',
                delay: const Duration(seconds: 5),
                payload: 'scheduled_alert',
              );
            },
            icon: const Icon(Icons.schedule),
            label: const Text('Плановое уведомление (5 сек)'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () {
              NotificationService().cancelAllNotifications();
            },
            icon: const Icon(Icons.clear),
            label: const Text('Отменить все уведомления'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
      ),
    );
  }
}
