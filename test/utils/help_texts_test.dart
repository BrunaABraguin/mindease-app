import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/app/utils/help_texts.dart';

void main() {
  group('HelpTexts', () {
    test('timerTitle não deve estar vazio', () {
      expect(HelpTexts.timerTitle.isNotEmpty, isTrue);
    });

    test('timerDescription não deve estar vazio', () {
      expect(HelpTexts.timerDescription.isNotEmpty, isTrue);
    });

    test('focusModeTitle não deve estar vazio', () {
      expect(HelpTexts.focusModeTitle.isNotEmpty, isTrue);
    });

    test('focusModeDescription não deve estar vazio', () {
      expect(HelpTexts.focusModeDescription.isNotEmpty, isTrue);
    });

    test('cyclesTitle não deve estar vazio', () {
      expect(HelpTexts.cyclesTitle.isNotEmpty, isTrue);
    });

    test('cyclesDescription não deve estar vazio', () {
      expect(HelpTexts.cyclesDescription.isNotEmpty, isTrue);
    });

    test('cyclesCompletedMessage não deve estar vazio', () {
      expect(HelpTexts.cyclesCompletedMessage.isNotEmpty, isTrue);
    });
  });
}
