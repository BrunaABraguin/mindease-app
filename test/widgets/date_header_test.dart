import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:mindease_app/src/app/pages/habits/widgets/date_header.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('pt_BR');
  });

  group('DateHeader', () {
    final testDate = DateTime(2025, 6, 15);

    Widget buildWidget({
      DateTime? selectedDate,
      void Function(DateTime)? onDatePicked,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: DateHeader(
            selectedDate: selectedDate ?? testDate,
            onDatePicked: onDatePicked ?? (_) {},
          ),
        ),
      );
    }

    testWidgets('renders formatted date', (tester) async {
      await tester.pumpWidget(buildWidget());

      final formatted = DateFormat(
        "EEEE, d 'de' MMMM",
        'pt_BR',
      ).format(testDate);
      expect(find.text(formatted), findsOneWidget);
    });

    testWidgets('renders calendar icon', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.byIcon(Icons.calendar_month), findsOneWidget);
    });

    testWidgets('tapping calendar icon opens date picker', (tester) async {
      await tester.pumpWidget(buildWidget());

      await tester.tap(find.byIcon(Icons.calendar_month));
      await tester.pumpAndSettle();

      expect(find.byType(DatePickerDialog), findsOneWidget);
    });
  });
}
