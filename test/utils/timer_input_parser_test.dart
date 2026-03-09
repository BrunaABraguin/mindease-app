import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/app/utils/timer_input_parser.dart';

void main() {
  group('parseTimerInput', () {
    group('formato minutos simples', () {
      test('deve converter minutos inteiros para segundos', () {
        expect(parseTimerInput('5'), 300);
        expect(parseTimerInput('10'), 600);
        expect(parseTimerInput('25'), 1500);
      });

      test('deve converter 0 minutos para 0 segundos', () {
        expect(parseTimerInput('0'), 0);
      });

      test('deve lidar com espaços extras', () {
        expect(parseTimerInput('  5  '), 300);
      });

      test('deve limitar ao máximo de 60 minutos (3600s)', () {
        expect(parseTimerInput('61'), 3600);
        expect(parseTimerInput('120'), 3600);
      });

      test('deve retornar null para entrada negativa', () {
        expect(parseTimerInput('-1'), isNull);
      });

      test('deve retornar null para texto inválido', () {
        expect(parseTimerInput('abc'), isNull);
        expect(parseTimerInput(''), isNull);
      });
    });

    group('formato minutos:segundos', () {
      test('deve converter mm:ss corretamente', () {
        expect(parseTimerInput('8:30'), 510);
        expect(parseTimerInput('12:34'), 754);
        expect(parseTimerInput('0:30'), 30);
      });

      test('deve rejeitar segundos >= 60', () {
        expect(parseTimerInput('5:60'), isNull);
        expect(parseTimerInput('5:99'), isNull);
      });

      test('deve rejeitar formato inválido mm:ss:ss', () {
        expect(parseTimerInput('1:2:3'), isNull);
      });

      test('deve rejeitar partes não numéricas', () {
        expect(parseTimerInput('a:b'), isNull);
        expect(parseTimerInput(':30'), isNull);
      });

      test('deve limitar 60:00 ao maxSeconds', () {
        expect(parseTimerInput('60:00'), 3600);
        expect(parseTimerInput('61:00'), 3600);
      });
    });

    group('maxSeconds customizado', () {
      test('deve respeitar limite customizado', () {
        expect(parseTimerInput('10', maxSeconds: 300), 300);
        expect(parseTimerInput('5', maxSeconds: 300), 300);
        expect(parseTimerInput('3', maxSeconds: 300), 180);
      });
    });
  });
}
