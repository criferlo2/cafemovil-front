class AppUser {
  const AppUser({
    required this.id,
    required this.name,
    required this.isGuest,
    this.phone,
  });

  factory AppUser.fromJson(Map<String, Object?> json) {
    return AppUser(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString(),
      isGuest: json['guest'] == true,
    );
  }

  final String id;
  final String name;
  final String? phone;
  final bool isGuest;
}

class UserSession {
  const UserSession({required this.token, required this.user});

  factory UserSession.fromJson(Map<String, Object?> json) {
    return UserSession(
      token: json['token']?.toString() ?? '',
      user: AppUser.fromJson(json['user'] as Map<String, Object?>),
    );
  }

  final String token;
  final AppUser user;
}
