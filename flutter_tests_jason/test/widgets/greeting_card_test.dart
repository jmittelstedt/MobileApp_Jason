import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tests_jason/widgets/greeting_card.dart';

void main() {
  group('GreetingCard', () {
    testWidgets('renders the greeting exactly once', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: GreetingCard(userName: 'Alice')),
        ),
      );

      expect(find.text('Hello, Alice!'), findsOneWidget);
    });

    testWidgets('shows zero likes initially', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: GreetingCard(userName: 'Alice')),
        ),
      );

      expect(find.text('Likes: 0'), findsOneWidget);
    });

    testWidgets('increments likes when the Like button is tapped', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: GreetingCard(userName: 'Alice')),
        ),
      );

      await tester.tap(find.byKey(const Key('like_button_key')));
      await tester.pump();

      expect(find.text('Likes: 1'), findsOneWidget);
    });
  });
}
