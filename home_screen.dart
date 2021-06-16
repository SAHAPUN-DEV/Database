import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_database/models/Transactions.dart';
import 'package:flutter_database/providers/transaction_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<TransactionProvider>(context, listen: false).initdata();
    //ให้provider ไปเตรียมข้อมูลมาแสดงในตอนเริ่มต้นแอป
  }

  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Error"),
              ),
              body: Center(
                child: Text("${snapshot.error}"),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
                appBar: AppBar(
                  title: Text("PEA N1 Harmonics Database"),
                  actions: [
                    IconButton(
                        onPressed: () {
                          SystemNavigator.pop();
                        },
                        icon: Icon(Icons.exit_to_app))
                  ],
                ),
                body: Consumer(builder:
                    (context, TransactionProvider provider, Widget? child) {
                  var count = provider.transactions.length; // นับจำนวนข้อมูล
                  if (count <= 0) {
                    return Center(
                      child: Text(
                        "No database found !!",
                        style: TextStyle(fontSize: 35),
                      ),
                    );
                  } else {
                    return ListView.builder(
                        itemCount: count,
                        itemBuilder: (context, int index) {
                          Transactions data = provider.transactions[index];
                          return Card(
                            elevation: 5,
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
                            child: ListTile(
                                leading: CircleAvatar(
                                  radius: 20,
                                  child: FittedBox(
                                    child: Text(data.amount.toString()),
                                  ),
                                ),
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      data.title,
                                      style: TextStyle(fontSize: 17.5),
                                    ),
                                    Text("-"),
                                    Text(
                                      data.province,
                                      style: TextStyle(fontSize: 17.5),
                                    )
                                  ],
                                ),
                                subtitle: Text(
                                  DateFormat("dd/MM/yyy").format(data.date),
                                ),
                                trailing:
                                    // Text(data.province)
                                    IconButton(
                                        icon: Icon(Icons.delete),
                                        iconSize: 20,
                                        color: Colors.black,
                                        onPressed: () {})
                                //     Row(
                                //   mainAxisAlignment: MainAxisAlignment.end,
                                //   children: [Text(data.province)],
                                // )
                                ),
                          );
                        });
                  }
                }));
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
