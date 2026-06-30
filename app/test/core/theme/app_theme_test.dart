import 'package:flutter_test/flutter_test.dart';
import 'package:car_ai/core/theme/app_theme.dart';

void main() {
  group('AppTheme', () {
    test('light theme uses Material 3', () {
      final theme = AppTheme.light;
      expect(theme.useMaterial3, isTrue);
    });

    test('dark theme uses Material 3', () {
      final theme = AppTheme.dark;
      expect(theme.useMaterial3, isTrue);
    });

    test('light and dark themes have different brightness', () {
      final light = AppTheme.light;
      final dark = AppTheme.dark;
      expect(light.colorScheme.brightness, isNot(dark.colorScheme.brightness));
    });
  });
}
