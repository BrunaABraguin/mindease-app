import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mindease_app/src/app/navigator.dart';
import 'package:mindease_app/src/app/pages/missions/missions_controller.dart';
import 'package:mindease_app/src/app/pages/missions/widgets/mission_section_widget.dart';
import 'package:mindease_app/src/app/pages/profile/profile_controller.dart';
import 'package:mindease_app/src/app/utils/app_constants.dart';
import 'package:mindease_app/src/app/widgets/login_required_message.dart';
import 'package:mindease_app/src/domain/entities/mission.dart';
import 'package:mindease_app/src/domain/entities/profile.dart';

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

    if (!isLoggedIn) {
      return const Center(
        child: LoginRequiredMessage(message: AppStrings.missionsLoginMessage),
      );
    }

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, profileState) {
        final profile = profileState.profile ?? Profile(userEmail: userEmail);
        final completedMissions = profile.completedMissions;
        final completedCount = completedMissions.length;

        return Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              vertical: AppSizes.paddingXl,
              horizontal: AppSizes.paddingL,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppSizes.breakpointDesktop,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.missions,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: AppSizes.spacingXs),
                    Text(
                      AppStrings.missionsProgress(
                        completedCount,
                        totalMissionsCount,
                      ),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacingXl),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide =
                            constraints.maxWidth >= AppSizes.breakpointMobile;
                        final sections = appMissions
                            .map(
                              (section) => MissionSectionWidget(
                                section: section,
                                completedMissions: completedMissions,
                                onMissionTap: (mission) {
                                  AppNavigator.switchTab(
                                    context,
                                    mission.destinationIndex,
                                  );
                                },
                              ),
                            )
                            .toList();

                        if (!isWide) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: sections
                                .map(
                                  (s) => Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: AppSizes.spacingXl,
                                    ),
                                    child: s,
                                  ),
                                )
                                .toList(),
                          );
                        }

                        return Wrap(
                          spacing: AppSizes.spacingM,
                          runSpacing: AppSizes.spacingXl,
                          children: sections
                              .map(
                                (s) => SizedBox(
                                  width:
                                      (constraints.maxWidth -
                                          AppSizes.spacingM) /
                                      2,
                                  child: s,
                                ),
                              )
                              .toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
