import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Controller/Database_Controller.dart';

class Expense {
  final String name;
  final double amount;
  final String date;
  final String category;
  final String description;

  Expense({
    required this.name,
    required this.amount,
    required this.date,
    required this.category,
    required this.description,
  });
}

class ExpenseModel with ChangeNotifier {
  List<Expense> expenses = [];
  late final Databases database;

  double get totalExpense =>
      expenses.fold(0, (previous, current) => previous + current.amount);

  void addExpense(Expense expense) async{
    expenses.add(expense);
    notifyListeners();
  }
}