import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smartClockFinal/api/api_home.dart';

import 'models/home_model.dart';

class Devices extends StatefulWidget {
  final String title;
  final int? id;

  Devices({Key? key, required this.title, required this.id}) : super(key: key);

  @override
  _DevicesState createState() => _DevicesState();
}

class _DevicesState extends State<Devices> {
  late Future<List<Device>> futureDevice;

  getDevice() async {
    futureDevice = fetchDevice(widget.id);
  }

  @override
  void initState() {
    super.initState();
    getDevice();
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
          label: Text("Add device"),
          icon: Icon(Icons.add),
          backgroundColor: Color(0xff1f1f24),
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
                        Center(
                          child: Text("Add device"),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        DeviceForm(
                            id: widget.id,
                            getDevice: getDevice(),
                            title: widget.title),
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
          title: Text(widget.title),
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back),
          ),
        ),
        body: FutureBuilder<List<Device>>(
          future: futureDevice,
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
                        bool status = snapshot.data![index].status;
                        changeDeviceStatus(snapshot.data![index].id, !status,
                                snapshot.data![index].pin)
                            .then((value) => setState(() {
                                  futureDevice = fetchDevice(widget.id);
                                }));
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
                              color: snapshot.data![index].status
                                  ? Colors.yellow
                                  : Colors.white,
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
        ),
      ),
    );
  }
}

class DeviceForm extends StatefulWidget {
  final int? id;
  final getDevice;
  final String title;

  DeviceForm(
      {Key? key,
      required this.id,
      required this.getDevice,
      required this.title})
      : super(key: key);
  @override
  _DeviceFormState createState() => _DeviceFormState();
}

class _DeviceFormState extends State<DeviceForm> {
  final _deviceFormKey = GlobalKey<FormState>();
  final _deviceNameController = TextEditingController();
  final _devicePinController = TextEditingController();

  IconData _iconData = IconData(57411, fontFamily: 'MaterialIcons');

  _pickIcon() async {
    IconData? _icon = await FlutterIconPicker.showIconPicker(context,
        iconPackMode: IconPack.material);
    if (_icon != null) {
      setState(() {});
      _iconData = _icon;
      debugPrint('Picked Icon:  ' + _iconData.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _deviceFormKey,
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
            controller: _deviceNameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter deivce name';
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Device Name",
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          TextFormField(
            controller: _devicePinController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter pin';
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Pin Number",
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
                  if (_deviceFormKey.currentState!.validate()) {
                    print(_deviceNameController.text);
                    print(widget.id);
                    createDevice(
                            _deviceNameController.text,
                            _iconData.codePoint,
                            int.parse(_devicePinController.text),
                            widget.id)
                        .then((value) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              Devices(title: widget.title, id: widget.id),
                        ),
                      );
                    });
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
