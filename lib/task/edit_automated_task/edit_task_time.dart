import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:smartClockFinal/models/automated_task.dart';

class EditTaskTime extends StatelessWidget {
  final ObservableAutomatedTask task;
  const EditTaskTime({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Observer(builder: (context) {
        return Text(
          task.time,
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
          ),
        );
      }),
      onTap: () async {
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay(hour: task.hour, minute: task.minute),
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
        task.hour = time.hour;
        task.minute = time.minute;
        task.time = formatedTime;
      },
    );
  }
}
