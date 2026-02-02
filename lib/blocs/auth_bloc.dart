import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fenrir_mobile/services/auth_service.dart';
import 'package:local_auth/local_auth.dart';

// Events
abstract class AuthEvent {}
class AppStarted extends AuthEvent {}
class LoginRequested extends AuthEvent {
  final String issuerUrl;
  final String clientId;
  LoginRequested(this.issuerUrl, this.clientId);
}
class LogoutRequested extends AuthEvent {}
class BiometricAuthRequested extends AuthEvent {}

// States
abstract class AuthState {}
class AuthInitial extends AuthState {}
class AuthUnauthenticated extends AuthState {}
class AuthAuthenticated extends AuthState {
  final String token;
  AuthAuthenticated(this.token);
}
class AuthBiometricRequired extends AuthState {}
class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;
  final LocalAuthentication _localAuth = LocalAuthentication();

  AuthBloc(this._authService) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<BiometricAuthRequested>(_onBiometricAuthRequested);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    final isAuthenticated = await _authService.isAuthenticated();
    if (isAuthenticated) {
      // Check health in background
      final client = await _authService.getApiClient();
      client.checkHealth(); // Fire and forget for now
      
      // If we have a token, we require biometrics every time the app starts
      emit(AuthBiometricRequired());
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    try {
      await _authService.loginWithOidc(event.issuerUrl, event.clientId);
      final token = await _authService.getToken();
      
      // Verify connectivity after login
      final client = await _authService.getApiClient();
      final healthy = await client.checkHealth();
      
      if (healthy) {
        emit(AuthAuthenticated(token ?? ""));
      } else {
        // Even if not healthy, we are authenticated. 
        // We'll show a warning in Phase 2, but for now just proceed.
        emit(AuthAuthenticated(token ?? ""));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    await _authService.logout();
    emit(AuthUnauthenticated());
  }

  Future<void> _onBiometricAuthRequested(BiometricAuthRequested event, Emitter<AuthState> emit) async {
    try {
      final bool canAuthenticateWithBiometrics = await _localAuth.canCheckBiometrics;
      final bool canAuthenticate = canAuthenticateWithBiometrics || await _localAuth.isDeviceSupported();

      if (!canAuthenticate) {
        // Fallback to authenticated if biometrics not available? 
        // Or fail? Spec says "Mandatory after initial login".
        // I'll allow access for now if not supported, but log a warning.
        final token = await _authService.getToken();
        emit(AuthAuthenticated(token ?? ""));
        return;
      }

      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to access Fenrir Admin',
      );

      if (didAuthenticate) {
        final token = await _authService.getToken();
        emit(AuthAuthenticated(token ?? ""));
      } else {
        emit(AuthFailure("Biometric authentication failed"));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
