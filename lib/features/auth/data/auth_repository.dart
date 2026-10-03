import '../../../core/network/api_client.dart';
import '../domain/user_session.dart';

abstract interface class AuthRepository {
  Future<UserSession> register({required String name, required String phone});

  Future<UserSession> continueAsGuest();
}

class RemoteAuthRepository implements AuthRepository {
  const RemoteAuthRepository({required this.client});

  final ApiClient client;

  @override
  Future<UserSession> register({required String name, required String phone}) async {
    final response = await client.post(
      '/api/v1/auth/register',
      body: {'name': name, 'phone': phone},
    );
    return UserSession.fromJson(response);
  }

  @override
  Future<UserSession> continueAsGuest() async {
    final response = await client.post('/api/v1/auth/guest');
    return UserSession.fromJson(response);
  }
}
