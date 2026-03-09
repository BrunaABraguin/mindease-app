import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mindease_app/src/app/pages/profile/profile_controller.dart';
import 'package:mindease_app/src/app/utils/app_constants.dart';
import 'package:mindease_app/src/app/widgets/google_sign_in_button.dart';
import 'package:mindease_app/src/app/widgets/profile_header.dart';
import 'package:mindease_app/src/app/widgets/sign_out_button.dart';

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
    return Scaffold(
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          final preferences = state.preferences;
          final user = state.user;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Column(
              children: [
                if (user != null) ...[
                  ProfileHeader(
                    photoUrl: user.photoURL,
                    displayName: user.displayName,
                    email: user.email,
                  ),
                  const SizedBox(height: 16),
                  SignOutButton(
                    onPressed: () => context.read<ProfileCubit>().signOut(),
                  ),
                ] else ...[
                  GoogleSignInButton(
                    onPressed: () =>
                        context.read<ProfileCubit>().signInWithGoogle(),
                  ),
                ],
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'CONFIGURAÇÕES',
                        style: TextStyle(
                          fontSize: 12,
                          letterSpacing: 1.2,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SwitchListTile(
                        value: preferences.darkTheme,
                        onChanged: (v) {
                          context.read<ProfileCubit>().setDarkTheme(v);
                        },
                        title: const Text('Modo escuro'),
                        secondary: const Icon(AppIcons.theme),
                      ),
                      SwitchListTile(
                        value: preferences.showHelpIcons,
                        onChanged: (v) =>
                            context.read<ProfileCubit>().setShowHelpIcon(v),
                        title: const Text('Mostrar ícone de ajuda'),
                        secondary: const Icon(Icons.help_outline),
                      ),
                      SwitchListTile(
                        value: preferences.showAnimations,
                        onChanged: (v) =>
                            context.read<ProfileCubit>().setShowAnimations(v),
                        title: const Text('Mostrar animações'),
                        secondary: const Icon(Icons.animation_outlined),
                      ),
                    ],
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
