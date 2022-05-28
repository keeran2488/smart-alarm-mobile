import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:smartClockFinal/api/api_home.dart';
import 'package:smartClockFinal/api/urls.dart';
import 'package:smartClockFinal/devices.dart';
import 'package:smartClockFinal/models/home_model.dart';

class Rooms extends StatefulWidget {
  @override
  _RoomsState createState() => _RoomsState();
}

class _RoomsState extends State<Rooms> {
  late Future<List<Room>> futureRoom;
  bool rpiActive = false;

  void checkRpiConnection() async {
    try {
      final result = await InternetAddress.lookup(serverUrl);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          rpiActive = true;
        });
        getRoom();
      }
    } on SocketException catch (_) {
      debugPrint('Status: ${rpiActive.toString()}');
      setState(() {
        rpiActive = false;
      });
    }
  }

  getRoom() async {
    futureRoom = fetchRoom();
  }

  @override
  void initState() {
    super.initState();
    checkRpiConnection();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xff313236), Color(0xff19191c)],
          // colors: [Colors.white, Colors.black],
        ),
      ),
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          label: Text("Add room"),
          icon: Icon(Icons.add),
          backgroundColor: rpiActive ? Colors.blue : Colors.grey,
          onPressed: () {
            showModalBottomSheet<dynamic>(
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) {
                return Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: Text("Add room"),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        RoomForm(),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Rooms"),
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.search,
                  size: 26.0,
                ),
              ),
            ),
          ],
        ),
        body: rpiActive
            ? FutureBuilder<List<Room>>(
                future: futureRoom,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GridView.builder(
                      padding: EdgeInsets.all(10.0),
                      itemCount: snapshot.data!.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      itemBuilder: (context, index) {
                        return Card(
                          color: Color(0xff1f1f24),
                          margin: EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              String title =
                                  snapshot.data![index].name.toString();
                              int id = snapshot.data![index].id;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Devices(title: title, id: id),
                                ),
                              ).then(
                                (value) => setState(
                                  () {
                                    getRoom();
                                  },
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Column(
                                children: [
                                  Text(
                                    snapshot.data![index].name.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(
                                    height: 35.0,
                                  ),
                                  Icon(
                                    IconData(snapshot.data![index].iconData,
                                        fontFamily: "MaterialIcons"),
                                    color: Colors.white,
                                    size: 70.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
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
      ),
    );
  }
}

class RoomForm extends StatefulWidget {
  @override
  _RoomFormState createState() => _RoomFormState();
}

class _RoomFormState extends State<RoomForm> {
  final _roomFormKey = GlobalKey<FormState>();
  final _roomNameController = TextEditingController();

  IconData _iconData = IconData(57411, fontFamily: 'MaterialIcons');

  _pickIcon() async {
    IconData? _icon = await FlutterIconPicker.showIconPicker(
      context,
      iconPackModes: [
        IconPack.material,
      ],
    );
    if (_icon != null) {
      setState(() {});
      _iconData = _icon;
      debugPrint('Picked Icon:  ' + _iconData.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _roomFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Icon(
              _iconData,
              size: 80.0,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          TextFormField(
            controller: _roomNameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter room name';
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Room Name",
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
              OutlinedButton(
                child: Text("Choose Icon"),
                onPressed: () {
                  _pickIcon();
                },
              ),
              ElevatedButton(
                child: Text("Add"),
                onPressed: () {
                  if (_roomFormKey.currentState!.validate()) {
                    print(_roomNameController.text);
                    createRoom(_roomNameController.text, _iconData.codePoint)
                        .then(
                      (value) => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Devices(
                            title: value.name,
                            id: value.id,
                          ),
                        ),
                      ),
                    );
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
