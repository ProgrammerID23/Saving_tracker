import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:saving_tracker/Controller/Client_Controler.dart';

import '../Model/ExpenseModel.dart';

class DatabaseController extends ClientController {
  late final Databases database;
  late Function() refreshCallback;

  void setRefreshCallback(Function() callback) {
    refreshCallback = callback; // Atur fungsi callback
  }

  @override
  void onInit() {
    super.onInit();
    // Inisialisasi koneksi ke Appwrite di sini
    database = Databases(client);
  }

  Future<double> getTotalExpensesAmount() async {
    try {
      final response = await database.listDocuments(
        collectionId: '65686a8e93f156168fed', // Ganti dengan ID koleksi di Appwrite
        databaseId: '656850265be9cb7d20c9', // Ganti dengan ID database di Appwrite
      );

      final List<Document> documents = response.documents;

      // Hitung total amount dari semua pengeluaran
      double totalAmount = 0;
      for (final document in documents) {
        final amount = document.data['Amount'];
        if (amount != null && amount is num) {
          totalAmount += amount.toDouble();
        }
      }

      return totalAmount;
    } catch (error) {
      print("Error retrieving expenses: $error");
      return 0;
    }
  }

  Future<void> addExpenseToAppwrite(Expense expense) async {
    try {
      final data = {
        'Name': expense.name,
        'Amount': expense.amount,
        'Date': expense.date,
        'Category': expense.category,
        'Description': expense.description,
      };

      final response = await database.createDocument(
        collectionId: '65686a8e93f156168fed',// Ganti dengan ID koleksi di Appwrite
        data: data,
        databaseId: '656850265be9cb7d20c9',
        documentId: ID.unique(),
      );

      print('Expense added to Appwrite: ${response.data}');
      Get.snackbar('Success', 'Added to Appwrite',
          backgroundColor: Colors.green);
    } catch (e) {
      print('Error adding expense to Appwrite: $e');
      Get.snackbar('Error', 'Added to Appwrite',
          backgroundColor: Colors.red);
    }
  }

  Future<List<Document>> getExpensesFromAppwrite() async {
    try {
      final response = await database.listDocuments(
        collectionId: "65686a8e93f156168fed",
        databaseId: '656850265be9cb7d20c9',
      );
      Get.snackbar('Success', 'Get from Appwrite',
          backgroundColor: Colors.green);
      return response.documents;
    } catch (error) {
      Get.snackbar('Error', 'Get from Appwrite',
          backgroundColor: Colors.red);
      return [];
    }
  }


  Future<void> updateExpenseInAppwrite(String documentId,
      Expense expense) async {
    try {
      final data = {
        'Name': expense.name,
        'Amount': expense.amount,
        'Date': expense.date,
        'Category': expense.category,
        'Description': expense.description,
      };
      final response = await database.updateDocument(
        collectionId: '65686a8e93f156168fed',
        // Ganti dengan ID koleksi di Appwrite
        databaseId: '656850265be9cb7d20c9',
        documentId: documentId,
        // ID dokumen yang akan diperbarui
        data: data,
      );

      print('Expense updated in Appwrite: ${response.data}');
    } catch (e) {
      print('Error updating expense in Appwrite: $e');
    }
  }

  Future<void> deleteExpenseFromAppwrite(String documentId) async {
    try {
      final response = await database.deleteDocument(
        collectionId: '65686a8e93f156168fed',
        // Ganti dengan ID koleksi di Appwrite
        databaseId: '656850265be9cb7d20c9',
        documentId: documentId, // ID dokumen yang akan dihapus
      );

      print('Expense deleted from Appwrite: ${response.data}');
    } catch (e) {
      print('Error deleting expense from Appwrite: $e');
    }
  }
}
