import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter_database/models/Transactions.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class TransactionDB {
  //บริการเกี่ยวกับฐานข้อมูล

  late String dbName; //เก็บชื่อฐานข้อมูล
  //ถ้ายังไม่ถูกสร้างให้ทำการสร้าง
  //ถ้าถูกสร้างแล้วให้ทำการเปิด
  TransactionDB({required this.dbName});

  Future<Database?> openDatabase() async {
    //หาตำแหน่งที่จัดเก็บข้อมูล
    Directory appDirectory = await getApplicationDocumentsDirectory();
    String dbLocation = join(appDirectory.path, dbName);
    //สร้าง database
    // ignore: await_only_futures
    DatabaseFactory dbFactory = await databaseFactoryIo;
    Database db = await dbFactory.openDatabase(dbLocation);
    return db;
  }

  //บันทึกข้อมูล
  // ignore: non_constant_identifier_names
  Future<int> InsertData(Transactions statement) async {
    //ฐานข้อมูล ส่งเข้า Store
    var db = await this.openDatabase();
    var store = intMapStoreFactory.store("expense");

    //json
    var keyID = store.add(db!, {
      "title": statement.title,
      "province": statement.province,
      "amount": statement.amount,
      "date": statement.date.toIso8601String()
    });
    db.close();
    return keyID; // 1,2,3,4,..
  }

  //ดึงข้อมูล
  Future<List<Transactions>> loadAllData() async {
    var db = await this.openDatabase();
    var store = intMapStoreFactory.store("expense");
    var snapshot = await store.find(db!,
        finder: Finder(sortOrders: [
          SortOrder(Field.key, false)
        ])); //เรียงข้อมูลใหม่ไปเก่าใช้ false
    List<Transactions> transactionList = []; 
    for (var record in snapshot) {
      transactionList.add(Transactions(
          title: record["title"].toString(),
          province: record["province"].toString(),
          amount: double.parse(record["amount"].toString()),
          date: DateTime.parse(record["date"].toString())));
    }

    print(snapshot);
    return transactionList;
  }
}
