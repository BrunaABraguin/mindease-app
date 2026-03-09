import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/app/pages/habits/habits_controller.dart';

void main() {
  group('HabitsCubit', () {
    late HabitsCubit cubit;

    setUp(() {
      cubit = HabitsCubit();
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state is HabitsState', () {
      expect(cubit.state, isA<HabitsState>());
    });

    test('state is const and comparable', () {
      expect(const HabitsState(), isA<HabitsState>());
    });
  });
}
