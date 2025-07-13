import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';


class PrayerTimesScreen extends StatefulWidget {
  @override
  _PrayerTimesScreenState createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  final DateFormat _timeFormat = DateFormat('hh:mm a');
  Map<String, dynamic> _prayerTimes = {};

  @override
  void initState() {
    super.initState();
    _fetchPrayerTimes();
  }

  Future<void> _fetchPrayerTimes() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1/waqf_api/get_prayers.php'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _prayerTimes = json.decode(response.body);
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> _updatePrayerTime(String prayerName, TimeOfDay newTime) async {
    try {
      final timeString = _timeFormat.format(DateTime(2023, 1, 1, newTime.hour, newTime.minute));

      final response = await http.post(
        Uri.parse('http://127.0.0.1/waqf_api/update_prayer.php'),
        body: json.encode({
          'prayer_name': prayerName,
          'new_time': timeString,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        _fetchPrayerTimes(); // Refresh data after update
      }
    } catch (e) {
      print('Error updating time: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('أوقات الصلاة'),
        centerTitle: true,
      ),
      body: _prayerTimes.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: _prayerTimes.length,
        itemBuilder: (context, index) {
          final prayerName = _prayerTimes.keys.elementAt(index);
          final prayerTime = _prayerTimes[prayerName];
          return PrayerTimeCard(
            prayerName: prayerName,
            prayerTime: prayerTime,
            onTap: () async {
              final time = _timeFormat.parse(prayerTime);
              final pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(time),

              );
              if (pickedTime != null) {
                await _updatePrayerTime(prayerName, pickedTime);
              }
            },
          );
        },
      ),
    );
  }
}

class PrayerTimeCard extends StatelessWidget {
  final String prayerName;
  final String prayerTime;
  final VoidCallback onTap;

  const PrayerTimeCard({
    required this.prayerName,
    required this.prayerTime,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        title: Text(
          prayerName,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.right,
        ),
        trailing: Text(
          prayerTime,
          style: TextStyle(
            fontSize: 16,
            color: Colors.blue,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.edit, color: Colors.grey),
          onPressed: onTap,
        ),
      ),
    );
  }
}