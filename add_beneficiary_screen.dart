import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddBeneficiaryScreen extends StatefulWidget {
  @override
  _AddBeneficiaryScreenState createState() => _AddBeneficiaryScreenState();
}

class _AddBeneficiaryScreenState extends State<AddBeneficiaryScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController idNumberController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController aidAmountController = TextEditingController();
  TextEditingController waqfIdController = TextEditingController(); // رقم الوقف المرتبط

  @override
  void initState() {

    super.initState();
    addBeneficiary();
  }
  Future<void> addBeneficiary() async {
    var url = Uri.parse("http://127.0.0.1/waqf_api/add_beneficiary.php");
    var response = await http.post(url, body: {
      "name": nameController.text,
      "id_number": idNumberController.text,
      "phone": phoneController.text,
      "address": addressController.text,
      "aid_amount": aidAmountController.text,
      "waqf_id": waqfIdController.text,
    });

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("تمت الإضافة بنجاح")));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("حدث خطأ أثناء الإضافة")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("إضافة مستفيد جديد")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: "اسم المستفيد")),
            TextField(controller: idNumberController, decoration: InputDecoration(labelText: "رقم الهوية")),
            TextField(controller: phoneController, decoration: InputDecoration(labelText: "رقم الهاتف")),
            TextField(controller: addressController, decoration: InputDecoration(labelText: "العنوان")),
            TextField(controller: aidAmountController, decoration: InputDecoration(labelText: "المبلغ المخصص")),
            TextField(controller: waqfIdController, decoration: InputDecoration(labelText: "معرف الوقف")),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: addBeneficiary,
              child: Text("إضافة"),
            ),
          ],
        ),
      ),
    );
  }
}