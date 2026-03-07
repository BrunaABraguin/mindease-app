import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mindease_app/src/app/pages/tasks/tasks_controller.dart';
import 'package:mindease_app/src/app/utils/app_constants.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => TasksCubit(), child: const TasksView());
  }
}

class TasksView extends StatelessWidget {
  const TasksView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksCubit, TasksState>(
      builder: (context, state) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                AppIcons.tasks,
                size: AppSizes.iconLarge,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: AppSizes.spacingL),
              Text(
                AppStrings.tasks,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        );
      },
    );
  }
}
