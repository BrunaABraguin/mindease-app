import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/app/widgets/sign_out_button.dart';

void main() {
  testWidgets('SignOutButton calls onPressed', (tester) async {
    var pressed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: SignOutButton(onPressed: () => pressed = true)),
      ),
    );
    await tester.tap(find.byType(SignOutButton));
    await tester.pump();
    expect(pressed, isTrue);
  });

  testWidgets('SignOutButton shows loading indicator', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: SignOutButton(onPressed: () {}, isLoading: true)),
      ),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
