import 'dart:convert';
import 'dart:io';

abstract interface class ApiClient {
  Future<Map<String, Object?>> get(String path, {Map<String, String>? queryParameters});

  Future<Map<String, Object?>> post(String path, {Map<String, Object?>? body});
}

class HttpApiClient implements ApiClient {
  HttpApiClient({required this.baseUrl, HttpClient? httpClient}) : _httpClient = httpClient ?? HttpClient();

  final String baseUrl;
  final HttpClient _httpClient;

  @override
  Future<Map<String, Object?>> get(String path, {Map<String, String>? queryParameters}) {
    return _send('GET', path, queryParameters: queryParameters);
  }

  @override
  Future<Map<String, Object?>> post(String path, {Map<String, Object?>? body}) {
    return _send('POST', path, body: body);
  }

  Future<Map<String, Object?>> _send(
    String method,
    String path, {
    Map<String, String>? queryParameters,
    Map<String, Object?>? body,
  }) async {
    final base = Uri.parse(baseUrl);
    final uri = base.replace(
      path: _joinPaths(base.path, path),
      queryParameters: queryParameters?.isEmpty ?? true ? null : queryParameters,
    );
    final request = await _httpClient.openUrl(method, uri);
    request.headers.contentType = ContentType.json;
    if (body != null) {
      request.write(jsonEncode(body));
    }

    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();
    final decoded = responseBody.isEmpty ? <String, Object?>{} : jsonDecode(responseBody);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = decoded is Map<String, Object?> ? decoded['error']?.toString() : null;
      throw ApiException(message ?? 'Request failed with status ${response.statusCode}');
    }
    if (decoded is Map<String, Object?>) {
      return decoded;
    }
    throw const ApiException('Unexpected API response format');
  }

  String _joinPaths(String basePath, String path) {
    final normalizedBase = basePath.endsWith('/') ? basePath.substring(0, basePath.length - 1) : basePath;
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    return '$normalizedBase$normalizedPath';
  }
}

class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}
