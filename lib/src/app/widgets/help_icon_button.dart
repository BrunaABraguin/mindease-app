import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mindease_app/src/app/pages/profile/profile_controller.dart';
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
    final showHelpIcons = context.select<ProfileCubit, bool>(
      (cubit) => cubit.state.preferences.showHelpIcons,
    );
    if (!showHelpIcons) return const SizedBox.shrink();

    return Semantics(
      label: 'Ajuda:',
      button: true,
      child: IconButton(
        icon: Icon(
          Icons.help_outline,
          color: Theme.of(context).iconTheme.color,
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
                  child: Text(
                    'Entendi',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
