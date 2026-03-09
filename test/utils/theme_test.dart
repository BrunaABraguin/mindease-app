import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/theme.dart';

void main() {
  group('AppTheme', () {
    test('lightTheme is valid and light', () {
      expect(AppTheme.lightTheme.brightness, Brightness.light);
      expect(AppTheme.lightTheme.useMaterial3, isTrue);
    });

    test('darkTheme is valid and dark', () {
      expect(AppTheme.darkTheme.brightness, Brightness.dark);
      expect(AppTheme.darkTheme.useMaterial3, isTrue);
    });

    test('navigationBarTheme returns configured theme data', () {
      final data = AppTheme.navigationBarTheme(
        backgroundColor: Colors.red,
        selectedColor: Colors.blue,
        unselectedColor: Colors.grey,
      );
      expect(data.backgroundColor, Colors.red);
      expect(data.indicatorColor, Colors.transparent);
      expect(data.elevation, 0.0);
    });

    test('navigationRailTheme returns configured theme data', () {
      final data = AppTheme.navigationRailTheme(
        backgroundColor: Colors.green,
        selectedColor: Colors.white,
        unselectedColor: Colors.black,
      );
      expect(data.backgroundColor, Colors.green);
      expect(data.indicatorColor, Colors.transparent);
      expect(data.selectedIconTheme?.color, Colors.white);
      expect(data.unselectedIconTheme?.color, Colors.black);
    });

    test('focusModeForeground is white', () {
      expect(AppTheme.focusModeForeground, Colors.white);
    });
  });
}
