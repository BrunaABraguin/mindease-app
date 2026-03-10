import 'package:flutter/material.dart';

import 'package:mindease_app/src/app/utils/app_constants.dart';
import 'package:mindease_app/src/app/widgets/empty_state_card.dart';

class EmptyHabitsState extends StatelessWidget {
  const EmptyHabitsState({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyStateCard(
      icon: Icons.checklist_rounded,
      message: AppStrings.emptyHabitsMessage,
    );
  }
}
