import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Model/ExpenseModel.dart';

class ExpenseEdit extends StatefulWidget {
  final Function(Expense) onExpenseAdded;
  final Expense existingExpense; // New property to store existing expense data

  ExpenseEdit({required this.onExpenseAdded, required this.existingExpense});

  @override
  _ExpenseEditState createState() => _ExpenseEditState();
}

class _ExpenseEditState extends State<ExpenseEdit> {
  late TextEditingController _nameController;
  late TextEditingController _amountController;
  late TextEditingController _dateController;
  late TextEditingController _categoryController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existingExpense.name);
    _amountController = TextEditingController(text: widget.existingExpense.amount.toString());
    _dateController = TextEditingController(text: widget.existingExpense.date);
    _categoryController = TextEditingController(text: widget.existingExpense.category);
    _descriptionController = TextEditingController(text: widget.existingExpense.description);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('Edit Expense'),
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
              final editedExpense = Expense(
                name: _nameController.text,
                amount: double.tryParse(_amountController.text) ?? 0.0,
                date: _dateController.text,
                category: _categoryController.text,
                description: _descriptionController.text,
              );
              widget.onExpenseAdded(editedExpense);
            },
            child: Text('Edit Expense'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
