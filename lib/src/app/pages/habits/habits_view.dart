import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'habits_controller.dart';
import '../../utils/app_constants.dart';

class HabitsPage extends StatelessWidget {
  const HabitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HabitsCubit(),
      child: const HabitsView(),
    );
  }
}

class HabitsView extends StatelessWidget {
  const HabitsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HabitsCubit, HabitsState>(
      builder: (context, state) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                AppIcons.habits,
                size: AppSizes.iconLarge,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: AppSizes.spacingL),
              Text(
                AppStrings.habits,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        );
      },
    );
  }
}
