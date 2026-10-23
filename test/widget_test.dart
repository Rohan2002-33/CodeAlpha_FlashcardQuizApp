import 'package:flashcard_quiz_app/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('study flow: Show Answer toggles the card', (tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const AppBootstrap());
    expect(find.text('Learn smarter, one card at a time'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.text('Show Answer'), findsOneWidget);

    await tester.tap(find.text('Show Answer'));
    await tester.pumpAndSettle();

    expect(find.text('Hide Answer'), findsOneWidget);
  });
}
