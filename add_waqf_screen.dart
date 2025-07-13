import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddWaqfScreen extends StatefulWidget {
  @override
  _AddWaqfScreenState createState() => _AddWaqfScreenState();
}

class _AddWaqfScreenState extends State<AddWaqfScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController revenueController = TextEditingController();
  TextEditingController expensesController = TextEditingController();
@override
  void initState() {
  super.initState();
 
}

  Future<void> addWaqf() async {
    var url = Uri.parse("http://127.0.0.1/waqf_api/add_waqf.php");
    var response = await http.post(url, body: {
      "name": nameController.text,
      "type": typeController.text,
      "location": locationController.text,
      "revenue": revenueController.text,
      "expenses": expensesController.text,
    });

    var data = json.decode(response.body);
    if (data["status"] == "success") {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("فشل في إضافة الوقف")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("إضافة وقف جديد")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: "اسم الوقف")),
            TextField(controller: typeController, decoration: InputDecoration(labelText: "نوع الوقف")),
            TextField(controller: locationController, decoration: InputDecoration(labelText: "الموقع")),
            TextField(controller: revenueController, decoration: InputDecoration(labelText: "الإيرادات")),
            TextField(controller: expensesController, decoration: InputDecoration(labelText: "المصاريف")),
            SizedBox(height: 20),
            ElevatedButton(onPressed: addWaqf, child: Text("إضافة")),
          ],
        ),
      ),
    );
  }
}