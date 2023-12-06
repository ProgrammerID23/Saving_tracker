import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

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
            onPressed: () {
              // Ambil data dari input
              final name = _nameController.text;
              final amount = double.tryParse(_amountController.text) ?? 0.0;
              final date = _dateController.text;
              final category = _categoryController.text;
              final description = _descriptionController.text;

              // Buat objek Expense
              if (name.isNotEmpty && amount > 0) {
                final expense = Expense(
                  name: name,
                  amount: amount,
                  date: date,
                  category: category,
                  description: description,
                );

                // Dapatkan instance dari DatabaseController
                DatabaseController databaseController = Get.find<DatabaseController>();

                // Panggil fungsi addExpenseToAppwrite dengan expense yang baru
                databaseController.addExpenseToAppwrite(expense);

                // Bersihkan input fields
                _nameController.clear();
                _amountController.clear();
                _dateController.clear();
                _categoryController.clear();
                _descriptionController.clear();

                setState(() {});
              }
            },
            child: Text('Add Expense'),
          ),
        ],
      ),
    );
  }
}