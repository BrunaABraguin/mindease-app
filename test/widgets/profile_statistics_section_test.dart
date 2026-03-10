import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/app/pages/profile/widgets/profile_statistics_section.dart';
import 'package:mindease_app/src/domain/entities/mission.dart';
import 'package:mindease_app/src/domain/entities/profile.dart';

void main() {
  group('ProfileStatisticsSection', () {
    testWidgets('renders all stat cards', (tester) async {
      const profile = Profile(
        userEmail: 'test@test.com',
        totalFocusMinutes: 90,
        totalTasks: 15,
        totalMissions: 5,
        strikeDays: 7,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ProfileStatisticsSection(profile: profile),
            ),
          ),
        ),
      );

      expect(find.text('ESTATÍSTICAS'), findsOneWidget);
      expect(find.text('1h 30m'), findsOneWidget);
      expect(find.text('Tempo de foco'), findsOneWidget);
      expect(find.text('15'), findsOneWidget);
      expect(find.text('Tarefas concluídas'), findsOneWidget);
      expect(find.text('0/${totalMissionsCount}'), findsOneWidget);
      expect(find.text('Missões finalizadas'), findsOneWidget);
      expect(find.text('7'), findsOneWidget);
      expect(find.text('Sequência'), findsOneWidget);
    });

    testWidgets('renders with zero values', (tester) async {
      const profile = Profile(userEmail: 'zero@test.com');

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ProfileStatisticsSection(profile: profile),
            ),
          ),
        ),
      );

      expect(find.text('0m'), findsOneWidget);
      // Tasks completed and sequence cards should both display "0" when profile stats are zero.
      expect(find.text('0'), findsNWidgets(2));

      expect(find.text('0/${totalMissionsCount}'), findsOneWidget);
    });
  });
}
