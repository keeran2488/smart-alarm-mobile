import 'package:flutter/material.dart';
import 'package:smartClockFinal/api/api_automated_task.dart';
import 'package:smartClockFinal/models/automated_task.dart';
import 'package:smartClockFinal/task/edit_automated_task/edit_task_time.dart';
import 'package:smartClockFinal/task/edit_automated_task/task.dart';

class EditTask extends StatelessWidget {
  final ObservableAutomatedTask task;

  EditTask({required this.task});

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
              task.title,
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
                      EditTaskTime(task: task),
                      SizedBox(
                        height: 25,
                      ),
                      Tasks(automatedTask: task),
                      Divider(
                        height: 20,
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
                              deleteAutomatedTask(task)
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
                              editAutomatedTask(task)
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
