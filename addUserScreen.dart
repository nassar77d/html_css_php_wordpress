import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddUserScreen extends StatefulWidget {
  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}


class _AddUserScreenState extends State<AddUserScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String role = "employee";
@override
  void initState() {

    super.initState();
    addUser();
  }

  Future<void> addUser() async {
    var url = Uri.parse("http://127.0.0.1/waqf_api/add_user.php");
    try {
      var response = await http.post(url, body: {
        "username": usernameController.text,
        "email": emailController.text,
        "password": passwordController.text,
        "role": role,
      });
      var data = json.decode(response.body);
      if (data["status"] == "success") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("تمت إضافة المستخدم بنجاح")),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("فشل في إضافة المستخدم")),
        );
      }
    } catch (e) {
      print("Error adding user: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("إضافة مستخدم جديد")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: "اسم المستخدم"),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: "البريد الإلكتروني"),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: "كلمة المرور"),

              ),
              DropdownButtonFormField(
                value: role,
                items: [
                  DropdownMenuItem(value: "admin", child: Text("مدير")),
                  DropdownMenuItem(value: "employee", child: Text("موظف")),
                  DropdownMenuItem(value: "supervisor", child: Text("مشرف")),
                ],
                onChanged: (value) {
                  setState(() {
                    role = value!;
                  });
                },
                decoration: InputDecoration(labelText: "الصلاحية"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: addUser,
                child: Text("إضافة"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}