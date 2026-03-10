import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mindease_app/src/app/pages/habits/habits_controller.dart';
import 'package:mindease_app/src/app/pages/habits/widgets/add_habit_button.dart';
import 'package:mindease_app/src/app/pages/habits/widgets/date_header.dart';
import 'package:mindease_app/src/app/pages/habits/widgets/empty_habits_state.dart';
import 'package:mindease_app/src/app/pages/habits/widgets/habit_card.dart';
import 'package:mindease_app/src/app/pages/profile/profile_controller.dart';
import 'package:mindease_app/src/app/utils/app_constants.dart';
import 'package:mindease_app/src/app/utils/date_utils.dart';
import 'package:mindease_app/src/app/utils/layout_utils.dart';
import 'package:mindease_app/src/app/widgets/login_required_message.dart';
import 'package:mindease_app/src/domain/repositories/habit_repository.dart';

class HabitsPage extends StatelessWidget {
  const HabitsPage({super.key, required this.habitRepository});

  final HabitRepository habitRepository;

  @override
  Widget build(BuildContext context) {
    final userEmail = context.select<ProfileCubit, String?>(
      (cubit) => cubit.state.user?.email,
    );
    return BlocProvider(
      create: (ctx) => HabitsCubit(
        habitRepository: habitRepository,
        userEmail: userEmail,
        onMissionTriggered: (missionId) async {
          ctx.read<ProfileCubit>().tryCompleteMission(missionId);
        },
      ),
      child: const HabitsView(),
    );
  }
}

class HabitsView extends StatelessWidget {
  const HabitsView({super.key});

  @override
  Widget build(BuildContext context) {
    final userEmail = context.select<ProfileCubit, String?>(
      (cubit) => cubit.state.user?.email,
    );
    final isLoggedIn = userEmail != null;

    return BlocListener<ProfileCubit, ProfileState>(
      listenWhen: (prev, curr) => prev.user?.email != curr.user?.email,
      listener: (context, profileState) {
        context.read<HabitsCubit>().updateUserEmail(profileState.user?.email);
      },
      child: BlocBuilder<HabitsCubit, HabitsState>(
        builder: (context, state) {
          final cubit = context.read<HabitsCubit>();
          final selectedDate = state.selectedDate ?? DateTime.now();
          final weekDays = getWeekDays(selectedDate);

          return Scaffold(
            body: Align(
              alignment: Alignment.topCenter,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: getResponsiveMaxWidth(context),
                ),
                child: isLoggedIn
                    ? Stack(
                        children: [
                          ListView(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSizes.paddingXl,
                              horizontal: AppSizes.paddingL,
                            ),
                            children: [
                              DateHeader(
                                selectedDate: selectedDate,
                                onDatePicked: (date) => cubit.selectDate(date),
                              ),
                              const SizedBox(height: AppSizes.spacingM),
                              AddHabitButton(
                                isAdding: state.isAdding,
                                onStartAdding: cubit.startAdding,
                                onSave: cubit.addHabit,
                                onCancel: cubit.cancelAdding,
                              ),
                              const SizedBox(height: AppSizes.spacingM),
                              if (state.habits.isEmpty && !state.isAdding)
                                const EmptyHabitsState(),
                              ...state.habits.map(
                                (habit) => Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: AppSizes.spacingS,
                                  ),
                                  child: HabitCard(
                                    habit: habit,
                                    weekDays: weekDays,
                                    selectedDate: selectedDate,
                                    onToggleDay: (day) =>
                                        cubit.toggleRecord(habit.id, day),
                                    onDelete: () =>
                                        cubit.startDeleting(habit.id),
                                    onStartEditing: () =>
                                        cubit.startEditing(habit.id),
                                    onSaveEdit: (newName) => cubit
                                        .updateHabitName(habit.id, newName),
                                    onCancelEdit: cubit.cancelEditing,
                                    isEditing: state.editingHabitId == habit.id,
                                    isDeleting:
                                        state.deletingHabitId == habit.id,
                                    onConfirmDelete: () =>
                                        cubit.deleteHabit(habit.id),
                                    onCancelDelete: cubit.cancelDeleting,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (state.isLoading)
                            const Positioned.fill(
                              child: ColoredBox(
                                color: Color(0x33000000),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            ),
                        ],
                      )
                    : const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSizes.paddingL,
                          ),
                          child: LoginRequiredMessage(
                            message:
                                'Faça login com o Google para\nadicionar e gerenciar seus hábitos.',
                          ),
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
