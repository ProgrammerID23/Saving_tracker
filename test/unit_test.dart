import 'package:flutter_test/flutter_test.dart';
import 'package:saving_tracker/Model/ExpenseModel.dart';

void main() {
  test('Test addExpense in ExpenseModel', () {
    // Arrange
    final expenseModel = ExpenseModel();
    final initialExpensesLength = expenseModel.expenses.length;
    final expense = Expense(
      name: 'Test Expense',
      amount: 100.0,
      date: '2023-12-19',
      category: 'Test Category',
      description: 'Test Description',
    );

    // Act
    expenseModel.addExpense(expense);

    // Assert
    expect(expenseModel.expenses.length, initialExpensesLength + 1);
    expect(expenseModel.expenses.last.name, 'Test Expense');
    expect(expenseModel.expenses.last.amount, 100.0);
    expect(expenseModel.expenses.last.date, '2023-12-19');
    // ...Tambahkan asertif lain sesuai dengan informasi yang diharapkan dari expense yang ditambahkan
  });

}
