import 'package:equatable/equatable.dart';
import '../../domain/entities/health_history.dart';

abstract class HistoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<HealthHistory> histories;

  HistoryLoaded(this.histories);

  @override
  List<Object?> get props => [histories];
}

class HistoryError extends HistoryState {
  final String message;

  HistoryError(this.message);

  @override
  List<Object?> get props => [message];
}