import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:smartClockFinal/api/urls.dart';
import 'package:smartClockFinal/models/home_model.dart';

Future<Room> createRoom(String name, int iconData) async {
  print("debug: createRoom");
  final response = await http.post(
    Uri.parse(roomUrl),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'name': name,
      'icon_data': iconData.toString(),
    }),
  );

  if (response.statusCode == 201) {
    print(response.body);
    return Room.fromJson(jsonDecode(response.body));
  } else {
    print("Room failed");
    throw Exception('Failed to create room.');
  }
}

List<Room> parseRoom(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Room>((json) => Room.fromJson(json)).toList();
}

Future<List<Room>> fetchRoom() async {
  final response = await http.get(Uri.parse(roomUrl));
  if (response.statusCode == 200) {
    return parseRoom(response.body);
  } else {
    throw Exception('Failed to load room');
  }
}

Future<Room> fetchRoomDetail(int? id) async {
  final response = await http.get(Uri.parse(roomUrl + id.toString() + "/"));

  if (response.statusCode == 200) {
    return Room.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to get room detail.');
  }
}

Future<Device> createDevice(
    String name, int iconData, int pin, int? room) async {
  print("debug: createDevice");
  final response = await http.post(
    Uri.parse(roomUrl + room.toString() + '/device/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'name': name,
      'icon_data': iconData,
      'status': 'False',
      'pin': pin,
      'room': room,
    }),
  );

  if (response.statusCode == 201) {
    print(response.body);
    return Device.fromJson(jsonDecode(response.body));
  } else {
    print("Room failed");
    throw Exception('Failed to create device.');
  }
}

List<Device> parseDevice(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Device>((json) => Device.fromJson(json)).toList();
}

Future<List<Device>> fetchDevice(int? room) async {
  final response =
      await http.get(Uri.parse(roomUrl + room.toString() + '/device/'));
  if (response.statusCode == 200) {
    return parseDevice(response.body);
  } else {
    throw Exception('Failed to load device');
  }
}

Future<Device> fetchDeviceDetail(int id) async {
  final response = await http.get(Uri.parse(deviceUrl + id.toString() + "/"));

  if (response.statusCode == 200) {
    return Device.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to get device detail.');
  }
}

Future<Device> changeDeviceStatus(int id, bool status, int pin) async {
  print("debug: change device status");
  final response = await http.patch(
    Uri.parse(deviceUrl + id.toString() + '/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'status': status,
      'pin': pin,
    }),
  );
  if (response.statusCode == 200) {
    print(response.body);
    return Device.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Device status changed.');
  }
}
