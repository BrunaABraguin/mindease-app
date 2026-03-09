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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        side: BorderSide(
          color: colorScheme.outline.withValues(alpha: AppSizes.opacityHeavy),
        ),
        backgroundColor: colorScheme.surface,
      ),
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  AppAssets.googleLogo,
                  width: AppSizes.buttonMinWidthMedium,
                  height: AppSizes.buttonHeightMedium,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.g_mobiledata, size: AppSizes.iconMedium),
                ),
                const SizedBox(width: AppSizes.spacingXl),
                Expanded(
                  child: Text(
                    'Entrar com Google',
                    style: TextStyle(
                      fontSize: AppSizes.timerFontSize,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
    );
  }
}
