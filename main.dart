import 'dart:async';
import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'login_screen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  static ValueNotifier<bool> isDarkMode = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkMode,
      builder: (context, isDark, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: isDark ? ThemeData.dark() : ThemeData.light(),
          home: MYhome(),
        );
      },
    );
  }
}



class MYhome extends StatefulWidget {
  const MYhome({super.key});

  @override
  State<MYhome> createState() => _MYhomeState();
}

class _MYhomeState extends State<MYhome> {
  int index=0;
  List<Widget>pages=[AboutScreen(), DashboardScreen()];
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.amber,
      body:
      pages[index],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.red,
        currentIndex: index,
          onTap:(value){
            setState(() {
              index=value;
            });
    },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.domain_sharp),label: "home"),
            BottomNavigationBarItem(icon: Icon(Icons.home),label: "home"),

          ]),
    );
  }
}

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("حول التطبيق")),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            "هذا التطبيق تم تطويره بواسطة المهندس نصار السماوي وخبرته.",
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}



