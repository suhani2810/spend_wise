import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spend_wise/main.dart';

void main() {
  testWidgets('SpendWise opens on the Expenses tab',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});

    await tester.pumpWidget(const SpendWiseApp());

    expect(find.text('Expenses'), findsWidgets);
    expect(find.text('Add Expense'), findsOneWidget);
  });
}
