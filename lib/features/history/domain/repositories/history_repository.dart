import '../entities/health_history.dart';

abstract class HistoryRepository {
  Future<List<HealthHistory>> getHistory();
}