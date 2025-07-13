import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'editUserScreen.dart';
import 'addUserScreen.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  List users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    var url = Uri.parse("http://127.0.0.1/waqf_api/get_users.php");

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        print("بيانات المستخدمين: $data");
        print("عدد المستخدمين: ${data["users"].length}");

        if (data["status"] == "success" && data["users"] is List) {
          setState(() {
            users = data["users"];
            isLoading = false;
            print("تم تحديث المستخدمين: $users");
          });
        } else {
          print("لم يتم جلب المستخدمين بشكل صحيح.");
          setState(() {
            isLoading = false;
          });
        }
      } else {
        print("خطأ في الاستجابة: ${response.statusCode}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("خطأ أثناء جلب المستخدمين: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteUser(int id) async {
    var url = Uri.parse("http://127.0.0.1/waqf_api/delete_user.php");

    try {
      var response = await http.post(url, body: {"id": id.toString()});

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data["status"] == "success") {
          fetchUsers();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("فشل في حذف المستخدم")),
          );
        }
      } else {
        print("خطأ في حذف المستخدم: ${response.statusCode}");
      }
    } catch (e) {
      print("خطأ أثناء حذف المستخدم: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("إدارة المستخدمين")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : users.isEmpty
          ? Center(child: Text("لا يوجد مستخدمون"))
          : ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          var user = users[index];
          return Card(
            child: ListTile(
              title: Text(user["username"]),
              subtitle: Text(
                "البريد: ${user["email"]}\nالصلاحية: ${user["role"]}",
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
                          builder: (context) => EditUserScreen(user),
                        ),
                      ).then((_) => fetchUsers());
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteUser(int.parse(user["id"].toString())),
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
            MaterialPageRoute(builder: (context) => AddUserScreen()),
          ).then((_) => fetchUsers());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}