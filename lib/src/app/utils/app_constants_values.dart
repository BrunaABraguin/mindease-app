class AppConstants {
  AppConstants._();

  // Timer blink logic
  static const double blinkThreshold = 0.5;
  static const double blinkMinOpacity = 0.2;
  static const int blinkAnimationDurationMs = 600;
  static const int timerMaxMinutes = 60;
  static const int timerMaxSeconds =
      timerMaxMinutes * Duration.secondsPerMinute;

  static const String kPrefsKeyUserPreferences = 'user_preferences';
}
