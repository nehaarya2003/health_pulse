import '../../domain/entities/health_history.dart';
import '../../domain/repositories/history_repository.dart';
import '../datasources/history_data_source.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryDataSource dataSource;

  HistoryRepositoryImpl(this.dataSource);

  @override
  Future<List<HealthHistory>> getHistory() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return dataSource.generateHistory();
  }
}