import 'package:flutter/material.dart';
import 'package:mindease_app/src/app/utils/app_constants.dart';

class TimerControlButtons extends StatelessWidget {
  const TimerControlButtons({
    super.key,
    required this.onStartPause,
    required this.onReset,
    this.isRunning = false,
  });
  final VoidCallback onStartPause;
  final VoidCallback onReset;
  final bool isRunning;

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
      minimumSize: const Size(
        AppSizes.buttonMinWidthMedium,
        AppSizes.buttonHeightMedium,
      ),
      backgroundColor: Theme.of(context).colorScheme.secondary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.buttonHeightLarge),
      ),
      textStyle: const TextStyle(fontWeight: FontWeight.w600),
      elevation: 0,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Semantics(
            label: 'Reiniciar o temporizador',
            button: true,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.restart_alt),
              label: const Text('Reiniciar'),
              style: style.copyWith(
                minimumSize: WidgetStateProperty.all(
                  const Size.fromHeight(AppSizes.buttonHeightLarge),
                ),
                padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(vertical: AppSizes.paddingL),
                ),
              ),
              onPressed: onReset,
            ),
          ),
        ),
        const SizedBox(width: AppSizes.spacingL),
        Expanded(
          child: Semantics(
            label: isRunning
                ? 'Pausar o temporizador'
                : 'Iniciar o temporizador',
            button: true,
            child: ElevatedButton.icon(
              icon: Icon(isRunning ? Icons.pause : Icons.play_arrow),
              label: Text(isRunning ? 'Parar' : 'Iniciar'),
              style: style.copyWith(
                minimumSize: WidgetStateProperty.all(
                  const Size.fromHeight(AppSizes.buttonHeightLarge),
                ),
                padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(vertical: AppSizes.paddingL),
                ),
              ),
              onPressed: onStartPause,
            ),
          ),
        ),
      ],
    );
  }
}
