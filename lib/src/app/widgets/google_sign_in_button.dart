import 'package:flutter/material.dart';
import 'package:mindease_app/src/app/utils/app_assets.dart';
import 'package:mindease_app/src/app/utils/app_sizes.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });
  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingM,
          vertical: AppSizes.paddingS,
        ),
        side: BorderSide(
          color: colorScheme.outline.withValues(alpha: AppSizes.opacityHeavy),
        ),
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.spacingS),
        ),
      ),
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AppAssets.googleLogo,
                  width: AppSizes.iconSmall,
                  height: AppSizes.iconSmall,
                  errorBuilder: (_, _, _) =>
                      const Icon(Icons.g_mobiledata, size: AppSizes.iconSmall),
                ),
                const SizedBox(width: AppSizes.spacingS),
                Expanded(
                  child: Text(
                    'Sincronizar com o Google',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: AppSizes.navFontSize,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
