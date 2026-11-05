import 'package:equatable/equatable.dart';

enum InsightSource { gemini, offline }

class CoachInsight extends Equatable {
  final String text;
  final DateTime generatedAt;
  final InsightSource source;

  /// Why we fell back to offline mode (null when Gemini answered).
  final String? fallbackReason;

  const CoachInsight({
    required this.text,
    required this.generatedAt,
    required this.source,
    this.fallbackReason,
  });

  @override
  List<Object?> get props => [text, generatedAt, source, fallbackReason];
}