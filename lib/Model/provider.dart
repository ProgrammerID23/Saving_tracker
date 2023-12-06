import 'package:flutter/foundation.dart';

class AppState with ChangeNotifier {
  double savings = 10000.0; // Total awal tabungan

  void updateSavings(double newSavings) {
    savings = newSavings;
    notifyListeners(); // Pemberitahuan ke pendengar yang mendaftarkan diri
  }
}
