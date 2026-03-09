import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/app/pages/tasks/tasks_controller.dart';

void main() {
  group('TasksCubit', () {
    late TasksCubit cubit;

    setUp(() {
      cubit = TasksCubit();
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state is TasksState', () {
      expect(cubit.state, isA<TasksState>());
    });

    test('state is const and comparable', () {
      expect(const TasksState(), isA<TasksState>());
    });
  });
}
