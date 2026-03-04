class WatchedDomain {
  final String id;
  final String domain;
  final String label;
  final DateTime createdAt;
  final bool enabled;

  const WatchedDomain({
    required this.id,
    required this.domain,
    required this.label,
    required this.createdAt,
    this.enabled = true,
  });

  factory WatchedDomain.fromJson(Map<String, dynamic> json) {
    return WatchedDomain(
      id: json['id'] as String? ?? '',
      domain: json['domain'] as String? ?? '',
      label: json['label'] as String? ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      enabled: json['enabled'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'domain': domain,
      'label': label,
      'createdAt': createdAt.toIso8601String(),
      'enabled': enabled,
    };
  }
}

