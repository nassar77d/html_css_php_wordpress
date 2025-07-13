import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Edit_waqf_screen.dart';
import 'add_waqf_screen.dart';


class WaqfScreen extends StatefulWidget {
  @override
  _WaqfScreenState createState() => _WaqfScreenState();
}

class _WaqfScreenState extends State<WaqfScreen> {
  List waqfList = [];
  bool isLoading = true;



  @override
  void initState() {
    super.initState();
    fetchWaqf();

  }

  Future<void> fetchWaqf() async {
    var url = Uri.parse("http://127.0.0.1/waqf_api/get_waqf.php");
    var response = await http.get(url);
    var data = json.decode(response.body);

    if (data["status"] == "success") {
      setState(() {
        waqfList = data["waqf"];
        isLoading = false;
      });
    }
  }

  Future<void> deleteWaqf(int id) async {
    var url = Uri.parse("http://127.0.0.1/waqf_api/delete_waqf.php");
    var response = await http.post(url, body: {"id": id.toString()});
    var data = json.decode(response.body);

    if (data["status"] == "success") {
      fetchWaqf();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("فشل في حذف الوقف")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("إدارة الأوقاف")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: waqfList.length,
        itemBuilder: (context, index) {
          var waqf = waqfList[index];
          return Card(
            child: ListTile(
              title: Text(waqf["name"]),
              subtitle: Text("الإيرادات: ${waqf["revenue"]} - المصاريف: ${waqf["expenses"]}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [

                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditWaqfScreen(waqf),
                        ),
                      ).then((_) => fetchWaqf());
                    },
                  ),

                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteWaqf(int.parse(waqf["id"])),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>AddWaqfScreen()));
      },
        child: Icon(Icons.add),),
    );
  }
}