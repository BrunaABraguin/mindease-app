import 'package:flutter/material.dart';
import 'package:mindease_app/src/app/utils/app_constants.dart';

class HelpIconButton extends StatelessWidget {
  const HelpIconButton({
    super.key,
    required this.title,
    required this.description,
    this.size = AppSizes.iconExtraSmall,
  });

  final String title;
  final String description;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.help_outline,
        color: Theme.of(context).colorScheme.primary,
        size: size,
      ),
      tooltip: 'Ajuda',
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(description),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Entendi'),
              ),
            ],
          ),
        );
      },
    );
  }
}
