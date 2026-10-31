import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/health_history.dart';

class HealthChart extends StatefulWidget {
  final HealthHistory history;
  final Color color;

  const HealthChart({
    super.key,
    required this.history,
    required this.color,
  });

  @override
  State<HealthChart> createState() => _HealthChartState();
}

class _HealthChartState extends State<HealthChart> {
  // false = flat line at the bottom, true = real data.
  // Flipping this after the first frame makes fl_chart animate the line
  // "growing" up into place.
  bool _revealed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _revealed = true);
    });
  }

  List<HealthReading> get _readings => widget.history.readings;

  double get _pad {
    final range = widget.history.max - widget.history.min;
    return range == 0 ? 1.0 : range * 0.3;
  }

  double get _minY => (widget.history.min - _pad).floorToDouble();
  double get _maxY => (widget.history.max + _pad).ceilToDouble();

  List<FlSpot> get _spots => [
    for (var i = 0; i < _readings.length; i++)
      FlSpot(
        i.toDouble(),
        _revealed ? _readings[i].value : _minY,
      ),
  ];

  @override
  Widget build(BuildContext context) {
    if (_readings.isEmpty) return const SizedBox.shrink();

    final interval = (_maxY - _minY) / 4;
    final average = widget.history.average;
    final color = widget.color;

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: _readings.length > 1 ? (_readings.length - 1).toDouble() : 1,
        minY: _minY,
        maxY: _maxY,
        clipData: const FlClipData.all(),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: interval,
          getDrawingHorizontalLine: (_) => FlLine(
            color: Colors.grey.withOpacity(0.15),
            strokeWidth: 1,
          ),
        ),

        // Dashed average line
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(
              y: average,
              color: color.withOpacity(0.5),
              strokeWidth: 1,
              dashArray: [6, 4],
              label: HorizontalLineLabel(
                show: true,
                alignment: Alignment.topRight,
                style: TextStyle(
                  fontSize: 10,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
                labelResolver: (_) => 'avg ${average.toStringAsFixed(0)}',
              ),
            ),
          ],
        ),

        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: interval,
              getTitlesWidget: (value, meta) {
                // Hide the very top/bottom labels so they don't clip
                if (value == meta.min || value == meta.max) {
                  return const SizedBox.shrink();
                }
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 24,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (value != index.toDouble() ||
                    index < 0 ||
                    index >= _readings.length) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    DateFormat('E').format(_readings[index].timestamp),
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade500,
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        // Touch: dashed guide line + big dot + day/value tooltip
        lineTouchData: LineTouchData(
          handleBuiltInTouches: true,
          getTouchedSpotIndicator: (barData, indexes) {
            return indexes.map((_) {
              return TouchedSpotIndicatorData(
                FlLine(
                  color: color.withOpacity(0.4),
                  strokeWidth: 1.5,
                  dashArray: [4, 4],
                ),
                FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, bar, index) =>
                      FlDotCirclePainter(
                        radius: 6,
                        color: Colors.white,
                        strokeWidth: 3,
                        strokeColor: color,
                      ),
                ),
              );
            }).toList();
          },
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => color,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final i = spot.x.toInt();
                final day = (i >= 0 && i < _readings.length)
                    ? DateFormat('EEE d MMM').format(_readings[i].timestamp)
                    : '';
                return LineTooltipItem(
                  '$day\n',
                  const TextStyle(color: Colors.white70, fontSize: 10),
                  children: [
                    TextSpan(
                      text: spot.y.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                );
              }).toList();
            },
          ),
        ),

        lineBarsData: [
          LineChartBarData(
            spots: _spots,
            isCurved: true,
            curveSmoothness: 0.35,
            preventCurveOverShooting: true,
            barWidth: 3,
            isStrokeCapRound: true,
            gradient: LinearGradient(
              colors: [color.withOpacity(0.55), color],
            ),
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, bar, index) =>
                  FlDotCirclePainter(
                    radius: 3.5,
                    color: color,
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  ),
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.28),
                  color.withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
    );
  }
}