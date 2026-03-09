import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_app/src/app/utils/app_constants.dart';

void main() {
  group('AppConstants', () {
    test('blinkThreshold deve estar entre 0 e 1', () {
      expect(AppConstants.blinkThreshold, greaterThanOrEqualTo(0));
      expect(AppConstants.blinkThreshold, lessThanOrEqualTo(1));
    });

    test('blinkMinOpacity deve estar entre 0 e 1', () {
      expect(AppConstants.blinkMinOpacity, greaterThanOrEqualTo(0));
      expect(AppConstants.blinkMinOpacity, lessThanOrEqualTo(1));
    });
  });

  group('AppSizes', () {
    test('breakpoints devem ser crescentes', () {
      expect(AppSizes.breakpointMobile, lessThan(AppSizes.breakpointTablet));
      expect(AppSizes.breakpointTablet, lessThan(AppSizes.breakpointDesktop));
    });

    test('icon sizes devem ser positivos', () {
      expect(AppSizes.iconLarge, greaterThan(0));
      expect(AppSizes.iconMedium, greaterThan(0));
      expect(AppSizes.iconSmall, greaterThan(0));
      expect(AppSizes.iconExtraSmall, greaterThan(0));
    });

    test('icon sizes devem ser decrescentes', () {
      expect(AppSizes.iconLarge, greaterThan(AppSizes.iconMedium));
      expect(AppSizes.iconMedium, greaterThan(AppSizes.iconSmall));
      expect(AppSizes.iconSmall, greaterThan(AppSizes.iconExtraSmall));
    });

    test('spacing deve ser crescente', () {
      expect(AppSizes.spacingXxs, lessThan(AppSizes.spacingXs));
      expect(AppSizes.spacingXs, lessThan(AppSizes.spacingS));
      expect(AppSizes.spacingS, lessThan(AppSizes.spacingM));
      expect(AppSizes.spacingM, lessThan(AppSizes.spacingL));
      expect(AppSizes.spacingL, lessThan(AppSizes.spacingXl));
      expect(AppSizes.spacingXl, lessThan(AppSizes.spacingXxl));
    });

    test('opacity valores devem estar entre 0 e 1', () {
      expect(AppSizes.opacityLight, greaterThan(0));
      expect(AppSizes.opacityLight, lessThanOrEqualTo(1));
      expect(AppSizes.opacityMedium, greaterThan(0));
      expect(AppSizes.opacityMedium, lessThanOrEqualTo(1));
      expect(AppSizes.opacityHeavy, greaterThan(0));
      expect(AppSizes.opacityHeavy, lessThanOrEqualTo(1));
    });
  });

  group('AppStrings', () {
    test('strings de navegação não devem estar vazias', () {
      expect(AppStrings.timer.isNotEmpty, isTrue);
      expect(AppStrings.habits.isNotEmpty, isTrue);
      expect(AppStrings.tasks.isNotEmpty, isTrue);
      expect(AppStrings.missions.isNotEmpty, isTrue);
      expect(AppStrings.profile.isNotEmpty, isTrue);
      expect(AppStrings.focusMode.isNotEmpty, isTrue);
    });
  });

  group('AppIcons', () {
    test('timer icons devem ser diferentes', () {
      expect(AppIcons.timer, isNot(equals(AppIcons.timerOutlined)));
    });

    test('todos os ícones de navegação devem ser distintos', () {
      final icons = [
        AppIcons.timer,
        AppIcons.habits,
        AppIcons.tasks,
        AppIcons.missions,
        AppIcons.profile,
        AppIcons.focusMode,
      ];
      expect(icons.toSet().length, icons.length);
    });
  });
}
