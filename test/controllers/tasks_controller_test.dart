import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/app/pages/tasks/tasks_controller.dart';

import '../mocks/fake_task_repository.dart';

void main() {
  group('TasksCubit', () {
    late TasksCubit cubit;
    late FakeTaskRepository fakeTaskRepo;

    setUp(() {
      fakeTaskRepo = FakeTaskRepository();
      cubit = TasksCubit(taskRepository: fakeTaskRepo, userEmail: null);
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
