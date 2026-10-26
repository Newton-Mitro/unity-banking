import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unity_banking/core/di/service_locator.dart' as di;
import 'package:unity_banking/main.dart';

void main() {
  testWidgets('Demo sign-in and transfer flow works', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await di.init();

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(
      find.text('Sign in to your Unity account to continue.'),
      findsOneWidget,
    );
    await tester.enterText(find.byType(TextFormField).at(0), '5550101234');
    await tester.enterText(find.byType(TextFormField).at(1), 'demo-password');
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.text('Your demo code is 123456'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).first, '123456');
    await tester.tap(find.text('Verify and sign in'));
    await tester.pumpAndSettle();

    expect(find.text('TOTAL BALANCE'), findsOneWidget);
    await tester.tap(find.text('Transfer').last);
    await tester.pumpAndSettle();

    expect(find.text('Transfer money'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).at(0), 'Jamie Lee');
    await tester.enterText(find.byType(TextFormField).at(1), '123456789');
    await tester.enterText(find.byType(TextFormField).at(2), '125.50');
    await tester.scrollUntilVisible(
      find.text('Review transfer'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.drag(find.byType(ListView).last, const Offset(0, -250));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Review transfer'));
    await tester.pumpAndSettle();

    expect(find.text('Send demo transfer'), findsOneWidget);
    await tester.tap(find.text('Send demo transfer'));
    await tester.pumpAndSettle();

    expect(find.text('Transfer complete'), findsOneWidget);
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(find.text('TOTAL BALANCE'), findsOneWidget);

    await tester.tap(find.text('Pay bills'));
    await tester.pumpAndSettle();
    expect(find.text('Pay a bill'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).at(0), 'ACCT-2026-45');
    await tester.enterText(find.byType(TextFormField).at(1), '68.25');
    await tester.scrollUntilVisible(
      find.text('Review payment'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.drag(find.byType(ListView).last, const Offset(0, -250));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Review payment'));
    await tester.pumpAndSettle();

    expect(find.text('Pay demo bill'), findsOneWidget);
    await tester.tap(find.text('Pay demo bill'));
    await tester.pumpAndSettle();
    expect(find.text('Payment complete'), findsOneWidget);
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(find.text('TOTAL BALANCE'), findsOneWidget);

    await tester.tap(find.text('Profile').last);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Log out'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Log out'));
    await tester.pumpAndSettle();
    expect(
      find.text('Sign in to your Unity account to continue.'),
      findsOneWidget,
    );
  });
}
