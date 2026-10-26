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

    expect(find.text('Internal account transfer'), findsOneWidget);
    await tester.tap(find.text('Internal account transfer'));
    await tester.pumpAndSettle();
    expect(find.text('Internal account transfer'), findsOneWidget);
    await tester.tap(find.byType(DropdownButtonFormField<String>).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('High-yield Savings · •••• 9102').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, '125.50');
    await tester.scrollUntilVisible(
      find.text('Review request'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.drag(find.byType(ListView).last, const Offset(0, -250));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Review request'));
    await tester.pumpAndSettle();

    expect(find.text('Confirm demo request'), findsOneWidget);
    await tester.tap(find.text('Confirm demo request'));
    await tester.pumpAndSettle();
    expect(find.text('Transfer complete'), findsOneWidget);
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(find.text('TOTAL BALANCE'), findsOneWidget);

    await tester.tap(find.text('Transfer').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Manage beneficiaries'));
    await tester.pumpAndSettle();
    expect(find.text('Beneficiaries'), findsOneWidget);
    await tester.tap(find.text('Add a beneficiary'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'Alex Demo');
    await tester.enterText(find.byType(TextFormField).at(1), 'Alex');
    await tester.enterText(
      find.byType(TextFormField).at(2),
      'Harbor Credit Union',
    );
    await tester.enterText(find.byType(TextFormField).at(3), '555001122');
    await tester.scrollUntilVisible(
      find.text('Save beneficiary'),
      160,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.drag(find.byType(ListView).last, const Offset(0, -160));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save beneficiary'));
    await tester.pumpAndSettle();
    expect(find.text('Alex'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Inter credit union transfer'));
    await tester.pumpAndSettle();
    expect(find.text('Inter credit union transfer').last, findsOneWidget);
    await tester.tap(find.text('Choose saved beneficiary'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Alex').first);
    await tester.pumpAndSettle();
    expect(find.text('Alex Demo'), findsOneWidget);
    expect(find.text('Harbor Credit Union'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).at(3), '125.50');
    await tester.scrollUntilVisible(
      find.text('Review request'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.drag(find.byType(ListView).last, const Offset(0, -250));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Review request'));
    await tester.pumpAndSettle();

    expect(find.text('Confirm demo request'), findsOneWidget);
    await tester.tap(find.text('Confirm demo request'));
    await tester.pumpAndSettle();

    expect(find.text('Transfer submitted'), findsOneWidget);
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(find.text('TOTAL BALANCE'), findsOneWidget);

    await tester.tap(find.text('Transfer').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Withdraw from agent'));
    await tester.pumpAndSettle();
    expect(find.text('Withdraw from agent').last, findsOneWidget);
    await tester.enterText(find.byType(TextFormField).at(0), 'Jamie Lee');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'Unity Main Street',
    );
    await tester.enterText(find.byType(TextFormField).at(3), '80');
    await tester.scrollUntilVisible(
      find.text('Review request'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.drag(find.byType(ListView).last, const Offset(0, -250));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Review request'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Confirm demo request'));
    await tester.pumpAndSettle();
    expect(find.text('Demo pickup code'), findsOneWidget);
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

    await tester.tap(find.text('Accounts').last);
    await tester.pumpAndSettle();
    expect(find.text('Deposit accounts'), findsOneWidget);
    await tester.tap(find.text('Everyday Checking'));
    await tester.pumpAndSettle();
    expect(find.text('Account details'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Deposit to this account'),
      120,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.drag(find.byType(ListView).last, const Offset(0, -120));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Deposit to this account'));
    await tester.pumpAndSettle();
    expect(find.text('Deposit to account'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).first, '2500');
    await tester.tap(find.text('Nagad'));
    await tester.scrollUntilVisible(
      find.text('Review deposit'),
      160,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.drag(find.byType(ListView).last, const Offset(0, -160));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Review deposit'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Payment method: Nagad'), findsOneWidget);
    await tester.tap(find.text('Continue to demo checkout'));
    await tester.pumpAndSettle();
    expect(find.text('Demo checkout ready'), findsOneWidget);
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Deposit to this account'),
      120,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.drag(find.byType(ListView).last, const Offset(0, 120));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Deposit to this account'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, '1500');
    final depositForm = find.descendant(
      of: find.ancestor(
        of: find.text('Deposit to account'),
        matching: find.byType(Scaffold),
      ),
      matching: find.byType(ListView),
    );
    await tester.drag(depositForm, const Offset(0, -350));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Transfer from deposit account'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Transfer from deposit account'));
    await tester.pumpAndSettle();
    expect(find.text('Transfer from account'), findsOneWidget);
    await tester.tap(find.byType(DropdownButtonFormField<String>).first);
    await tester.pumpAndSettle();
    expect(find.text('High-yield Savings · •••• 9102').last, findsOneWidget);
    expect(find.text('Everyday Checking · •••• 4829'), findsNothing);
    await tester.tap(find.text('High-yield Savings · •••• 9102').last);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Review deposit'),
      160,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.drag(find.byType(ListView).last, const Offset(0, -160));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Review deposit'));
    await tester.pumpAndSettle();
    expect(find.text('Confirm demo transfer'), findsOneWidget);
    expect(find.textContaining('High-yield Savings'), findsNWidgets(2));
    await tester.tap(find.text('Confirm demo transfer'));
    await tester.pumpAndSettle();
    expect(find.text('Demo transfer ready'), findsOneWidget);
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Deposit statements'),
      120,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.drag(find.byType(ListView).last, const Offset(0, -120));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Deposit statements'));
    await tester.pumpAndSettle();
    expect(find.text('October 2026'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Home').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Loans'));
    await tester.pumpAndSettle();
    expect(find.text('Loan accounts'), findsOneWidget);
    await tester.tap(find.text('Details').first);
    await tester.pumpAndSettle();
    expect(find.text('Loan details'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('View loan statements'),
      160,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.drag(find.byType(ListView).last, const Offset(0, -200));
    await tester.pumpAndSettle();
    await tester.tap(find.text('View loan statements'));
    await tester.pumpAndSettle();
    expect(find.text('October 2026'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Pay now').first);
    await tester.pumpAndSettle();
    expect(find.text('Make a loan payment'), findsOneWidget);
    final loanPaymentForm = find.descendant(
      of: find.ancestor(
        of: find.text('Make a loan payment'),
        matching: find.byType(Scaffold),
      ),
      matching: find.byType(ListView),
    );
    await tester.drag(loanPaymentForm, const Offset(0, -350));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Transfer from deposit account'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Transfer from deposit account'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownButtonFormField<String>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('High-yield Savings · •••• 9102').last);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Review loan payment'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.drag(find.byType(ListView).last, const Offset(0, -250));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Review loan payment'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Confirm demo transfer'));
    await tester.pumpAndSettle();
    expect(find.text('Demo transfer ready'), findsOneWidget);
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
