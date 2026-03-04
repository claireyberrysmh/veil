class Alert {
  final String id;
  final String title;
  final String severity; // e.g. 'high', 'medium', 'low'
  final String timeAgo;
  final String summary;
  final Map<String, String> details;
  final List<String> recommendations;
  final bool isResolved;
  final String type; // e.g. 'breach', 'password', 'login'
  final DateTime timestamp;

  const Alert({
    required this.id,
    required this.title,
    required this.severity,
    required this.timeAgo,
    required this.summary,
    required this.details,
    required this.recommendations,
    this.isResolved = false,
    this.type = '',
    required this.timestamp,
  });

  Alert copyWith({
    String? id,
    String? title,
    String? severity,
    String? timeAgo,
    String? summary,
    Map<String, String>? details,
    List<String>? recommendations,
    bool? isResolved,
    String? type,
    DateTime? timestamp,
  }) {
    return Alert(
      id: id ?? this.id,
      title: title ?? this.title,
      severity: severity ?? this.severity,
      timeAgo: timeAgo ?? this.timeAgo,
      summary: summary ?? this.summary,
      details: details ?? this.details,
      recommendations: recommendations ?? this.recommendations,
      isResolved: isResolved ?? this.isResolved,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      severity: json['severity'] as String? ?? 'low',
      timeAgo: json['timeAgo'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      details: (json['details'] as Map<String, dynamic>? ?? {})
          .map((key, value) => MapEntry(key, value.toString())),
      recommendations: (json['recommendations'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      isResolved: json['isResolved'] as bool? ?? false,
      type: json['type'] as String? ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'severity': severity,
      'timeAgo': timeAgo,
      'summary': summary,
      'details': details,
      'recommendations': recommendations,
      'isResolved': isResolved,
      'type': type,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

const List<Alert> mockAlerts = [
  Alert(
    id: '1',
    title: 'Email breach detected',
    severity: 'high',
    timeAgo: '2 hours ago',
    summary: 'Your email appeared in a recent data breach.',
    details: {
      'Affected Email': 'user@example.com',
      'Breach Source': 'Unknown database',
      'Data Exposed': 'Email, password hash',
    },
    recommendations: [
      'Change your password on the affected service.',
      'Enable two-factor authentication.',
      'Monitor your accounts for suspicious activity.',
    ],
    isResolved: false,
    type: 'breach',
  ),
  Alert(
    id: '2',
    title: 'Weak password detected',
    severity: 'medium',
    timeAgo: '1 day ago',
    summary: 'One of your saved passwords is considered weak.',
    details: {
      'Account': 'Social media account',
      'Password Strength': 'Weak',
      'Risk': 'Higher chance of unauthorized access',
    },
    recommendations: [
      'Update the password to a strong, unique one.',
      'Avoid reusing passwords across sites.',
    ],
    isResolved: false,
    type: 'password',
  ),
  Alert(
    id: '3',
    title: 'New login from unknown device',
    severity: 'high',
    timeAgo: '3 days ago',
    summary: 'We detected a login from a device you haven’t used before.',
    details: {
      'Location': 'London, UK',
      'Device': 'Chrome on Windows',
      'Time': '3 days ago',
    },
    recommendations: [
      'Confirm whether this login was you.',
      'If not, change your password immediately.',
      'Review recent activity on your account.',
    ],
    isResolved: true,
    type: 'login',
  ),
];

