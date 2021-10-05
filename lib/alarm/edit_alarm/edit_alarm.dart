import 'package:flutter/material.dart';
import 'package:smartClockFinal/alarm/edit_alarm/edit_alarm_days.dart';
import 'package:smartClockFinal/alarm/edit_alarm/edit_alarm_time.dart';
import 'package:smartClockFinal/api/api_alarm.dart';
import 'package:smartClockFinal/models/alarm.dart';

class EditAlarm extends StatelessWidget {
  final ObservableAlarm alarmInfo;

  EditAlarm({required this.alarmInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      backgroundColor: Color(0xFF2D2F41),
      body: Container(
        margin: EdgeInsets.only(top: 40),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              alarmInfo.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Color(0xFF212330),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EditAlarmTime(alarm: alarmInfo),
                      SizedBox(
                        height: 25,
                      ),
                      EditAlarmDays(alarm: alarmInfo),
                      Divider(
                        height: 50,
                        color: Colors.white,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.redAccent)),
                            onPressed: () {
                              deleteAlarm(alarmInfo)
                                  .then((value) => Navigator.pop(context));
                            },
                            child: Text("Delete"),
                          ),
                          SizedBox(width: 90),
                          ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.grey)),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Cancel"),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.blueAccent)),
                            onPressed: () {
                              editAlarm(alarmInfo)
                                  .then((value) => Navigator.pop(context));
                            },
                            child: Text("Save"),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
