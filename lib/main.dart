import 'package:flutter/material.dart';

import 'app.dart';
import 'core/network/api_client.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/home/data/catalog_repository.dart';

const _defaultApiBaseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: 'http://10.0.2.2:8080');

void main() {
  final apiClient = HttpApiClient(baseUrl: _defaultApiBaseUrl);
  runApp(
    CafeMovilApp(
      authRepository: RemoteAuthRepository(client: apiClient),
      catalogRepository: RemoteCatalogRepository(client: apiClient),
    ),
  );
}
