import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Model/ExpenseModel.dart';

class TotalExpenses extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final totalExpense = Provider.of<ExpenseModel>(context).totalExpense;

    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Total Expenses:',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '\$${totalExpense.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 30,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
