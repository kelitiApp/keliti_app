// Basic smoke test: the app boots and shows the login screen.

import 'package:flutter_test/flutter_test.dart';

import 'package:keliti_app/app.dart';

void main() {
  testWidgets('Keliti app boots to the login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const KelitiApp());
    await tester.pump();

    expect(find.text('كليتي'), findsOneWidget);
    expect(find.text('تسجيل الدخول'), findsWidgets);
  });
}
