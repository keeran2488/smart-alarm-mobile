import 'package:flutter/material.dart';

class AlarmPage extends StatefulWidget {
  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  final List<String> alarms = <String>['Alarm 1', 'Alarm 2', 'Alarm 3'];
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
            return Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 100.0,
                      child: Text(alarms[index]),
                    ),
                  ],
                )
              ],
            );
          },
          itemCount: alarms.length,
          separatorBuilder: (BuildContext context, int index) => Divider(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
    );
  }
}
