import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mindease_app/src/app/pages/profile/profile_controller.dart';
import 'package:mindease_app/src/app/pages/tasks/tasks_controller.dart';
import 'package:mindease_app/src/app/pages/tasks/widgets/tasks_content.dart';
import 'package:mindease_app/src/app/utils/layout_utils.dart';
import 'package:mindease_app/src/app/widgets/login_required_message.dart';
import 'package:mindease_app/src/domain/repositories/task_repository.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key, required this.taskRepository});

  final TaskRepository taskRepository;

  @override
  Widget build(BuildContext context) {
    final userEmail = context.select<ProfileCubit, String?>(
      (cubit) => cubit.state.user?.email,
    );
    return BlocProvider(
      create: (ctx) => TasksCubit(
        taskRepository: taskRepository,
        userEmail: userEmail,
        onTaskCompleted: () async {
          ctx.read<ProfileCubit>().incrementTotalTasks();
        },
      ),
      child: const TasksView(),
    );
  }
}

class TasksView extends StatelessWidget {
  const TasksView({super.key});

  @override
  Widget build(BuildContext context) {
    final userEmail = context.select<ProfileCubit, String?>(
      (cubit) => cubit.state.user?.email,
    );
    final isLoggedIn = userEmail != null;

    return BlocListener<ProfileCubit, ProfileState>(
      listenWhen: (prev, curr) => prev.user?.email != curr.user?.email,
      listener: (context, profileState) {
        context.read<TasksCubit>().updateUserEmail(profileState.user?.email);
      },
      child: Scaffold(
        body: Align(
          alignment: Alignment.topCenter,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: getResponsiveMaxWidth(context),
            ),
            child: isLoggedIn
                ? const TasksContent()
                : const Center(
                    child: LoginRequiredMessage(
                      message:
                          'Faça login com o Google para\nadicionar e gerenciar suas tarefas.',
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
