import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:saving_tracker/Controller/Database_Controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Views/LoginPage.dart';


class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final SharedPreferences _prefs = Get.find<SharedPreferences>();
  RxBool isLoading = false.obs;
  RxBool isLoggedIn = false.obs;


  Future<void> registerUser(String email, String password) async {
    try {
      isLoading.value = true;
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.snackbar('Success', 'Registration successful',
          backgroundColor: Colors.green);
    } catch (error) {
      Get.snackbar('Error', 'Registration failed: $error',
          backgroundColor: Colors.red);
      Get.off(LoginPage());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus(); // Cek status login saat controller diinisialisasi
  }
  Future<void> checkLoginStatus() async {
    isLoggedIn.value = _prefs.containsKey('user_token');
  }

  Future<void> loginUser(String email, String password) async {
    try {
      isLoading.value = true;
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.snackbar('Success', 'Login successful', backgroundColor: Colors.green);
      Get.offAllNamed('/home');
    } catch (error) {
      Get.snackbar('Error', 'Login failed: $error', backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    _prefs.remove('user_token'); // Hapus token autentikasi dari penyimpanan
    isLoggedIn.value = false; // Set status login menjadi false
    _auth.signOut(); // Sign out dari Firebase Authentication
    Get.offAllNamed('/login'); // Navigate ke HomePage dan hapus semua halaman sebelumnya
  }

}