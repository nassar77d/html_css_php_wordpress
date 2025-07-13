import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'add_transaction_screen.dart';
import 'edit_transaction_screen.dart';

class TransactionsScreen extends StatefulWidget {
  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  List transactions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTransactions();

  }

  Future<void> fetchTransactions() async {
    var url = Uri.parse("http://127.0.0.1/waqf_api/get_transactions.php");
    var response = await http.get(url);
    var data = json.decode(response.body);

    if (data["status"] == "success") {
      setState(() {
        transactions = data["transactions"];
        isLoading = false;
      });
    }
  }

  Future<void> deleteTransaction(int id) async {
    var url = Uri.parse("http://127.0.0.1/waqf_api/delete_transaction.php");
    var response = await http.post(url, body: {"id": id.toString()});
    var data = json.decode(response.body);

    if (data["status"] == "success") {
      fetchTransactions();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("فشل في حذف المعاملة")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("إدارة الإيرادات والمصاريف")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          var transaction = transactions[index];
          return Card(
            child: ListTile(
              title: Text(transaction["description"]),
              subtitle: Text("المبلغ: ${transaction["amount"]}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditTransactionScreen(transaction),
                        ),
                      ).then((_) => fetchTransactions());
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteTransaction(int.parse(transaction["id"])),
                  ),

                ],

              ),
            ),
          );

        },

      ),
floatingActionButton: FloatingActionButton(onPressed: (){
  Navigator.push(context, MaterialPageRoute(builder: (context)=>AddTransactionScreen()));
},child: Icon(Icons.add),),
    );
  }
}