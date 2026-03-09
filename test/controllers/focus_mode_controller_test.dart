import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/app/pages/focus_mode/focus_mode_controller.dart';

void main() {
  group('FocusModeCubit', () {
    late FocusModeCubit cubit;

    setUp(() {
      cubit = FocusModeCubit();
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state is FocusModeState', () {
      expect(cubit.state, isA<FocusModeState>());
    });

    test('state is const and comparable', () {
      expect(const FocusModeState(), isA<FocusModeState>());
    });
  });
}
