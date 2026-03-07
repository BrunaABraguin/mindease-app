import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mindease_app/src/app/pages/focus_mode/focus_mode_view.dart';
import 'package:mindease_app/src/app/pages/timer/timer_controller.dart';
import 'package:mindease_app/src/app/pages/timer/timer_segmented_button.dart';
import 'package:mindease_app/src/app/utils/app_constants.dart';
import 'package:mindease_app/src/app/utils/help_texts.dart';
import 'package:mindease_app/src/app/widgets/focus_mode_button.dart';
import 'package:mindease_app/src/app/widgets/help_icon_button.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => TimerCubit(), child: const TimerView());
  }
}

class TimerView extends StatefulWidget {
  const TimerView({super.key});

  @override
  State<TimerView> createState() => _TimerViewState();
}

class _TimerViewState extends State<TimerView> {
  @override
  void dispose() {
    // Garante que ao sair da tela timer, o modo de UI volta ao normal
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        actions: [
          const HelpIconButton(
            title: HelpTexts.focusModeTitle,
            description: HelpTexts.focusModeDescription,
            size: AppSizes.iconSmall,
          ),
          FocusModeButton(
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const FocusModePage()));
            },
          ),
        ],
      ),
      body: BlocBuilder<TimerCubit, TimerState>(
        builder: (context, state) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const HelpIconButton(
                  title: HelpTexts.timerTitle,
                  description: HelpTexts.timerDescription,
                  size: AppSizes.iconSmall,
                ),
                const SizedBox(height: AppSizes.spacingM),
                TimerSegmentedButton(
                  selectedIndex: _selectedTab,
                  onChanged: (index) {
                    setState(() {
                      _selectedTab = index;
                    });
                  },
                ),
                const SizedBox(height: AppSizes.spacingL),
                Icon(
                  AppIcons.timer,
                  size: AppSizes.iconLarge,
                  color: colorScheme.primary,
                ),
                const SizedBox(height: AppSizes.spacingL),
                Text(
                  AppStrings.timer,
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
