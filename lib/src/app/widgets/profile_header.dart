import 'package:flutter/material.dart';
import 'package:mindease_app/src/app/utils/app_constants.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, this.photoUrl, this.displayName, this.email});
  final String? photoUrl;
  final String? displayName;
  final String? email;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      child: Row(
        children: [
          CircleAvatar(
            radius: AppSizes.avatarRadiusLarge,
            backgroundImage: photoUrl != null && photoUrl!.isNotEmpty
                ? NetworkImage(photoUrl!)
                : null,
            child: (photoUrl == null || photoUrl!.isEmpty)
                ? Icon(
                    Icons.person,
                    size: AppSizes.avatarIconSize,
                    color: theme.colorScheme.onSurface,
                  )
                : null,
          ),
          const SizedBox(width: AppSizes.spacingM),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                displayName ?? AppStrings.defaultUserName,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (email != null)
                Text(
                  email!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
