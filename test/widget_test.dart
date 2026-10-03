import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cafemovil/app.dart';
import 'package:cafemovil/features/auth/data/auth_repository.dart';
import 'package:cafemovil/features/auth/domain/user_session.dart';
import 'package:cafemovil/features/home/data/catalog_repository.dart';
import 'package:cafemovil/features/home/domain/category.dart';
import 'package:cafemovil/features/home/domain/product.dart';

class FakeAuthRepository implements AuthRepository {
  @override
  Future<UserSession> register({required String name, required String phone}) async {
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

class FakeCatalogRepository implements CatalogRepository {
  @override
  Future<List<Category>> fetchCategories() async => const [
        Category(id: 'coffee', name: 'Café'),
        Category(id: 'books', name: 'Libros'),
      ];

  @override
  Future<List<Product>> fetchFeaturedProducts({String? categoryId, String? search}) async => const [
        Product(
          id: 'prd_001',
          name: 'Origen Sierra Nevada',
          brand: 'Devoción',
          categoryId: 'coffee',
          categoryName: 'Café',
          presentation: 'Libra 500g',
          price: 42900,
          featured: true,
        ),
      ];
}

void main() {
  testWidgets('guest user can enter and see home search categories and grid', (tester) async {
    await tester.pumpWidget(
      CafeMovilApp(
        authRepository: FakeAuthRepository(),
        catalogRepository: FakeCatalogRepository(),
      ),
    );

    expect(find.text('Café Móvil'), findsOneWidget);
    expect(find.text('Entrar como invitado'), findsOneWidget);

    await tester.tap(find.text('Entrar como invitado'));
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Café'), findsWidgets);
    expect(find.text('Origen Sierra Nevada'), findsOneWidget);
    expect(find.text('Devoción'), findsOneWidget);
  });

  testWidgets('registered user can submit name and phone and reach home', (tester) async {
    await tester.pumpWidget(
      CafeMovilApp(
        authRepository: FakeAuthRepository(),
        catalogRepository: FakeCatalogRepository(),
      ),
    );

    await tester.enterText(find.byKey(const ValueKey('nameField')), 'Ana Cafetera');
    await tester.enterText(find.byKey(const ValueKey('phoneField')), '3001234567');
    await tester.tap(find.text('Registrarme'));
    await tester.pumpAndSettle();

    expect(find.text('Hola, Ana Cafetera'), findsOneWidget);
    expect(find.text('Productos destacados'), findsOneWidget);
  });
}
