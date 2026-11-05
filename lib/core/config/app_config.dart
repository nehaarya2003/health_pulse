class AppConfig {
  /// Injected at run time with --dart-define, never written in code.
  static const String geminiApiKey =
  String.fromEnvironment('GEMINI_API_KEY');
}