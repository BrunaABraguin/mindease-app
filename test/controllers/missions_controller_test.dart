import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/app/pages/missions/missions_controller.dart';

void main() {
  group('MissionsCubit', () {
    late MissionsCubit cubit;

    setUp(() {
      cubit = MissionsCubit();
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state is MissionsState', () {
      expect(cubit.state, isA<MissionsState>());
    });

    test('state is const and comparable', () {
      expect(const MissionsState(), isA<MissionsState>());
    });
  });
}
