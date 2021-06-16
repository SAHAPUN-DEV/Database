import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_database/Screens/home_screen.dart';
import 'package:flutter_database/main.dart';
import 'package:flutter_database/models/Transactions.dart';
import 'package:flutter_database/providers/transaction_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_database/main.dart';
import 'package:firebase_core/firebase_core.dart';

class FormScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  // const FormScreen({Key? key}) : super(key: key);
  //controller
  final titleController = TextEditingController(); //รับชื่อหน่่วยงาน
  final amountController = TextEditingController(); //รับเลขจำนวนเงิน
  final provinceController = TextEditingController(); //จังหวัด
  //เตรียมFirebase
  // final Future<FirebaseApp> firebase = Firebase.initializeApp();
  CollectionReference _studentCollection =
      FirebaseFirestore.instance.collection("students");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Harmonics Calculator"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: new InputDecoration(labelText: "ชื่อหน่วยงาน"),
                  autofocus: false,
                  controller: titleController,
                  validator: (String? str) {
                    if (str!.isEmpty) {
                      return "กรุณาป้อนชื่อหน่วยงาน";
                    }
                    return null;
                  },
                ),
                TextFormField(
                    decoration: new InputDecoration(labelText: "จังหวัด"),
                    controller: provinceController,
                    validator: (String? str) {
                      if (str!.isEmpty) {
                        return "กรุณาป้อนชื่อจังหวัด";
                      }
                      return null;
                    }),
                TextFormField(
                  decoration: new InputDecoration(labelText: "จำนวนเงิน"),
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  validator: (String? str) {
                    if (str!.isEmpty) {
                      return "กรุณป้อนจำนวนเงิน";
                    }
                    if (double.tryParse(str)! <= 0) {
                      return "ป้อนจำนวนเงินผิดพลาด";
                    }
                    return null;
                  },
                ),
                // ignore: deprecated_member_use
                FlatButton(
                  child: Text("Submit"),
                  color: Colors.deepPurple,
                  textColor: Colors.black,
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      var title = titleController.text;
                      var province = provinceController.text;
                      var amount = amountController.text;
                      await _studentCollection.add({
                        "title": titleController,
                        "province": provinceController,
                        "amount": amountController
                      });
                      formKey.currentState!.reset();
                      //เตรียมข้อมูล
                      Transactions statement = Transactions(
                          title: title,
                          province: province,
                          amount: double.parse(amount),
                          date: DateTime.now());
                      //เรียก Provider
                      var provider = Provider.of<TransactionProvider>(context,
                          listen: false);
                      provider.addTransaction(statement);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              fullscreenDialog: true,
                              builder: (context) {
                                return MyHomePage(
                                  title: '',
                                );
                              }));
                    }
                  },
                )
              ],
            ),
          ),
        ));
  }
}
