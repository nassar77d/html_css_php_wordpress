import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditTransactionScreen extends StatefulWidget {
  final Map transaction;
  EditTransactionScreen(this.transaction);

  @override
  _EditTransactionScreenState createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String transactionType = "income";

  @override
  void initState() {
    super.initState();
    transactionType = widget.transaction["type"];
    amountController.text = widget.transaction["amount"];
    descriptionController.text = widget.transaction["description"];
    updateTransaction();
  }

  Future<void> updateTransaction() async {
    var url = Uri.parse("http://127.0.0.1/waqf_api/update_transaction.php");
    var response = await http.post(url, body: {
      "id": widget.transaction["id"],
      "type": transactionType,
      "amount": amountController.text,
      "description": descriptionController.text,
    });

    var data = json.decode(response.body);
    if (data["status"] == "success") {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("فشل في تحديث بيانات المعاملة")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("تعديل بيانات المعاملة")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField(
              value: transactionType,
              items: [
                DropdownMenuItem(value: "income", child: Text("إيراد")),
                DropdownMenuItem(value: "expense", child: Text("مصروف")),
              ],
              onChanged: (value) {
                setState(() {
                  transactionType = value!;
                });
              },
            ),
            TextField(controller: amountController, decoration: InputDecoration(labelText: "المبلغ")),
            TextField(controller: descriptionController, decoration: InputDecoration(labelText: "الوصف")),
            SizedBox(height: 20),
            ElevatedButton(onPressed: updateTransaction, child: Text("تحديث")),
          ],
        ),
      ),
    );
  }
}
