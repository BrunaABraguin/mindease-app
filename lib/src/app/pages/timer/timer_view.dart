import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mindease_app/src/app/pages/focus_mode/focus_mode_view.dart';
import 'package:mindease_app/src/app/pages/timer/timer_controller.dart';
import 'package:mindease_app/src/app/pages/timer/widgets/timer_segmented_button.dart';
import 'package:mindease_app/src/app/utils/app_constants.dart';
import 'package:mindease_app/src/app/utils/help_texts.dart';
import 'package:mindease_app/src/app/widgets/focus_mode_button.dart';
import 'package:mindease_app/src/app/widgets/help_icon_button.dart';
import 'package:mindease_app/src/app/widgets/timer_display.dart';
import 'package:mindease_app/src/data/repositories/timer_repository.dart'
    as repo;
import 'package:mindease_app/src/domain/entities/timer_entity.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key, required this.timerRepository});
  final repo.TimerRepository timerRepository;

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TimerCubit(timerRepository: widget.timerRepository),
      child: const TimerView(),
    );
  }
}

class TimerView extends StatefulWidget {
  const TimerView({super.key});

  @override
  State<TimerView> createState() => _TimerViewState();
}

class _TimerViewState extends State<TimerView> {
  static const double _mobileMaxWidthFraction = 0.95;
  static const double _webMaxWidthFraction = 0.5;

  double _getResponsiveMaxWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    const webBreakpoint = 600.0;
    if (width < webBreakpoint) {
      return width * _mobileMaxWidthFraction;
    } else {
      return width * _webMaxWidthFraction;
    }
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          // Ícone de ajuda para o Focus Mode
          const HelpIconButton(
            title: HelpTexts.focusModeTitle,
            description: HelpTexts.focusModeDescription,
            size: AppSizes.iconSmall,
          ),
          // Botão para acessar o Focus Mode
          FocusModeButton(
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const FocusModePage()));
            },
          ),
        ],
      ),
      body: BlocBuilder<TimerCubit, TimerEntity>(
        builder: (context, state) {
          return Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: _getResponsiveMaxWidth(context),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                //Seleção do timer mode e display do timer
                children: [
                  const Row(
                    children: [
                      Spacer(),
                      // Ícone de ajuda para o timer
                      HelpIconButton(
                        title: HelpTexts.timerTitle,
                        description: HelpTexts.timerDescription,
                        size: AppSizes.iconSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.spacingS),
                  // Timer mode selection
                  TimerSegmentedButton(
                    selectedIndex: state.currentModeIndex,
                    onChanged: (index) {
                      context.read<TimerCubit>().updateCurrentModeIndex(index);
                    },
                  ),
                  const SizedBox(height: AppSizes.spacingL),
                  // Timer centralizado
                  TimerDisplay(timer: state),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
