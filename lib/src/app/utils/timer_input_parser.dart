/// Utility for parsing timer input (e.g., '8', '12:34') into seconds.
/// Returns null if input is invalid.
int? parseTimerInput(String value, {int maxSeconds = 3600}) {
  final text = value.trim();
  int? total;
  if (text.contains(':')) {
    final parts = text.split(':');
    if (parts.length == 2) {
      final min = int.tryParse(parts[0]);
      final sec = int.tryParse(parts[1]);
      if (min != null && sec != null && min >= 0 && sec >= 0 && sec < 60) {
        total = min * 60 + sec;
      }
    }
  } else {
    final min = int.tryParse(text);
    if (min != null && min >= 0) {
      total = min * 60;
    }
  }
  if (total != null) {
    if (total > maxSeconds) total = maxSeconds;
    return total;
  }
  return null;
}
