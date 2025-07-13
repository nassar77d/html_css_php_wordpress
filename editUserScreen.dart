import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditUserScreen extends StatefulWidget {
  final Map user;
  EditUserScreen(this.user);

  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  String role = "employee";

  @override
  void initState() {
    super.initState();
    usernameController.text = widget.user["username"];
    emailController.text = widget.user["email"];
    role = widget.user["role"];
  }

  Future<void> updateUser() async {
    var url = Uri.parse("http://127.0.0.1/waqf_api/update_user.php");
    try {
      var response = await http.post(url, body: {
        "id": widget.user["id"].toString(),
        "username": usernameController.text,
        "email": emailController.text,

        "password": passwordController.text,
        "role": role,
      });
      var data = json.decode(response.body);
      if (data["status"] == "success") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("تم تحديث المستخدم بنجاح")),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("فشل في تحديث المستخدم")),
        );
      }
    } catch (e) {
      print("Error updating user: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("تعديل بيانات المستخدم")),
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
                decoration: InputDecoration(labelText: "كلمة المرور (اتركها فارغة لعدم التغيير)"),
                obscureText: true,
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
                onPressed: updateUser,
                child: Text("تحديث"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}