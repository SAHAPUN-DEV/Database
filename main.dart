import 'package:flutter/material.dart';
import 'package:flutter_database/Screens/form_screen.dart';
import 'package:flutter_database/Screens/home_screen.dart';
import 'package:flutter_database/providers/transaction_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'models/Transactions.dart'; //im หน้าสอง

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return TransactionProvider();
        }),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: MyHomePage(title: 'PEA N1 Harmonics Databese'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: TabBarView(
          children: [HomeScreen(), FormScreen()],
        ),
        bottomNavigationBar: TabBar(
          tabs: [
            Tab(
              icon: Icon(Icons.article_outlined),
              text: "Project Database",
            ),
            Tab(
              icon: Icon(Icons.addchart_rounded),
              text: "Create Project",
            )
          ],
        ),
      ),
    );
  }
}
