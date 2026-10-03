import 'package:flutter_test/flutter_test.dart';

import 'package:cafemovil/features/auth/data/auth_repository.dart';
import 'package:cafemovil/features/auth/domain/user_session.dart';
import 'package:cafemovil/features/auth/presentation/auth_view_model.dart';

class FakeAuthRepository implements AuthRepository {
  String? registeredName;
  String? registeredPhone;

  @override
  Future<UserSession> register({required String name, required String phone}) async {
    registeredName = name;
    registeredPhone = phone;
    return UserSession(
      token: 'mock-token',
      user: AppUser(id: 'usr_1', name: name, phone: phone, isGuest: false),
    );
  }

  @override
  Future<UserSession> continueAsGuest() async {
    return const UserSession(
      token: 'guest-token',
      user: AppUser(id: 'gst_1', name: 'Guest', isGuest: true),
    );
  }
}

void main() {
  test('register trims required user data and stores the created session', () async {
    final repository = FakeAuthRepository();
    final viewModel = AuthViewModel(repository: repository);

    final session = await viewModel.register(name: ' Ana Cafetera ', phone: ' 3001234567 ');

    expect(repository.registeredName, 'Ana Cafetera');
    expect(repository.registeredPhone, '3001234567');
    expect(session.user.isGuest, isFalse);
    expect(viewModel.session, session);
    expect(viewModel.isAuthenticated, isTrue);
  });

  test('register rejects empty name or phone before calling backend', () async {
    final repository = FakeAuthRepository();
    final viewModel = AuthViewModel(repository: repository);

    await expectLater(
      viewModel.register(name: ' ', phone: '3001234567'),
      throwsA(isA<ArgumentError>()),
    );
    await expectLater(
      viewModel.register(name: 'Ana', phone: ' '),
      throwsA(isA<ArgumentError>()),
    );
    expect(repository.registeredName, isNull);
  });

  test('continueAsGuest stores a guest session', () async {
    final viewModel = AuthViewModel(repository: FakeAuthRepository());

    final session = await viewModel.continueAsGuest();

    expect(session.user.isGuest, isTrue);
    expect(viewModel.session, session);
    expect(viewModel.isAuthenticated, isTrue);
  });
}
