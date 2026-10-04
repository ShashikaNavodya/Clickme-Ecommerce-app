import 'package:flutter_test/flutter_test.dart';
import 'package:clickme/app.dart';

void main() {
  testWidgets('splash screen leads to the sign-in screen', (tester) async {
    await tester.pumpWidget(const ClickMeApp());
    expect(find.text('clickme'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1700));
    await tester.pumpAndSettle();

    expect(find.text('Good to see\nyou again.'), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);
    expect(find.text('Continue as a guest'), findsOneWidget);

    final guestButton = find.text('Continue as a guest');
    await tester.ensureVisible(guestButton);
    await tester.tap(guestButton);
    await tester.pumpAndSettle();
    expect(find.text('Make room for\na little lovely.'), findsOneWidget);
    expect(find.text('Shop by mood'), findsOneWidget);
  });
}
