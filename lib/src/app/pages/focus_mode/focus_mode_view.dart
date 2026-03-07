import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mindease_app/src/app/pages/focus_mode/focus_mode_controller.dart';
import 'package:mindease_app/src/app/utils/app_constants.dart';

class FocusModePage extends StatelessWidget {
  const FocusModePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FocusModeCubit(),
      child: const FocusModeView(),
    );
  }
}

class FocusModeView extends StatelessWidget {
  const FocusModeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.focusMode)),
      body: BlocBuilder<FocusModeCubit, FocusModeState>(
        builder: (context, state) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  AppIcons.focusMode,
                  size: AppSizes.iconLarge,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: AppSizes.spacingL),
                Text(
                  AppStrings.focusMode,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
