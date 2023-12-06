import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Model/ExpenseModel.dart';

class ExpenseList extends StatelessWidget {
  final List<Expense> expenses;

  ExpenseList({required this.expenses});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final expense = expenses[index];
        return ListTile(
          title: Text(expense.name),
          subtitle: Text('Amount: \$${expense.amount.toStringAsFixed(2)}'),
        );
      },
    );
  }
}