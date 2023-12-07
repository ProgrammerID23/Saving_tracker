import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controller/Database_Controller.dart';
import '../Model/ExpenseModel.dart';

class AddExpenseForm extends StatefulWidget {
  final Function(Expense) onExpenseAdded;

  AddExpenseForm({required this.onExpenseAdded});

  @override
  _AddExpenseFormState createState() => _AddExpenseFormState();
}

class _AddExpenseFormState extends State<AddExpenseForm> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('Add Expense'),
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
          ),
          ListTile(
            leading: Icon(Icons.monetization_on),
            title: TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Amount'),
            ),
          ),
          ListTile(
            leading: Icon(Icons.date_range),
            title: TextField(
              controller: _dateController,
              decoration: InputDecoration(labelText: 'Date'),
            ),
          ),
          ListTile(
            leading: Icon(Icons.category),
            title: TextField(
              controller: _categoryController,
              decoration: InputDecoration(labelText: 'Category'),
            ),
          ),
          ListTile(
            leading: Icon(Icons.description),
            title: TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = _nameController.text;
              final amount = double.tryParse(_amountController.text) ?? 0.0;
              final date = _dateController.text;
              final category = _categoryController.text;
              final description = _descriptionController.text;

              if (name.isNotEmpty && amount > 0) {
                final expense = Expense(
                  name: name,
                  amount: amount,
                  date: date,
                  category: category,
                  description: description,
                );

                widget.onExpenseAdded(expense); // Memastikan notifikasi dikirim ke MyHomePage
              }
            },
            child: Text('Add Expense'),
          ),

        ],
      ),
    );
  }
}