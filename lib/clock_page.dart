import 'package:flutter/material.dart';
import 'package:smartClockFinal/clock_view.dart';
import 'package:intl/intl.dart';

class ClockPage extends StatefulWidget {
  @override
  _ClockPageState createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage> {
  var _formattedTime = DateFormat('HH:mm').format(DateTime.now());
  var _formattedDate = DateFormat('EEE, d MMM').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Clock"),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Color(0xFF2D2F41),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        alignment: Alignment.center,
        child: Column(
          children: [
            Text(
              _formattedTime,
              style: TextStyle(
                color: Colors.white,
                fontSize: 50.0,
              ),
            ),
            SizedBox(
              height: 6.0,
            ),
            Text(
              _formattedDate,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            ClockView(),
          ],
        ),
      ),
      backgroundColor: Color(0xFF2D2F41),
    );
  }
}
