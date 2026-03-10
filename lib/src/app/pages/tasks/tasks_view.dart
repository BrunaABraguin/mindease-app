import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mindease_app/src/app/pages/profile/profile_controller.dart';
import 'package:mindease_app/src/app/pages/tasks/tasks_controller.dart';
import 'package:mindease_app/src/app/pages/tasks/widgets/task_section.dart';
import 'package:mindease_app/src/app/pages/tasks/widgets/tasks_summary_bar.dart';
import 'package:mindease_app/src/app/utils/app_constants.dart';
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
      child: BlocBuilder<TasksCubit, TasksState>(
        builder: (context, state) {
          final cubit = context.read<TasksCubit>();

          return Scaffold(
            body: Align(
              alignment: Alignment.topCenter,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: getResponsiveMaxWidth(context),
                ),
                child: isLoggedIn
                    ? ListView(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSizes.paddingXl,
                          horizontal: AppSizes.paddingL,
                        ),
                        children: [
                          TasksSummaryBar(
                            total: state.totalCount,
                            pending: state.pendingCount,
                            completed: state.completedCount,
                          ),
                          const SizedBox(height: AppSizes.spacingXs),
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              onPressed: cubit.toggleHistoryView,
                              icon: Icon(
                                state.showHistory
                                    ? Icons.list_alt
                                    : Icons.view_kanban_outlined,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                              tooltip: state.showHistory
                                  ? 'Tarefas pendentes'
                                  : 'Histórico de tarefas',
                            ),
                          ),
                          const SizedBox(height: AppSizes.spacingM),
                          TaskSection(
                            title: 'Prioridades',
                            tasks: state.showHistory
                                ? state.completedPriorities
                                : state.pendingPriorities,
                            completedCount: state.showHistory
                                ? state.completedPriorities.length
                                : state.pendingPriorities.length,
                            isAdding: state.isAddingPriority,
                            onStartAdding: cubit.startAddingPriority,
                            onSave: (name) =>
                                cubit.addTask(name, isPriority: true),
                            onCancel: cubit.cancelAddingPriority,
                            onComplete: cubit.completeTask,
                            onDelete: cubit.deleteTask,
                            onEditName: cubit.updateTaskName,
                            editingTaskId: state.editingTaskId,
                            onStartEditing: cubit.startEditing,
                            onCancelEditing: cubit.cancelEditing,
                            maxItems: state.showHistory
                                ? null
                                : TasksCubit.maxPriorities,
                            hintText: 'Nome da prioridade',
                            readOnly: state.showHistory,
                          ),
                          const SizedBox(height: AppSizes.spacingL),
                          TaskSection(
                            title: 'Tarefas',
                            tasks: state.showHistory
                                ? state.completedNonPriorityTasks
                                : state.pendingTasks,
                            completedCount: state.showHistory
                                ? state.completedNonPriorityTasks.length
                                : state.pendingTasks.length,
                            isAdding: state.isAddingTask,
                            onStartAdding: cubit.startAddingTask,
                            onSave: (name) => cubit.addTask(name),
                            onCancel: cubit.cancelAddingTask,
                            onComplete: cubit.completeTask,
                            onDelete: cubit.deleteTask,
                            onEditName: cubit.updateTaskName,
                            editingTaskId: state.editingTaskId,
                            onStartEditing: cubit.startEditing,
                            onCancelEditing: cubit.cancelEditing,
                            readOnly: state.showHistory,
                          ),
                        ],
                      )
                    : const Center(
                        child: LoginRequiredMessage(
                          message:
                              'Faça login com o Google para\nadicionar e gerenciar suas tarefas.',
                        ),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
