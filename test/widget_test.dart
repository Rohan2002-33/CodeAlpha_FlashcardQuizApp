import 'package:flashcard_quiz_app/main.dart';
import 'package:flashcard_quiz_app/services/storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('study flow: Show Answer toggles the card', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final storage = await StorageService.create();

    await tester.pumpWidget(FlashcardApp(storage: storage));
    await tester.pump(const Duration(seconds: 3)); // splash delay
    await tester.pumpAndSettle();

    expect(find.text('Show Answer'), findsOneWidget);

    await tester.tap(find.text('Show Answer'));
    await tester.pumpAndSettle();

    expect(find.text('Hide Answer'), findsOneWidget);
  });
}
