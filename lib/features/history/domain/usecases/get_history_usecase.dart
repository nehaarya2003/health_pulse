import '../entities/health_history.dart';
import '../repositories/history_repository.dart';

class GetHistoryUseCase {
  final HistoryRepository repository;

  GetHistoryUseCase(this.repository);

  Future<List<HealthHistory>> call() => repository.getHistory();
}