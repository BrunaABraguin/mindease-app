import 'package:flutter/material.dart';
import 'package:mindease_app/src/app/utils/app_constants.dart';

class ProfileSettingsSection extends StatelessWidget {
  const ProfileSettingsSection({
    super.key,
    required this.darkTheme,
    required this.showHelpIcons,
    required this.showAnimations,
    required this.onDarkThemeChanged,
    required this.onShowHelpIconsChanged,
    required this.onShowAnimationsChanged,
  });

  final bool darkTheme;
  final bool showHelpIcons;
  final bool showAnimations;
  final ValueChanged<bool> onDarkThemeChanged;
  final ValueChanged<bool> onShowHelpIconsChanged;
  final ValueChanged<bool> onShowAnimationsChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CONFIGURAÇÕES',
          style: theme.textTheme.labelMedium?.copyWith(
            letterSpacing: 1.2,
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            children: [
              _SettingsTile(
                icon: AppIcons.theme,
                title: 'Modo escuro',
                value: darkTheme,
                onChanged: onDarkThemeChanged,
              ),
              Divider(
                height: 1,
                color: colorScheme.outline.withValues(alpha: 0.15),
              ),
              _SettingsTile(
                icon: Icons.help_outline,
                title: 'Mostrar ícone de ajuda',
                value: showHelpIcons,
                onChanged: onShowHelpIconsChanged,
              ),
              Divider(
                height: 1,
                color: colorScheme.outline.withValues(alpha: 0.15),
              ),
              _SettingsTile(
                icon: Icons.animation_outlined,
                title: 'Mostrar animações',
                value: showAnimations,
                onChanged: onShowAnimationsChanged,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: colorScheme.onSurfaceVariant, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: colorScheme.secondary,
          ),
        ],
      ),
    );
  }
}
