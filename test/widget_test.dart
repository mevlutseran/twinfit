import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twinfit/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: TwinFitApp(),
      ),
    );
    expect(find.byType(TwinFitApp), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));
  });
}
