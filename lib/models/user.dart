class User {
  final String username;
  final String email;
  final DateTime registeredAt;
  final DateTime? lastLogin;
  final bool isActive;

  User({
    required this.username,
    required this.email,
    required this.registeredAt,
    this.lastLogin,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'registeredAt': registeredAt.toIso8601String(),
      'lastLogin': lastLogin?.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'] as String,
      email: json['email'] as String,
      registeredAt: DateTime.parse(json['registeredAt'] as String),
      lastLogin: json['lastLogin'] != null
          ? DateTime.parse(json['lastLogin'] as String)
          : null,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  User copyWith({
    String? username,
    String? email,
    DateTime? registeredAt,
    DateTime? lastLogin,
    bool? isActive,
  }) {
    return User(
      username: username ?? this.username,
      email: email ?? this.email,
      registeredAt: registeredAt ?? this.registeredAt,
      lastLogin: lastLogin ?? this.lastLogin,
      isActive: isActive ?? this.isActive,
    );
  }
}
