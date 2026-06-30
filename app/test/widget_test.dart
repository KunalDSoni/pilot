import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:car_ai/app.dart';

void main() {
  testWidgets('App renders without error', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: CarAIApp(),
      ),
    );
    expect(find.byType(CarAIApp), findsOneWidget);
  });
}
