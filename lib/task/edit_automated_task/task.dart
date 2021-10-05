import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:smartClockFinal/api/api_home.dart';
import 'package:smartClockFinal/api/api_task.dart';
import 'package:smartClockFinal/api/urls.dart';
import 'package:smartClockFinal/models/automated_task.dart';
import 'package:smartClockFinal/models/home_model.dart';
import 'package:smartClockFinal/models/task_model.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class DeviceList extends StatefulWidget {
  Room room;
  Task task;
  DeviceList({Key? key, required this.room, required this.task})
      : super(key: key);

  @override
  _DeviceListState createState() => _DeviceListState();
}

class _DeviceListState extends State<DeviceList> {
  late Future<List<Device>> futureDevice;
  String? _value;

  getDevice(int id) async {
    futureDevice = fetchDevice(id);
  }

  @override
  void initState() {
    getDevice(widget.room.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<Device>>(
        future: futureDevice,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            snapshot.data!.forEach((element) {
              if (element.id == widget.task.device) {
                _value = element.name;
              }
            });
            return DropdownButton(
                value: _value,
                icon: const Icon(Icons.arrow_downward),
                style: TextStyle(color: Colors.white, fontSize: 16),
                underline: Container(
                  color: Colors.transparent,
                ),
                iconSize: 24,
                dropdownColor: Colors.black,
                onChanged: (String? value) {
                  setState(() {
                    _value = value!;
                  });
                },
                items: snapshot.data!.map((e) {
                  return DropdownMenuItem(
                    child: Text(e.name),
                    value: e.name,
                  );
                }).toList());
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class RoomList extends StatefulWidget {
  Room room;
  RoomList({Key? key, required this.room}) : super(key: key);

  @override
  _RoomListState createState() => _RoomListState();
}

class _RoomListState extends State<RoomList> {
  late Future<List<Room>> futureRoom;
  String? _value;

  getRoom() async {
    futureRoom = fetchRoom();
  }

  @override
  void initState() {
    _value = widget.room.name;
    getRoom();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<Room>>(
        future: futureRoom,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return DropdownButton(
                value: _value,
                icon: const Icon(Icons.arrow_downward),
                style: TextStyle(color: Colors.white, fontSize: 16),
                underline: Container(
                  color: Colors.transparent,
                ),
                dropdownColor: Colors.black,
                iconSize: 24,
                onChanged: (String? value) {
                  setState(() {
                    _value = value!;
                  });
                },
                items: snapshot.data!.map((e) {
                  return DropdownMenuItem(
                    child: Text(e.name),
                    value: e.name,
                  );
                }).toList());
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class TaskWidget extends StatefulWidget {
  List<Task> task;
  int index;
  VoidCallback callback;
  TaskWidget(
      {Key? key,
      required this.task,
      required this.index,
      required this.callback})
      : super(key: key);

  @override
  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  late Future<Room> room;
  String _toDo = '';

  getRoom() async {
    room = fetchRoomDetail(widget.task[widget.index].room);
  }

  @override
  void initState() {
    if (widget.task[widget.index].toDO) {
      _toDo = "On";
    } else {
      _toDo = "Off";
    }
    getRoom();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Room>(
        future: room,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RoomList(room: snapshot.data!),
                DeviceList(
                    room: snapshot.data!, task: widget.task[widget.index]),
                Text(
                  _toDo,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      deleteTask(widget.task[widget.index]);
                      widget.callback();
                    });
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                )
              ],
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}

class Tasks extends StatefulWidget {
  final ObservableAutomatedTask automatedTask;
  const Tasks({Key? key, required this.automatedTask}) : super(key: key);

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  List<Room> room = [];
  List<Device> device = [];
  late Future<List<Task>> futureTask;
  List<Task> task = [];

  getTask() async {
    futureTask = fetchTaskList(widget.automatedTask);
  }

  void refresh() {
    setState(() {
      getTask();
    });
  }

  @override
  initState() {
    getTask();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Tasks",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green)),
              onPressed: () {
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
                              height: 10.0,
                            ),
                            Text(
                              "Task",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            TaskAddForm(
                              automatedTaskId: widget.automatedTask.id,
                              callback: refresh,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: Text("Add task"),
            ),
          ],
        ),
        SizedBox(
          height: 150,
          child: FutureBuilder<List<Task>>(
            future: futureTask,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Observer(
                  builder: (context) => ListView.builder(
                    itemCount: snapshot.data!.length,
                    key: UniqueKey(),
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.transparent,
                        child: TaskWidget(
                          task: snapshot.data!,
                          index: index,
                          callback: refresh,
                        ),
                      );
                    },
                  ),
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ],
    );
  }
}

class TaskAddForm extends StatefulWidget {
  VoidCallback callback;
  int? automatedTaskId;
  TaskAddForm({Key? key, required this.automatedTaskId, required this.callback})
      : super(key: key);

  @override
  _TaskAddFormState createState() => _TaskAddFormState();
}

class _TaskAddFormState extends State<TaskAddForm> {
  late Future<List<Room>> futureRoom;
  late Future<List<Device>> futureDevice;
  int? _roomId = 0;
  List<Device> device = [];
  int? _deviceId = 0;
  List<String> _toDo = ['On', 'Off'];
  String? _initialToDo = 'On';

  getRoom() async {
    futureRoom = fetchRoom();
  }

  @override
  void initState() {
    getRoom();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FutureBuilder<List<Room>>(
                  future: futureRoom,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (_roomId == 0) {
                        _roomId = snapshot.data![0].id;
                      }
                      return DropdownButton(
                          value: _roomId,
                          onChanged: (int? id) {
                            setState(() {
                              _roomId = id;
                            });
                            _onSelectedRoom(id);
                          },
                          items: snapshot.data!.map((e) {
                            return DropdownMenuItem(
                              child: Text(e.name),
                              value: e.id,
                            );
                          }).toList());
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
              DropdownButton(
                  value: _deviceId,
                  onChanged: (int? value) {
                    setState(() {
                      _deviceId = value;
                    });
                  },
                  items: device.map((e) {
                    return DropdownMenuItem(
                      child: Text(e.name),
                      value: e.id,
                    );
                  }).toList()),
              DropdownButton(
                  value: _initialToDo,
                  onChanged: (String? value) {
                    setState(() {
                      _initialToDo = value;
                    });
                  },
                  items: _toDo.map((e) {
                    return DropdownMenuItem(
                      child: Text(e),
                      value: e,
                    );
                  }).toList()),
            ],
          ),
          SizedBox(
            height: 20,
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
                  bool toDO = true;
                  if (_initialToDo == 'On') {
                    toDO = true;
                  } else {
                    toDO = false;
                  }
                  var task = Task(
                      automatedtask: widget.automatedTaskId,
                      room: _roomId,
                      device: _deviceId,
                      toDO: toDO,
                      status: true);
                  createTask(task).then((value) {
                    widget.callback();
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onSelectedRoom(int? id) async {
    var fdevices = await fetchDevice(id);
    device.clear();
    setState(() {
      fdevices.forEach((element) {
        device.add(element);
        print(element.name);
      });
      print(device.length);
      _deviceId = device[0].id;
      print(_deviceId);
    });
  }
}
