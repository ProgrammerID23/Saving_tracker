import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saving_tracker/Controller/StorageCpntrololer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Controller/Database_Controller.dart';
import '../Model/ExpenseModel.dart';

class UserProfile extends StatefulWidget {
  final ExpenseModel controller; // Gantilah dengan ExpenseModel yang sesuai
  final String username;

  UserProfile({required this.controller, required this.username});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  File? _pickedImage; // Menyimpan gambar yang dipilih oleh pengguna
  final _imagePicker = ImagePicker();
  late double totalExpenses = 0;
  final DatabaseController _databaseController = DatabaseController();

  @override
  void initState() {
    super.initState();
    _fetchTotalExpenses;
    _getSavedImagePath().then((imagePath) {
      if (imagePath != null) {
        setState(() {
          _pickedImage = File(imagePath);
        });
      }
    });
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final pickedFile = await _imagePicker.getImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });

      // Simpan path gambar ke SharedPreferences
      _saveImagePath(pickedFile.path);

      Get.find<StorageController>().storeImageFromPicker(pickedFile);
    }
  }

  Future<void> _saveImagePath(String imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image', imagePath);
  }

  Future<String?> _getSavedImagePath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('profile_image');
  }

  Future<void> _fetchTotalExpenses() async {
    try {
      final totalAmount = await _databaseController.getTotalExpensesAmount();
      setState(() {
        totalExpenses = totalAmount;
      });
    } catch (error) {
      print("Error fetching total expenses: $error");
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: _pickedImage != null
                  ? FileImage(
                      _pickedImage!) // Gunakan gambar yang dipilih jika ada
                  : AssetImage('images/Space Travel Images/astronaut.png')
                      as ImageProvider,
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 150,
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.camera),
                              title: Text('Ambil Foto dari Kamera'),
                              onTap: () {
                                Navigator.pop(context);
                                _pickImage(context, ImageSource.camera);
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.photo_library),
                              title: Text('Pilih dari Galeri'),
                              onTap: () {
                                Navigator.pop(context);
                                _pickImage(context, ImageSource.gallery);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Salam Hangat,',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            Text(
              widget.username,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Total Expenses: \$${totalExpenses.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 20,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
