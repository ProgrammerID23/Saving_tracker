import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saving_tracker/Controller/Client_Controler.dart';

class StorageController extends ClientController {
  Storage? storage;
  @override
  void onInit() {
    super.onInit();
// appwrite
    storage = Storage(client);
  }

  Future storeImage() async {
    try {
      final result = await storage!.createFile(
        bucketId: '6568612e3da504692b26',
        fileId: ID.unique(),
        file: InputFile.fromPath(
          path: './path-to-files/image.jpg',
          filename: 'image.jpg',
        ),
      );
      print("StorageController:: storeImage $result");
    } catch (error) {
      Get.defaultDialog(
        title: "Error Storage",
        titlePadding: const EdgeInsets.only(top: 15, bottom: 5),
        titleStyle: Get.context?.theme.textTheme.titleLarge,
        content: Text(
          "$error",
          style: Get.context?.theme.textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        contentPadding: const EdgeInsets.only(top: 5, left: 15, right: 15),
      );
    }
  }

  Future storeImageFromPicker(PickedFile pickedFile) async {
    try {
      final result = await storage!.createFile(
        bucketId: '6568612e3da504692b26',
        fileId: ID.unique(),
        file: InputFile.fromPath(
          path: pickedFile.path,
          filename: 'user_profile_image.jpg',
        ),
      );
      print("StorageController:: storeImage $result");
    } catch (error) {
      Get.defaultDialog(
        title: "Error Storage",
        titlePadding: const EdgeInsets.only(top: 15, bottom: 5),
        titleStyle: Get.context?.theme.textTheme.titleLarge,
        content: Text(
          "$error",
          style: Get.context?.theme.textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        contentPadding: const EdgeInsets.only(top: 5, left: 15, right: 15),
      );
    }
  }
}
