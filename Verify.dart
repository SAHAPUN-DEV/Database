/// Flutter code sample for AlertDialog

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

void main() => runApp(const MyApp());

/// This is the main application widget.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'HARMONICS CALULCATOR';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(_title),
          backgroundColor: Colors.deepPurple,
        ),
        body: const Center(
          child: MyStatelessWidget(),
        ),
      ),
    );
  }
}

/// This is the stateless widget that the main application instantiates.
class MyStatelessWidget extends StatelessWidget {
  const MyStatelessWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TextEditingController _uidController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final uidValidator = MultiValidator([
      RequiredValidator(errorText: 'กรุณาป้อนเลขบัญชีผู้ใช้ไฟ'),
      MinLengthValidator(11, errorText: 'เลขผู้ใช้ไฟต้องมีจำนวน 11 หลัก'),
      MaxLengthValidator(11, errorText: 'เลขผู้ใช้ไฟต้องมีจำนวน 11 หลัก')
    ]);
    String uid = "..."; //ตัวแปลรับค่าเลขผู้ใช่ไฟ 11 หลัก
    // ignore: deprecated_member_use
    return FlatButton(
      color: Colors.deepPurple, //สีปุ่ม
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          backgroundColor: Colors.white, //transparent
          title: const Text(
            'กรุณาป้อนเลขบัญชีผู้ใช้ไฟ',
          ),
          content: Form(
            key: formKey,
            child: Column(children: [
              TextFormField(
                keyboardType: TextInputType.number,
                obscureText: false,
                onChanged: (val) => uid = val,
                // assign the the multi validator to the TextFormField validator
                validator: uidValidator,
              ),
              Text("ยืนยันเลขบัญชีผู้ใช้ไฟ"),
              TextFormField(
                keyboardType: TextInputType.number,
                obscureText: false,
                validator: (val) => MatchValidator(
                        errorText: 'กรุณากรอกเลขบัญชีผู้ใช้ไฟให้ตรงกัน')
                    .validateMatch(val!, uid),
              ),
              // using the match validator to confirm password
            ]),
          ),
          actions: <Widget>[
            // ignore: deprecated_member_use
            RaisedButton(
                color: Colors.deepPurple.shade300, //transparent //shade 300
                child: Text("Submit"),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                    side: BorderSide(color: Colors.black)),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    print(uid); //ลองปริ้นค่าดู
                  }
                }),
          ],
        ),
      ),
      child: const Text(
        'กดเพื่อเริ่มใช้งาน',
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
