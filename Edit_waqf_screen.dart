import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditWaqfScreen extends StatefulWidget {
  final Map waqf;
  EditWaqfScreen(this.waqf);

  @override
  _EditWaqfScreenState createState() => _EditWaqfScreenState();
}

class _EditWaqfScreenState extends State<EditWaqfScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController revenueController = TextEditingController();
  TextEditingController expensesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.waqf["name"];
    revenueController.text = widget.waqf["revenue"];
    expensesController.text = widget.waqf["expenses"];
    updateWaqf();
  }

  Future<void> updateWaqf() async {
    var url = Uri.parse("http://127.0.0.1/waqf_api/update_waqf.php");
    var response = await http.post(url, body: {
      "id": widget.waqf["id"],
      "name": nameController.text,
      "revenue": revenueController.text,
      "expenses": expensesController.text,
    });

    var data = json.decode(response.body);

    if (data["status"] == "success") {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("فشل في تعديل الوقف")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("تعديل الوقف")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "اسم الوقف"),
            ),
            TextField(
              controller: revenueController,
              decoration: InputDecoration(labelText: "الإيرادات"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: expensesController,
              decoration: InputDecoration(labelText: "المصاريف"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateWaqf,
              child: Text("تحديث"),
            ),
          ],
        ),
      ),
    );
  }
}