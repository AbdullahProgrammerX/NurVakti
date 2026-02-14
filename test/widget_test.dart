import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nur_vakti/main.dart';

void main() {
  testWidgets('App should load', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: NurVaktiApp()));
    expect(find.text('Nur Vakti'), findsOneWidget);
  });
}
