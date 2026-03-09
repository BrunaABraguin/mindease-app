import 'package:mindease_app/src/app/utils/app_strings.dart';

String formatDuration(int? seconds) {
  if (seconds == null || seconds <= 0) return AppStrings.timerZeroDisplay;
  final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
  final secs = (seconds % 60).toString().padLeft(2, '0');
  return '$minutes:$secs';
}
