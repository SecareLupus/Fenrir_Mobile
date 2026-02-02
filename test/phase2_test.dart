import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fenrir_mobile/main.dart';
import 'package:fenrir_mobile/services/auth_service.dart';
import 'package:fenrir_mobile/blocs/auth_bloc.dart';
import 'package:fenrir_mobile/blocs/dashboard_bloc.dart';
import 'package:fenrir_mobile/blocs/inventory_bloc.dart';
import 'package:fenrir_mobile/widgets/stats_card.dart';
import 'package:fenrir_mobile/api/manual_client.dart';
import 'package:fenrir_mobile/models/host_metrics.dart';
import 'package:fenrir_mobile/models/search_result.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MockApiClient extends ApiClient {
  MockApiClient() : super("http://localhost:8080");

  @override
  Future<bool> checkHealth() async => true;

  @override
  Future<HostMetrics?> getGlobalMetrics() async {
    return HostMetrics(
      heartbeats: 156,
      activeSsh: 12,
      load1: 0.45,
      load5: 0.38,
      load15: 0.41,
    );
  }

  @override
  Future<List<SearchResult>> search(String query) async {
    return [
      SearchResult(type: 'host', name: 'prod-web-01', url: '/hosts/1', info: 'Ubuntu 22.04'),
      SearchResult(type: 'host', name: 'prod-db-01', url: '/hosts/2', info: 'Debian 12'),
      SearchResult(type: 'user', name: 'admin-alice', url: '/users/1', info: 'Full Access'),
    ].where((e) => e.name.contains(query.toLowerCase())).toList();
  }

  @override
  Future<Map<String, dynamic>> getSecurityPosture() async {
    return {'status': 'healthy', 'last_krl_update': '2026-02-02T12:00:00Z'};
  }
}

class MockAuthServicePhase2 extends AuthService {
  final ApiClient mockClient;
  MockAuthServicePhase2(this.mockClient);

  @override
  Future<bool> isAuthenticated() async => true;
  
  @override
  Future<String?> getToken() async => "mock_token";

  @override
  Future<ApiClient> getApiClient() async => mockClient;
}

void main() {
  testWidgets('Dashboard renders metrics cards', (WidgetTester tester) async {
    final mockClient = MockApiClient();
    final authService = MockAuthServicePhase2(mockClient);
    
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthBloc(authService)..add(AppStarted())),
          BlocProvider(create: (context) => DashboardBloc(authService)),
          BlocProvider(create: (context) => InventoryBloc(authService)),
        ],
        child: const MyApp(),
      ),
    );

    // Initial pump to trigger auth logic
    await tester.pump();
    
    // In our AuthWrapper, AuthAuthenticated (isAuthenticated=true) leads to MainNavigationScreen
    // But AuthBloc triggers AuthBiometricRequired first if isAuthenticated is true.
    // Let's force AuthAuthenticated for this test by adding the event manually or mocking more.
    
    final authBloc = tester.element(find.byType(MyApp)).read<AuthBloc>();
    authBloc.emit(AuthAuthenticated("mock_token"));
    
    await tester.pumpAndSettle();

    // Verify NOC screen title
    expect(find.text('Fenrir NOC'), findsOneWidget);
    
    // Check for StatsCards
    expect(find.byType(StatsCard), findsNWidgets(4));
    expect(find.text('ACTIVE SSH'), findsOneWidget);
    expect(find.text('LOAD (1M)'), findsOneWidget);
    
    // Check for security posture container
    expect(find.textContaining('Security Posture:'), findsOneWidget);
  });

  testWidgets('Inventory search filters results', (WidgetTester tester) async {
    final mockClient = MockApiClient();
    final authService = MockAuthServicePhase2(mockClient);
    
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthBloc(authService)..add(AppStarted())),
          BlocProvider(create: (context) => DashboardBloc(authService)),
          BlocProvider(create: (context) => InventoryBloc(authService)),
        ],
        child: const MyApp(),
      ),
    );

    final authBloc = tester.element(find.byType(MyApp)).read<AuthBloc>();
    authBloc.emit(AuthAuthenticated("mock_token"));
    await tester.pumpAndSettle();

    // Switch to Fleet tab
    await tester.tap(find.byIcon(Icons.dns_outlined));
    await tester.pumpAndSettle();

    // Verify SearchBar exists
    expect(find.byType(SearchBar), findsOneWidget);
    
    // Since SearchBar might contain multiple TextFields or other elements, we hunt for the first one
    await tester.enterText(find.byType(TextField).first, 'prod');
    await tester.pumpAndSettle();
    
    // Verify results show up
    expect(find.text('prod-web-01'), findsOneWidget);
    expect(find.text('prod-db-01'), findsOneWidget);
    expect(find.text('admin-alice'), findsNothing); // Filtered out
  });
}
