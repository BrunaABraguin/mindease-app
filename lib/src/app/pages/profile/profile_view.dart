import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mindease_app/src/app/pages/profile/profile_controller.dart';
import 'package:mindease_app/src/app/pages/profile/widgets/profile_statistics_section.dart';
import 'package:mindease_app/src/app/utils/app_constants.dart';
import 'package:mindease_app/src/app/widgets/google_sign_in_button.dart';
import 'package:mindease_app/src/app/widgets/profile_header.dart';
import 'package:mindease_app/src/app/widgets/profile_settings_section.dart';
import 'package:mindease_app/src/app/widgets/sign_out_button.dart';
import 'package:mindease_app/src/domain/entities/profile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfileView();
  }
}

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    final isWide =
        MediaQuery.sizeOf(context).width >= AppSizes.breakpointMobile;

    return Scaffold(
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          final preferences = state.preferences;
          final user = state.user;
          final profile =
              state.profile ?? Profile(userEmail: user?.email ?? '');

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              vertical: AppSizes.paddingXl,
              horizontal: AppSizes.paddingL,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (user != null) ...[
                      ProfileHeader(
                        photoUrl: user.photoURL,
                        displayName: user.displayName,
                        email: user.email,
                      ),
                      if (isWide) ...[
                        const SizedBox(height: AppSizes.spacingM),
                        SignOutButton(
                          onPressed: () =>
                              context.read<ProfileCubit>().signOut(),
                          isLoading: state.isLoading,
                        ),
                      ],
                    ] else ...[
                      GoogleSignInButton(
                        onPressed: () =>
                            context.read<ProfileCubit>().signInWithGoogle(),
                        isLoading: state.isLoading,
                      ),
                    ],
                    if (user != null) ...[
                      const SizedBox(height: AppSizes.spacingXl),
                      ProfileStatisticsSection(profile: profile),
                    ],
                    const SizedBox(height: AppSizes.spacingXl),
                    ProfileSettingsSection(
                      darkTheme: preferences.darkTheme,
                      showHelpIcons: preferences.showHelpIcons,
                      showAnimations: preferences.showAnimations,
                      onDarkThemeChanged: (v) =>
                          context.read<ProfileCubit>().setDarkTheme(v),
                      onShowHelpIconsChanged: (v) =>
                          context.read<ProfileCubit>().setShowHelpIcon(v),
                      onShowAnimationsChanged: (v) =>
                          context.read<ProfileCubit>().setShowAnimations(v),
                    ),
                    if (!isWide && user != null) ...[
                      const SizedBox(height: AppSizes.spacingXl),
                      SignOutButton(
                        onPressed: () => context.read<ProfileCubit>().signOut(),
                        isLoading: state.isLoading,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
