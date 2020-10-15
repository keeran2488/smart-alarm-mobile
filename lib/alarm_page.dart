import 'package:flutter/material.dart';

class AlarmPage extends StatefulWidget {
  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  final List<TimeOfDay> alarms = <TimeOfDay>[];
  var isSwitched = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Alarm"),
        centerTitle: true,
        backgroundColor: Color(0xFF2D2F41),
        elevation: 0,
      ),
      body: Container(
        color: Color(0xFF2D2F41),
        child: ListView.separated(
          padding: EdgeInsets.all(10.0),
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 11),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${alarms[index].hour} : ${alarms[index].minute}",
                          style: TextStyle(
                              color: (isSwitched[index] == true)
                                  ? Colors.blue
                                  : Colors.grey,
                              fontSize: 26.0),
                        ),
                        Switch(
                          value: isSwitched[index],
                          onChanged: (value) {
                            setState(() {
                              isSwitched[index] = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text(
                  //       "Every day",
                  //       style: TextStyle(color: Colors.white),
                  //     ),
                  //   ],
                  // )
                  ExpansionTile(
                    childrenPadding: EdgeInsets.only(top: 10, bottom: 20),
                    title: Text(
                      "Every day",
                      style: TextStyle(color: Colors.white),
                    ),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "S",
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            "M",
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            "T",
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            "W",
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            "T",
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            "F",
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            "S",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
          itemCount: alarms.length,
          separatorBuilder: (BuildContext context, int index) => Divider(
            color: Colors.grey,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: timePicker,
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }

  void timePicker() async {
    TimeOfDay selectedTime =
        await showTimePicker(initialTime: TimeOfDay.now(), context: context);
    if (selectedTime != null) {
      setState(() {
        alarms.add(selectedTime);
        isSwitched.add(true);
      });
    }
  }
}
