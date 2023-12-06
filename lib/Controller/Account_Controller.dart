import 'package:appwrite/appwrite.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:saving_tracker/Views/LoginPage.dart';

import 'Client_Controler.dart';

class AccountController extends ClientController {
  Account? account;
  RxBool isLoading = false.obs;
  RxBool isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    // appwrite
    account = Account(client);
  }

  Future<void> createAccount(Map<String, dynamic> map) async {
    try {
      final result = await account!.create(
        userId: map['userId'],
        email: map['email'],
        password: map['password'],
        name: map['name'],
      );
      Get.off(LoginPage());
      print("AccountController:: createAccount $result");
    } catch (error) {
      _showErrorDialog("Error Account", "$error");
    }
  }

  Future<void> createEmailSession(Map<String, dynamic> map) async {
    try {
      final result = await account!.createEmailSession(
        email: map['email'],
        password: map['password'],
      );
      print("AccountController:: createEmailSession $result");
    } catch (error) {
      _showErrorDialog("Error Account", "$error");
    }
  }

  Future<void> loginUser(String email, String password) async {
    try {
      isLoading.value = true;
      final result = await account!.createEmailSession(
        email: email,
        password: password,
      );
      // If login is successful, mark user as logged in
      isLoggedIn.value = true;
      isLoading.value = false;
      print("AccountController:: loginUser $result");
    } catch (error) {
      isLoading.value = false;
      _showErrorDialog("Error Account", "$error");
    }
  }

  void _showErrorDialog(String title, String content) {
    Get.defaultDialog(
      title: title,
      titlePadding: const EdgeInsets.only(top: 15, bottom: 5),
      titleStyle: Get.context?.theme.textTheme.titleLarge,
      content: Text(
        content,
        style: Get.context?.theme.textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
      contentPadding: const EdgeInsets.only(top: 5, left: 15, right: 15),
    );
  }
}