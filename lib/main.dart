import 'package:appwrite/models.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:saving_tracker/Controller/StorageCpntrololer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'Views/AddExpense.dart';
import 'Controller/Database_Controller.dart';
import 'Controller/notification_handler.dart';
import 'Model/ExpenseModel.dart';
import 'Views/EditExpense.dart';
import 'Views/LoginPage.dart';
import 'Views/RegisterPage.dart';
import 'package:saving_tracker/Views/BudgetView.dart';
import 'Views/UserProfile.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Get.putAsync(() async => await SharedPreferences.getInstance());
  await FirebaseMessagingHandler().initPushNotification();
  await FirebaseMessagingHandler().initLocalNotification();
  Get.put(DatabaseController());
  Get.put(StorageController());

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/register', page: () => RegisterPage()),
        GetPage(
          name: '/home',
          page: () => ChangeNotifierProvider(
            create: (context) => ExpenseModel(),
            child: MyApp(),
          ),
        ),
        GetPage(
            name: '/userProfile',
            page: () =>
                UserProfilePage()), // Tambahkan rute untuk halaman profil
      ],
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saving Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
      routes: {
        '/userProfile': (context) =>
            UserProfile(username: 'User Name', controller: ExpenseModel()),
        // Tambahkan rute untuk halaman profil dengan parameter username dan controller yang sesuai
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Document> appwriteExpenses = [];
  bool isExpenseFormVisible = false;
  late DatabaseController databaseController;

  @override
  void initState() {
    super.initState();
    databaseController = Get.find<DatabaseController>();
    refreshExpenses();
    fetchAppwriteExpenses();
  }

  void _addExpense(Expense expense) async {
    await databaseController.addExpenseToAppwrite(expense);
    await fetchAppwriteExpenses(); // Ambil data yang diperbarui setelah menambahkan pengeluaran baru

    // Setelah menambahkan data, pastikan untuk menampilkan kembali form input jika diperlukan
    setState(() {
      isExpenseFormVisible = false;
    });
  }

  Future<void> _deleteExpense(Document document) async {
    await databaseController.deleteExpenseFromAppwrite(document.$id);
    await fetchAppwriteExpenses(); // Ambil data yang diperbarui
    setState(() {
      appwriteExpenses.remove(document);
    });
  }

  Future<void> fetchAppwriteExpenses() async {
    final databaseController = Get.find<DatabaseController>();
    final expenses = await databaseController.getExpensesFromAppwrite();
    setState(() {
      appwriteExpenses = expenses;
    });
  }

  void toggleExpenseFormVisibility() {
    setState(() {
      isExpenseFormVisible = !isExpenseFormVisible;
    });
  }

  void _editExpense(Document document) {
    Get.to(ExpenseEdit(
      existingExpense: Expense(
        name: document.data['Name'],
        amount: (document.data['Amount'] as num).toDouble(),
        date: document.data['Date'],
        category: document.data['Category'],
        description: document.data['Description'] ?? '',
      ),
      onExpenseAdded: (editedExpense) async {
        await databaseController.updateExpenseInAppwrite(
            document.$id, editedExpense);
        fetchAppwriteExpenses(); // Refresh list after edit
      },
    ));
  }

  Future<void> refreshExpenses() async {
    final expenses = await databaseController.getExpensesFromAppwrite();
    setState(() {
      appwriteExpenses = expenses;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracking App'),
        actions: [
          IconButton(
            icon: Icon(Icons.language),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return WebViewPage(url: 'https://app.bibit.id');
                },
              ));
            },
          ),
          IconButton(
            icon: Icon(Icons.attach_money),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return BudgetScreen();
                },
              ));
            },
          ),
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => UserProfile(
                    username: 'User Name', controller: ExpenseModel()),
              ));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<ExpenseModel>(
              builder: (context, expenseModel, child) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: appwriteExpenses.length,
                  itemBuilder: (context, index) {
                    final document = appwriteExpenses[index];
                    final name = document.data['Name'];
                    final amount = document.data['Amount'];
                    final date = document.data['Date'];
                    final category = document.data['Category'];
                    final description = document.data['Description'];

                    return GestureDetector(
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Choose Action'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    GestureDetector(
                                      child: Text('Edit'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        _editExpense(document);
                                      },
                                    ),
                                    SizedBox(height: 10),
                                    GestureDetector(
                                      child: Text('Delete'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        _deleteExpense(document);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: ExpansionTile(
                        title: Text(name),
                        children: [
                          ListTile(
                            title: Text('Name: $name'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Amount: $amount'),
                                Text('Date: $date'),
                                Text('Category: $category'),
                                if (description != null &&
                                    description.isNotEmpty)
                                  Text('Description: $description'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            isExpenseFormVisible
                ? AddExpenseForm(
                    onExpenseAdded: (expense) async {
                      _addExpense(
                          expense); // Memanggil _addExpense yang diperbarui
                      fetchAppwriteExpenses(); // Memperbarui daftar setelah menambahkan expense baru
                    },
                  )
                : Container(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleExpenseFormVisibility,
        child: Icon(Icons.add),
      ),
    );
  }
}

class UserProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Center(
        child: Text('This is the User Profile page'),
      ),
    );
  }
}

class WebViewPage extends StatelessWidget {
  final String url;

  WebViewPage({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bibit Web'),
      ),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
