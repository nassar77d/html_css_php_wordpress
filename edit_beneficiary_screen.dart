import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditBeneficiaryScreen extends StatefulWidget {
  final Map beneficiary;
  EditBeneficiaryScreen(this.beneficiary);

  @override
  _EditBeneficiaryScreenState createState() => _EditBeneficiaryScreenState();
}

class _EditBeneficiaryScreenState extends State<EditBeneficiaryScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController idNumberController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController aidAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.beneficiary["name"];
    idNumberController.text = widget.beneficiary["id_number"];
    phoneController.text = widget.beneficiary["phone"];
    addressController.text = widget.beneficiary["address"];
    aidAmountController.text = widget.beneficiary["aid_amount"];
    updateBeneficiary();
  }

  Future<void> updateBeneficiary() async {
    var url = Uri.parse("http://127.0.0.1/waqf_api/update_beneficiary.php");
    var response = await http.post(url, body: {
      "id": widget.beneficiary["id"],
      "name": nameController.text,
      "id_number": idNumberController.text,
      "phone": phoneController.text,
      "address": addressController.text,
      "aid_amount": aidAmountController.text,
    });

    var data = json.decode(response.body);
    if (data["status"] == "success") {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("فشل في تحديث بيانات المستفيد")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("تعديل بيانات المستفيد")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: "اسم المستفيد")),
            TextField(controller: idNumberController, decoration: InputDecoration(labelText: "رقم الهوية")),
            TextField(controller: phoneController, decoration: InputDecoration(labelText: "رقم الهاتف")),
            TextField(controller: addressController, decoration: InputDecoration(labelText: "العنوان")),
            TextField(controller: aidAmountController, decoration: InputDecoration(labelText: "المبلغ المخصص")),
            SizedBox(height: 20),
            ElevatedButton(onPressed: updateBeneficiary, child: Text("تحديث")),
          ],
        ),
      ),
    );
  }
}