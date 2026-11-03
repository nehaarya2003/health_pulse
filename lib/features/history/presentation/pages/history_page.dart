import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/bloc_factory.dart';
import '../bloc/history_bloc.dart';
import '../bloc/history_event.dart';
import '../bloc/history_state.dart';
import '../widgets/chart_skeleton.dart';
import '../widgets/history_card.dart';
import '../widgets/staggered_item.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
      BlocFactory.createHistoryBloc()..add(LoadHistoryEvent()),
      child: const _HistoryView(),
    );
  }
}

class _HistoryView extends StatelessWidget {
  const _HistoryView();

  Future<void> _refresh(BuildContext context) async {
    final bloc = context.read<HistoryBloc>();
    // Subscribe first, then trigger, so we never miss the result
    final done = bloc.stream.firstWhere(
          (s) => s is HistoryLoaded || s is HistoryError,
    );
    bloc.add(LoadHistoryEvent());
    await done;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Health History',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                context.read<HistoryBloc>().add(LoadHistoryEvent()),
          ),
        ],
      ),
      body: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoading || state is HistoryInitial) {
            return const ChartSkeleton();
          }

          if (state is HistoryError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline,
                      size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(state.message),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => context
                        .read<HistoryBloc>()
                        .add(LoadHistoryEvent()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is HistoryLoaded) {
            return RefreshIndicator(
              onRefresh: () => _refresh(context),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                children: [
                  StaggeredItem(
                    index: 0,
                    child: _buildSummaryHeader(),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '7-Day Trends',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  for (var i = 0; i < state.histories.length; i++)
                    StaggeredItem(
                      index: i + 1,
                      child: HistoryCard(history: state.histories[i]),
                    ),
                  const SizedBox(height: 80),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSummaryHeader() {
    const green = Color(0xFF00C896);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [green.withOpacity(0.15), green.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: green.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today, color: green, size: 28),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Last 7 days',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                'Touch and drag on a chart for details',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}