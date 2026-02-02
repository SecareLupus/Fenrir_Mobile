import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fenrir_mobile/api/manual_client.dart';

class AuthService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String _tokenKey = 'fenrir_oidc_token';
  final String _baseUrlKey = 'fenrir_base_url';
  
  ApiClient? _apiClient;

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> saveBaseUrl(String baseUrl) async {
    await _storage.write(key: _baseUrlKey, value: baseUrl);
  }

  Future<String?> getBaseUrl() async {
    return await _storage.read(key: _baseUrlKey);
  }

  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
    _apiClient = null;
  }

  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<ApiClient> getApiClient() async {
    if (_apiClient != null) return _apiClient!;
    
    final baseUrl = await getBaseUrl() ?? "http://localhost:8080";
    final token = await getToken();
    _apiClient = ApiClient(baseUrl, token: token);
    return _apiClient!;
  }

  Future<void> loginWithOidc(String issuerUrl, String clientId) async {
    // For Phase 1, we will mock the successful login after a simulated delay
    await Future.delayed(const Duration(seconds: 1));
    await saveToken("mock_token_${DateTime.now().millisecondsSinceEpoch}");
    await saveBaseUrl(issuerUrl); // Using issuerUrl as placeholder for backend base
  }
}
