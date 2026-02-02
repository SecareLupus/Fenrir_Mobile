import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fenrir_mobile/services/auth_service.dart';
import 'package:fenrir_mobile/models/search_result.dart';

// Events
abstract class InventoryEvent {}
class SearchInventory extends InventoryEvent {
  final String query;
  SearchInventory(this.query);
}

// States
abstract class InventoryState {}
class InventoryInitial extends InventoryState {}
class InventoryLoading extends InventoryState {}
class InventoryLoaded extends InventoryState {
  final List<SearchResult> results;
  InventoryLoaded(this.results);
}
class InventoryError extends InventoryState {
  final String message;
  InventoryError(this.message);
}

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final AuthService _authService;

  InventoryBloc(this._authService) : super(InventoryInitial()) {
    on<SearchInventory>(_onSearchInventory);
  }

  Future<void> _onSearchInventory(SearchInventory event, Emitter<InventoryState> emit) async {
    emit(InventoryLoading());
    try {
      final client = await _authService.getApiClient();
      final results = await client.search(event.query);
      emit(InventoryLoaded(results));
    } catch (e) {
      emit(InventoryError(e.toString()));
    }
  }
}
