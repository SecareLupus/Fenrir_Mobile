import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:fenrir_mobile/models/host_metrics.dart';
import 'package:fenrir_mobile/models/search_result.dart';

final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 5,
    lineLength: 80,
    colors: true,
    printEmojis: true,
    printTime: false,
  ),
);

class ApiClient {
  late final Dio dio;
  final String baseUrl;

  ApiClient(this.baseUrl, {String? token}) {
    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        logger.i('REQUEST[${options.method}] => PATH: ${options.path}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        logger.i('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
        return handler.next(response);
      },
      onError: (err, handler) {
        logger.e('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
        return handler.next(err);
      },
    ));
  }

  Future<bool> checkHealth() async {
    try {
      final response = await dio.get('/api/v1/health');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<HostMetrics?> getGlobalMetrics() async {
    try {
      // In a real app, this might be a specialized dashboard endpoint
      // but we'll use a summary of metrics reported or the prometheus endpoint
      // Mocking response for Phase 2 as per OpenAPI components
      final response = await dio.get('/metrics'); // Or a specialized summary endpoint
      if (response.statusCode == 200) {
        // Since /metrics is text/plain, we mock the parsed result for the dashboard
        return HostMetrics(
          heartbeats: 156,
          load1: 0.45,
          load5: 0.38,
          load15: 0.41,
          activeSsh: 12,
        );
      }
    } catch (e) {
      logger.e('Failed to fetch metrics: $e');
    }
    return null;
  }

  Future<List<SearchResult>> search(String query) async {
    try {
      // For Phase 2, we return mock results to test the UI list rendering
      return [
        SearchResult(type: 'host', name: 'prod-web-01', url: '/hosts/1', info: 'Ubuntu 22.04 | Last seen 2m ago'),
        SearchResult(type: 'host', name: 'prod-db-01', url: '/hosts/2', info: 'Debian 12 | Last seen 5m ago'),
        SearchResult(type: 'user', name: 'admin-alice', url: '/users/1', info: 'Full Access'),
      ].where((e) => e.name.contains(query.toLowerCase())).toList();
    } catch (e) {
      logger.e('Search failed: $e');
    }
    return [];
  }

  Future<Map<String, dynamic>> getSecurityPosture() async {
    try {
      // /admin/security returns HTML in OpenAPI, but we'll assume an API equivalent or parse summary
      // For mobile, we'll mock the health status
      return {
        'status': 'healthy',
        'alerts': 0,
        'last_krl_update': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return {'status': 'unknown'};
    }
  }
}
