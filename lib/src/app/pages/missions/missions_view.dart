import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mindease_app/src/app/pages/missions/missions_controller.dart';
import 'package:mindease_app/src/app/pages/profile/profile_controller.dart';
import 'package:mindease_app/src/app/utils/app_constants.dart';
import 'package:mindease_app/src/app/widgets/login_required_message.dart';

class MissionsPage extends StatelessWidget {
  const MissionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MissionsCubit(),
      child: const MissionsView(),
    );
  }
}

class MissionsView extends StatelessWidget {
  const MissionsView({super.key});

  @override
  Widget build(BuildContext context) {
    final userEmail = context.select<ProfileCubit, String?>(
      (cubit) => cubit.state.user?.email,
    );
    final isLoggedIn = userEmail != null;

    return BlocBuilder<MissionsCubit, MissionsState>(
      builder: (context, state) {
        if (!isLoggedIn) {
          return const Center(
            child: LoginRequiredMessage(
              message:
                  'Faça login com o Google para\nadicionar e gerenciar suas missões.',
            ),
          );
        }

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                AppIcons.missions,
                size: AppSizes.iconLarge,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: AppSizes.spacingL),
              Text(
                AppStrings.missions,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        );
      },
    );
  }
}
