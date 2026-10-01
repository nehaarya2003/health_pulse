import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_history_usecase.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GetHistoryUseCase getHistoryUseCase;

  HistoryBloc({required this.getHistoryUseCase})
      : super(HistoryInitial()) {
    on<LoadHistoryEvent>(_onLoadHistory);
  }

  Future<void> _onLoadHistory(
      LoadHistoryEvent event,
      Emitter<HistoryState> emit,
      ) async {
    emit(HistoryLoading());
    try {
      final histories = await getHistoryUseCase();
      emit(HistoryLoaded(histories));
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }
}