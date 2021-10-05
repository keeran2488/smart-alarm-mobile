import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:smartClockFinal/api/urls.dart';
import 'package:smartClockFinal/models/alarm.dart';

Future<ObservableAlarm> createAlarm(ObservableAlarm alarm) async {
  final response = await http.post(Uri.parse(alarmUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<dynamic, dynamic>{
        'title': alarm.title,
        'time': alarm.time,
        'hour': alarm.hour,
        'minute': alarm.minute,
        'monday': alarm.monday,
        'tuesday': alarm.tuesday,
        'wednesday': alarm.wednesday,
        'thursday': alarm.thursday,
        'friday': alarm.friday,
        'saturday': alarm.saturday,
        'sunday': alarm.sunday,
        'active': alarm.active,
      }));
  if (response.statusCode == 201) {
    return ObservableAlarm.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create alarm.');
  }
}

List<ObservableAlarm> parseAlarm(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<ObservableAlarm>((json) => ObservableAlarm.fromJson(json))
      .toList();
}

Future<List<ObservableAlarm>> fetchAlarm() async {
  final response = await http.get(Uri.parse(alarmUrl));
  if (response.statusCode == 200) {
    return parseAlarm(response.body);
  } else {
    throw Exception('Failed to load alarm');
  }
}

Future<ObservableAlarm> toggleAlarm(ObservableAlarm alarm) async {
  final response =
      await http.patch(Uri.parse(alarmUrl + alarm.id.toString() + "/"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<dynamic, dynamic>{
            'active': alarm.active,
          }));
  if (response.statusCode == 200) {
    return ObservableAlarm.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to toggle alarm.');
  }
}

Future<Response> deleteAlarm(ObservableAlarm alarm) async {
  final http.Response response = await http.delete(
    Uri.parse(alarmUrl + alarm.id.toString() + "/"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == 204) {
    return response;
  } else {
    throw Exception('Failed to delete alarm.');
  }
}

Future<ObservableAlarm> editAlarm(ObservableAlarm alarm) async {
  final response =
      await http.patch(Uri.parse(alarmUrl + alarm.id.toString() + "/"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<dynamic, dynamic>{
            'title': alarm.title,
            'time': alarm.time,
            'hour': alarm.hour,
            'minute': alarm.minute,
            'monday': alarm.monday,
            'tuesday': alarm.tuesday,
            'wednesday': alarm.wednesday,
            'thursday': alarm.thursday,
            'friday': alarm.friday,
            'saturday': alarm.saturday,
            'sunday': alarm.sunday,
            'active': alarm.active,
          }));
  if (response.statusCode == 200) {
    return ObservableAlarm.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to edit alarm.');
  }
}
