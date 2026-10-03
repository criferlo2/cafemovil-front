import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:cafemovil/core/network/api_client.dart';
import 'package:cafemovil/features/auth/data/auth_repository.dart';
import 'package:cafemovil/features/home/data/catalog_repository.dart';

class FakeApiClient implements ApiClient {
  Uri? lastUri;
  Map<String, Object?>? lastBody;

  @override
  Future<Map<String, Object?>> get(String path, {Map<String, String>? queryParameters}) async {
    lastUri = Uri(path: path, queryParameters: queryParameters);
    if (path == '/api/v1/categories') {
      return {
        'data': [
          {'id': 'coffee', 'name': 'Café'},
        ],
      };
    }
    return {
      'data': [
        {
          'id': 'prd_001',
          'name': 'Origen Sierra Nevada',
          'brand': 'Devoción',
          'categoryId': 'coffee',
          'categoryName': 'Café',
          'presentation': 'Libra 500g',
          'price': 42900,
          'featured': true,
        },
      ],
    };
  }

  @override
  Future<Map<String, Object?>> post(String path, {Map<String, Object?>? body}) async {
    lastUri = Uri(path: path);
    lastBody = body;
    return jsonDecode('''{
      "token":"mock-token",
      "user":{"id":"usr_1","name":"Ana Cafetera","phone":"3001234567","guest":false}
    }''') as Map<String, Object?>;
  }
}

void main() {
  test('remote auth repository posts register payload expected by backend', () async {
    final client = FakeApiClient();
    final repository = RemoteAuthRepository(client: client);

    final session = await repository.register(name: 'Ana Cafetera', phone: '3001234567');

    expect(client.lastUri!.path, '/api/v1/auth/register');
    expect(client.lastBody, {'name': 'Ana Cafetera', 'phone': '3001234567'});
    expect(session.user.name, 'Ana Cafetera');
  });

  test('remote catalog repository sends category and search filters to featured endpoint', () async {
    final client = FakeApiClient();
    final repository = RemoteCatalogRepository(client: client);

    final products = await repository.fetchFeaturedProducts(categoryId: 'coffee', search: 'devocion');

    expect(client.lastUri!.path, '/api/v1/products/featured');
    expect(client.lastUri!.queryParameters, {'category': 'coffee', 'search': 'devocion'});
    expect(products.single.price, 42900);
  });
}
