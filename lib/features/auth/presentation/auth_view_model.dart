import 'package:flutter/foundation.dart';

import '../data/auth_repository.dart';
import '../domain/user_session.dart';

class AuthViewModel extends ChangeNotifier {
  AuthViewModel({required this.repository});

  final AuthRepository repository;
  UserSession? _session;
  bool _isLoading = false;
  String? _errorMessage;

  UserSession? get session => _session;
  bool get isAuthenticated => _session != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<UserSession> register({required String name, required String phone}) async {
    final cleanName = name.trim();
    final cleanPhone = phone.trim();
    if (cleanName.isEmpty || cleanPhone.isEmpty) {
      throw ArgumentError('Name and phone are required');
    }
    return _runAuth(() => repository.register(name: cleanName, phone: cleanPhone));
  }

  Future<UserSession> continueAsGuest() {
    return _runAuth(repository.continueAsGuest);
  }

  Future<UserSession> _runAuth(Future<UserSession> Function() action) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final createdSession = await action();
      _session = createdSession;
      return createdSession;
    } catch (error) {
      _errorMessage = error.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
