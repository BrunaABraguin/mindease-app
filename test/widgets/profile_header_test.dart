import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/app/widgets/profile_header.dart';

void main() {
  testWidgets('ProfileHeader renders fallback avatar', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ProfileHeader(
            photoUrl: '',
            displayName: 'No Photo',
            email: 'no-photo@example.com',
          ),
        ),
      ),
    );
    expect(find.byType(CircleAvatar), findsOneWidget);
    expect(find.text('No Photo'), findsOneWidget);
    expect(find.text('no-photo@example.com'), findsOneWidget);
  });
}
