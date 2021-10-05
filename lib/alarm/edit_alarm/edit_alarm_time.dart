import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';

import 'package:smartClockFinal/models/alarm.dart';

class EditAlarmTime extends StatelessWidget {
  final ObservableAlarm alarm;
  const EditAlarmTime({Key? key, required this.alarm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Observer(builder: (context) {
        return Text(
          alarm.time,
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
          ),
        );
      }),
      onTap: () async {
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay(hour: alarm.hour, minute: alarm.minute),
        );
        if (time == null) {
          return;
        }
        final now = DateTime.now();
        var selectedDateTime = DateTime(
          now.year,
          now.month,
          now.day,
          time.hour,
          time.minute,
        );
        var formatedTime = DateFormat('hh:mm aa').format(selectedDateTime);
        alarm.hour = time.hour;
        alarm.minute = time.minute;
        alarm.time = formatedTime;
      },
    );
  }
}
