import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/app/utils/layout_utils.dart';

void main() {
  group('getResponsiveMaxWidth', () {
    testWidgets('deve retornar mobileFraction para tela < breakpoint', (
      tester,
    ) async {
      late double result;

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(400, 800)),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                result = getResponsiveMaxWidth(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      // 400 < 600 (default breakpoint), so 400 * 0.95 = 380
      expect(result, closeTo(380.0, 1.0));
    });

    testWidgets('deve retornar webFraction para tela >= breakpoint', (
      tester,
    ) async {
      late double result;

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(800, 600)),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                result = getResponsiveMaxWidth(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      // 800 >= 600 (default breakpoint), so 800 * 0.5 = 400
      expect(result, closeTo(400.0, 1.0));
    });

    testWidgets('deve respeitar parâmetros customizados', (tester) async {
      late double result;

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(500, 800)),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                result = getResponsiveMaxWidth(
                  context,
                  mobileFraction: 0.8,
                  webFraction: 0.6,
                  webBreakpoint: 400.0,
                );
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      // 500 >= 400 (custom breakpoint), so 500 * 0.6 = 300
      expect(result, closeTo(300.0, 1.0));
    });

    testWidgets('deve usar mobileFraction com breakpoint customizado', (
      tester,
    ) async {
      late double result;

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(300, 800)),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                result = getResponsiveMaxWidth(
                  context,
                  mobileFraction: 0.9,
                  webBreakpoint: 500.0,
                );
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      // 300 < 500 (custom breakpoint), so 300 * 0.9 = 270
      expect(result, closeTo(270.0, 1.0));
    });
  });
}
