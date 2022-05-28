import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:smartClockFinal/api/api_automated_task.dart';
import 'package:smartClockFinal/api/urls.dart';
import 'package:smartClockFinal/models/automated_task.dart';
import 'package:smartClockFinal/task/edit_automated_task/edit_task.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  late Future<List<ObservableAutomatedTask>> automatedTask;

  bool rpiActive = false;

  void checkRpiConnection() async {
    try {
      final result = await InternetAddress.lookup(serverUrl);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          rpiActive = true;
        });
        getAutomatedTask();
      }
    } on SocketException catch (_) {
      setState(() {
        rpiActive = false;
      });
    }
  }

  getAutomatedTask() async {
    automatedTask = fetchAutomatedTask();
  }

  @override
  void initState() {
    super.initState();
    checkRpiConnection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Automated Tasks"),
        centerTitle: true,
        backgroundColor: Color(0xFF2D2F41),
        elevation: 0,
      ),
      backgroundColor: Color(0xFF2D2F41),
      body: rpiActive
          ? FutureBuilder<List<ObservableAutomatedTask>>(
              future: automatedTask,
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
                                        builder: (context) => EditTask(
                                            task: snapshot.data![index])))
                                .then((value) {
                              setState(() {
                                getAutomatedTask();
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
                                                toggleAutomatedTask(
                                                    snapshot.data![index]);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
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
        label: Text("Add task"),
        icon: Icon(Icons.add),
        onPressed: rpiActive
            ? () {
                showModalBottomSheet<dynamic>(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 15.0,
                            ),
                            AutomatedTaskForm(),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            : null,
        backgroundColor: rpiActive ? Colors.blue : Colors.grey,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }
}

class AutomatedTaskForm extends StatefulWidget {
  @override
  _AutomatedTaskFormState createState() => _AutomatedTaskFormState();
}

class _AutomatedTaskFormState extends State<AutomatedTaskForm> {
  final _automatedTaskFormKey = GlobalKey<FormState>();
  final _automatedTaskNameController = TextEditingController();

  String time = DateFormat("hh:mm aa").format(DateTime.now());
  TimeOfDay? selectedTime = TimeOfDay.now();

  _pickTime() async {
    selectedTime =
        await showTimePicker(initialTime: TimeOfDay.now(), context: context);
    if (selectedTime != null) {
      final now = DateTime.now();
      var selectedDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        selectedTime!.hour,
        selectedTime!.minute,
      );
      var formatedTime = DateFormat('hh:mm aa').format(selectedDateTime);
      setState(() {
        time = formatedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _automatedTaskFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: GestureDetector(
              onTap: () {
                _pickTime();
              },
              child: Text(
                time,
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: _automatedTaskNameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title';
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Title",
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(
                width: 75.0,
              ),
              ElevatedButton(
                child: Text("Add"),
                onPressed: () {
                  if (_automatedTaskFormKey.currentState!.validate()) {
                    print(_automatedTaskNameController.text);
                    var task = ObservableAutomatedTask(
                        title: _automatedTaskNameController.text,
                        time: time,
                        hour: selectedTime!.hour,
                        minute: selectedTime!.minute,
                        active: false);
                    createAutomatedTask(task)
                        .then((value) => Navigator.pop(context));
                  }
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
