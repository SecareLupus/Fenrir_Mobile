// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fenrir_mobile/main.dart';
import 'package:fenrir_mobile/services/auth_service.dart';
import 'package:fenrir_mobile/blocs/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MockAuthService extends AuthService {
  @override
  Future<bool> isAuthenticated() async => false;
}

void main() {
  testWidgets('App starts at login screen', (WidgetTester tester) async {
    final authService = MockAuthService();
    final authBloc = AuthBloc(authService);
    
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      BlocProvider<AuthBloc>(
        create: (context) => authBloc..add(AppStarted()),
        child: const MyApp(),
      ),
    );

    // Initial pump to trigger AppStarted and state changes
    // We use pumpAndSettle to wait for all animations and async operations (like the mock delay)
    await tester.pumpAndSettle();

    // Verify that the login screen is shown
    expect(find.text('Fenrir Admin Login'), findsOneWidget);
    
    // Verify that the Issuer URL and Client ID fields exist
    expect(find.text('Issuer URL'), findsOneWidget);
    expect(find.text('Client ID'), findsOneWidget);
    
    // Verify the login button exists
    expect(find.text('Login with OIDC'), findsOneWidget);
  });
}
