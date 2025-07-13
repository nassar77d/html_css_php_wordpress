import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'edit_beneficiary_screen.dart';
import 'add_beneficiary_screen.dart';

class BeneficiaryScreen extends StatefulWidget {
  @override
  _BeneficiaryScreenState createState() => _BeneficiaryScreenState();
}

class _BeneficiaryScreenState extends State<BeneficiaryScreen> {
  List beneficiaries = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBeneficiaries();
  }

  Future<void> fetchBeneficiaries() async {
    var url = Uri.parse("http://127.0.0.1/waqf_api/get_beneficiaries.php");
    var response = await http.get(url);
    var data = json.decode(response.body);

    if (data["status"] == "success") {
      setState(() {
        beneficiaries = data["beneficiaries"];
        isLoading = false;
      });
    }
  }

  Future<void> deleteBeneficiary(int id) async {
    var url = Uri.parse("http://127.0.0.1/waqf_api/delete_beneficiary.php");
    var response = await http.post(url, body: {"id": id.toString()});
    var data = json.decode(response.body);

    if (data["status"] == "success") {
      fetchBeneficiaries();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("فشل في حذف المستفيد")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("إدارة المستفيدين")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: beneficiaries.length,
        itemBuilder: (context, index) {
          var beneficiary = beneficiaries[index];
          return Card(
            child: ListTile(
              title: Text(beneficiary["name"]),
              subtitle: Text(
                "رقم الهوية: ${beneficiary["id_number"]}\n"
                    "رقم الهاتف: ${beneficiary["phone"]}\n"
                    "العنوان: ${beneficiary["address"]}\n"
                    "المبلغ: ${beneficiary["aid_amount"]} ريال\n"
                    "تابع لوقف: ${beneficiary["waqf_name"]}",
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditBeneficiaryScreen(beneficiary),
                        ),
                      ).then((_) => fetchBeneficiaries());
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () =>
                        deleteBeneficiary(int.parse(beneficiary["id"])),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddBeneficiaryScreen()),
          ).then((_) => fetchBeneficiaries());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}