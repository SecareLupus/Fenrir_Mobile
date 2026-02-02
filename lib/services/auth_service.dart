import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:openid_client/openid_client_browser.dart' as openid;
import 'package:fenrir_mobile/api/export.dart';

class AuthService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String _tokenKey = 'fenrir_oidc_token';
  final String _baseUrlKey = 'fenrir_base_url';

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
  }

  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Placeholder for OIDC flow
  // In a real app, this would involve launching a browser or using a platform-specific plugin
  Future<void> loginWithOidc(String issuerUrl, String clientId) async {
    // This is a simplified OIDC flow for demonstration
    // Real implementation would use openid_client and url_launcher
    final issuer = await openid.Issuer.discover(Uri.parse(issuerUrl));
    final client = openid.Client(issuer, clientId);
    
    // For mobile, we would use a different approach (e.g., flutter_appauth)
    // but the spec mentioned verifying OIDC in a headless prototype first.
    // I'll implement a stub here and detailed logic later.
  }
}
