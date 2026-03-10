import 'package:flutter/material.dart';

import 'package:mindease_app/src/app/utils/app_constants.dart';
import 'package:mindease_app/src/app/widgets/empty_state_card.dart';

class EmptyTasksState extends StatelessWidget {
  const EmptyTasksState({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyStateCard(
      icon: Icons.task_alt_rounded,
      message: AppStrings.emptyTasksMessage,
    );
  }
}
