import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fenrir_mobile/services/auth_service.dart';
import 'package:fenrir_mobile/models/host_metrics.dart';

// Events
abstract class DashboardEvent {}
class FetchDashboardMetrics extends DashboardEvent {}

// States
abstract class DashboardState {}
class DashboardInitial extends DashboardState {}
class DashboardLoading extends DashboardState {}
class DashboardLoaded extends DashboardState {
  final HostMetrics metrics;
  final Map<String, dynamic> securityPosture;
  DashboardLoaded(this.metrics, this.securityPosture);
}
class DashboardError extends DashboardState {
  final String message;
  DashboardError(this.message);
}

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final AuthService _authService;

  DashboardBloc(this._authService) : super(DashboardInitial()) {
    on<FetchDashboardMetrics>(_onFetchDashboardMetrics);
  }

  Future<void> _onFetchDashboardMetrics(FetchDashboardMetrics event, Emitter<DashboardState> emit) async {
    emit(DashboardLoading());
    try {
      final client = await _authService.getApiClient();
      final metrics = await client.getGlobalMetrics();
      final security = await client.getSecurityPosture();

      if (metrics != null) {
        emit(DashboardLoaded(metrics, security));
      } else {
        emit(DashboardError("Failed to load metrics"));
      }
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }
}
