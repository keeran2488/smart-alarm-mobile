import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:smartClockFinal/alarm/edit_alarm/edit_alarm.dart';
import 'package:smartClockFinal/api/api_alarm.dart';
import 'package:smartClockFinal/api/urls.dart';
import 'package:smartClockFinal/models/alarm.dart';

const dates = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

class AlarmPage extends StatefulWidget {
  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  late Future<List<ObservableAlarm>> alarmInfo;

  bool rpiActive = false;

  void checkRpiConnection() async {
    try {
      final result = await InternetAddress.lookup(serverUrl);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          rpiActive = true;
        });
        getAlarm();
      }
    } on SocketException catch (_) {
      setState(() {
        rpiActive = false;
      });
    }
  }

  void getAlarm() async {
    alarmInfo = fetchAlarm();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Alarm"),
        centerTitle: true,
        backgroundColor: Color(0xFF2D2F41),
        elevation: 0,
      ),
      backgroundColor: Color(0xFF2D2F41),
      body: rpiActive
          ? FutureBuilder<List<ObservableAlarm>>(
              future: alarmInfo,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Observer(
                    builder: (context) => Container(
                      child: ListView.separated(
                        padding: EdgeInsets.all(10.0),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditAlarm(
                                            alarmInfo: snapshot.data![index])))
                                .then((value) {
                              setState(() {
                                getAlarm();
                              });
                            }),
                            child: Container(
                              // color: Color(0xFF212330),
                              decoration: BoxDecoration(
                                color: Color(0xFF212330),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: Container(
                                margin: EdgeInsets.fromLTRB(11, 5, 0, 5),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text(
                                          snapshot.data![index].title,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              snapshot.data![index].time,
                                              style: TextStyle(
                                                  color: (snapshot.data![index]
                                                              .active ==
                                                          true)
                                                      ? Colors.blue
                                                      : Colors.grey,
                                                  fontSize: 26.0),
                                            ),
                                            Switch(
                                              value:
                                                  snapshot.data![index].active,
                                              onChanged: (value) {
                                                setState(() {
                                                  snapshot.data![index].active =
                                                      value;
                                                });
                                                toggleAlarm(
                                                    snapshot.data![index]);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      DateRow(alarm: snapshot.data![index]),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: snapshot.data!.length,
                        separatorBuilder: (BuildContext context, int index) =>
                            SizedBox(height: 15),
                      ),
                    ),
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            )
          : AlertDialog(
              title: const Text('No Active Connection'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: const <Widget>[
                    Text(
                        'Make sure this deivce and RaspberryPi are on same network.'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Retry'),
                  onPressed: () {
                    checkRpiConnection();
                  },
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Add alarm"),
        icon: Icon(Icons.add),
        onPressed: timePicker,
        backgroundColor: rpiActive ? Colors.blue : Colors.grey,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }

  void timePicker() async {
    TimeOfDay? selectedTime =
        await showTimePicker(initialTime: TimeOfDay.now(), context: context);
    if (selectedTime != null) {
      final now = DateTime.now();
      var selectedDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        selectedTime.hour,
        selectedTime.minute,
      );
      var formatedTime = DateFormat('hh:mm aa').format(selectedDateTime);
      var selectedalarmInfo = ObservableAlarm(
          hour: selectedTime.hour,
          minute: selectedTime.minute,
          time: formatedTime,
          title: "Wake Up",
          monday: false,
          tuesday: false,
          wednesday: false,
          thursday: false,
          friday: false,
          saturday: false,
          sunday: false,
          active: true);
      createAlarm(selectedalarmInfo).then((value) {
        setState(() {
          getAlarm();
        });
      });
    }
  }
}

class DateRow extends StatelessWidget {
  final ObservableAlarm alarm;
  final List<bool> dayEnabled;

  DateRow({
    Key? key,
    required this.alarm,
  })  : dayEnabled = [
          alarm.monday,
          alarm.tuesday,
          alarm.wednesday,
          alarm.thursday,
          alarm.friday,
          alarm.saturday,
          alarm.sunday
        ],
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: Size(155, 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: dates.asMap().entries.map((indexStringPair) {
          final dayString = indexStringPair.value;
          final index = indexStringPair.key;
          return Text(
            dayString,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight:
                  dayEnabled[index] ? FontWeight.bold : FontWeight.normal,
            ),
          );
        }).toList(),
      ),
    );
  }
}
