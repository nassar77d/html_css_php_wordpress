import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_3/prayer.dart';
import 'package:flutter_application_3/transaction_screen.dart';
import 'package:flutter_application_3/waqf_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';
import 'UserScreen.dart';
import 'beneficiary_screen.dart';
import 'grun/surah_list.dart';
import 'main.dart';
import 'transaction_screen.dart';


class DashboardScreen extends StatelessWidget {

  final String appReviewUrl = "https://play.google.com/store/apps/details?id=com.example.app";


  final String privacyPolicyUrl = "https://your-privacy-policy-url.com";


  final String otherAppsUrl = "https://play.google.com/store/apps/developer?id=YourDeveloperName";


  void _openUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("لا يمكن فتح الرابط: $url");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(title: Text("لوحة التحكم - نظام الأوقاف"),
          actions: [
          IconButton(

          icon: Icon(MyApp.isDarkMode.value ? Icons.light_mode : Icons.dark_mode,color: Colors.black,),
        onPressed: () {
          MyApp.isDarkMode.value = !MyApp.isDarkMode.value;
        },
      ),
      ],

      backgroundColor: Colors.red,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                "القائمة الجانبية",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ListTile(
              leading: Icon(Icons.star),
              title: Text("تقييم التطبيق"),
              onTap: () {
                _openUrl(appReviewUrl);
              },
            ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text("شارك التطبيق"),
              onTap: () {
                Share.share("جرب هذا التطبيق الرائع: $appReviewUrl");
              },
            ),
            ListTile(
              leading: Icon(Icons.apps),
              title: Text("تطبيقات أخرى"),
              onTap: () {
                _openUrl(otherAppsUrl);
              },
            ),
            ListTile(
              leading: Icon(Icons.privacy_tip),
              title: Text("Privacy Policy"),
              onTap: () {
                _openUrl(privacyPolicyUrl);
              },
            ),

            ListTile(
              leading: Icon(Icons.info),
              title: Text("حول التطبيق"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutScreen()),
                );
              },
            ),


          ],
        ),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(16),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: [

          _buildDashboardItem(
            context,
            "إدارة الإيرادات والمصاريف",
            Icons.attach_money,
            TransactionsScreen(),
          ),

          _buildDashboardItem(

            context,
            "إدارة الاوقاف ",
            Icons.mosque_outlined,
            WaqfScreen(),
          ),

          _buildDashboardItem(

            context,
            "اداره المستفيدين ",
            Icons.people,
            BeneficiaryScreen(),
          ),

          _buildDashboardItem(
            context,
            "اداره المستخدمين ",
            Icons.person,
            UserScreen(),
          ),

          _buildDashboardItem(

            context,
            "القران الكريم ",
            Icons.mosque,
            SurahList(),
          ),

          _buildDashboardItem(
            context,
            "مواقيت الصلاه",
            Icons.time_to_leave,
            PrayerTimesScreen(),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardItem(BuildContext context, String title, IconData icon, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Card(

        elevation: 4,
        shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Icon(icon, size: 50, color: Colors.blue),
            SizedBox(height: 10),
            Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
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



