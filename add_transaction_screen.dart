import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTransactionScreen extends StatefulWidget {
  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String transactionType = "income";


  List<Map<String, dynamic>> transactions = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchTransactions();
    addTransaction();
  }


  Future<void> fetchTransactions() async {
    var url = Uri.parse("http://127.0.0.1/waqf_api/get_transactions.php");
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {

        List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          transactions = List<Map<String, dynamic>>.from(jsonData);
        });
      }
    } catch (e) {
      print("Error fetching transactions: $e");
    }
  }


  Future<void> addTransaction() async {
    var url = Uri.parse("http://127.0.0.1/waqf_api/add_transaction.php");
    try {
      var response = await http.post(url, body: {
        "type": transactionType,
        "amount": amountController.text,
        "description": descriptionController.text,
      });


    } catch (e) {
      print("Error adding transaction: $e");

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("إضافة معاملة مالية"),
      ),
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

            TextField(
              controller: amountController,
              decoration: InputDecoration(labelText: "المبلغ"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: "الوصف"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: addTransaction,
              child: Text("إضافة"),
            ),
            SizedBox(height: 20),


          ],
        ),
      ),
    );
  }
}




