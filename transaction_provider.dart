import 'package:flutter/foundation.dart';
import 'package:flutter_database/database/transaction_db.dart';
import 'package:flutter_database/models/Transactions.dart';

class TransactionProvider with ChangeNotifier {
  //Example
  List<Transactions> transactions = [];

  List<Transactions> getTransaction() {
    return transactions;
  } //ดึงข้อมูล

  void initdata() async {
    var db = TransactionDB(dbName: "transactions.db");
    //ดึงข้อมูลมาแสดงผล
    transactions = await db.loadAllData();
    notifyListeners();
  } //ดึงข้อมูลมาแสดงผลในตอนเปิดแอป

  void addTransaction(Transactions statement) async {
    var db = TransactionDB(dbName: "transactions.db");
    //บันทึกข้อมูล
    await db.InsertData(statement);
    //ดึงข้อมูลมาแสดงผล
    transactions = await db.loadAllData();
    // transactions.insert(0, statement);
    //แจ้งเตือน Consumer
    notifyListeners();
  } //เพิ่ม
//ค่อยๆทำไป reverse step !!!!!!!!!
  // void removeTransaction(Transactions statement) async {
  //   var db = TransactionDB(dbName: "transactions.db");
  //   await transactions.remove(statement);
  //   transactions = await db.loadAllData();
  //   notifyListeners();
  // } //ลบ
}
