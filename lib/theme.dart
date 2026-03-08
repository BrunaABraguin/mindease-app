import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();
  static const Color darkBlue = Color(0xFF2F4158);
  static const Color blue = Color(0xFF3DA8AF);
  static const Color golden = Color(0xFFCDBC73);
  static const Color lightBlue = Color(0xFFC7CED7);

  static const Color green = Color(0xFF3BAB79);
  static const Color white = Color(0xFFF4F4F4);

  static NavigationBarThemeData navigationBarTheme({
    required Color backgroundColor,
    required Color selectedColor,
    required Color unselectedColor,
  }) {
    return NavigationBarThemeData(
      backgroundColor: backgroundColor,
      indicatorColor: Colors.transparent,
      elevation: 0.0,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return IconThemeData(color: selected ? selectedColor : unselectedColor);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return TextStyle(
          color: selected ? selectedColor : unselectedColor,
          fontSize: 12,
          fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
        );
      }),
      height: 78,
    );
  }

  static NavigationRailThemeData navigationRailTheme({
    required Color backgroundColor,
    required Color selectedColor,
    required Color unselectedColor,
  }) {
    return NavigationRailThemeData(
      backgroundColor: backgroundColor,
      indicatorColor: Colors.transparent,
      selectedIconTheme: IconThemeData(color: selectedColor),
      unselectedIconTheme: IconThemeData(color: unselectedColor),
      selectedLabelTextStyle: TextStyle(
        color: selectedColor,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelTextStyle: TextStyle(color: unselectedColor, fontSize: 12),
    );
  }

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: green,
      onPrimary: Colors.white,
      secondary: blue,
      onSecondary: Colors.white,
      tertiary: golden,
      onTertiary: darkBlue,
      error: Color(0xFFBA1A1A),
      onError: Colors.white,
      surface: white,
      onSurface: darkBlue,
      outline: lightBlue,
      shadow: Colors.black,
      inverseSurface: darkBlue,
      onInverseSurface: white,
      inversePrimary: blue,
      surfaceContainerHighest: Color(0xFFEAEAEA),
      onSurfaceVariant: Color(0xFF4B5563),
      scrim: Colors.black,
    ),
    scaffoldBackgroundColor: white,
    appBarTheme: const AppBarTheme(centerTitle: false),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(),
    navigationBarTheme: navigationBarTheme(
      backgroundColor: const Color(0xFFE9EEF0),
      selectedColor: blue,
      unselectedColor: const Color(0xFF8E959D),
    ),
    navigationRailTheme: navigationRailTheme(
      backgroundColor: const Color(0xFFE9EEF0),
      selectedColor: blue,
      unselectedColor: const Color(0xFF8E959D),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: darkBlue,
      onPrimary: lightBlue,
      secondary: blue,
      onSecondary: darkBlue,
      tertiary: golden,
      onTertiary: darkBlue,
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      surface: Color(0xFF1E2937),
      onSurface: lightBlue,
      outline: Color(0xFF6B7280),
      shadow: Colors.black,
      inverseSurface: lightBlue,
      onInverseSurface: darkBlue,
      inversePrimary: green,
      surfaceContainerHighest: Color(0xFF334155),
      onSurfaceVariant: Color(0xFFAEB6C2),
      scrim: Colors.black,
    ),
    scaffoldBackgroundColor: const Color(0xFF1E2937),
    appBarTheme: const AppBarTheme(centerTitle: false),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(),
    navigationBarTheme: navigationBarTheme(
      backgroundColor: const Color(0xFF263240),
      selectedColor: blue,
      unselectedColor: const Color(0xFFA0A8B2),
    ),
    navigationRailTheme: navigationRailTheme(
      backgroundColor: const Color(0xFF263240),
      selectedColor: blue,
      unselectedColor: const Color(0xFFA0A8B2),
    ),
  );
}
