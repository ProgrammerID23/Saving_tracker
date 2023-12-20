import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saving_tracker/Views/AddExpense.dart';
 // Sesuaikan dengan path yang sesuai

void main() {
  testWidgets('AddExpenseForm UI Test', (WidgetTester tester) async {
    // Build AddExpenseForm widget
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: AddExpenseForm(
          onExpenseAdded: (expense) {},
        ),
      ),
    ));

    // Verifikasi bahwa widget AddExpenseForm dan elemennya telah dirender dengan benar
    expect(find.byType(AddExpenseForm), findsOneWidget);
    expect(find.byType(Card), findsOneWidget);
    expect(find.byType(ListTile), findsNWidgets(6)); // 6 ListTiles
    expect(find.byType(ElevatedButton), findsOneWidget);

    // Coba memasukkan nilai pada TextField dan tekan tombol
    await tester.enterText(find.byType(TextField).at(0), 'Test Name');
    await tester.enterText(find.byType(TextField).at(1), '100');
    await tester.enterText(find.byType(TextField).at(2), '2023-12-19');
    await tester.enterText(find.byType(TextField).at(3), 'Test Category');
    await tester.enterText(find.byType(TextField).at(4), 'Test Description');

    // Tekan tombol Add Expense
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

// Pastikan teks yang dimasukkan muncul setelah tombol ditekan
    expect(find.text('Test Name'), findsOneWidget);
  
  });
}
