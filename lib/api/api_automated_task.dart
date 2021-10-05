import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:smartClockFinal/api/urls.dart';

import 'package:smartClockFinal/models/automated_task.dart';

Future<ObservableAutomatedTask> createAutomatedTask(
    ObservableAutomatedTask task) async {
  final response = await http.post(Uri.parse(automatedTaskUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<dynamic, dynamic>{
        'title': task.title,
        'time': task.time,
        'hour': task.hour,
        'minute': task.minute,
        'active': task.active,
      }));
  if (response.statusCode == 201) {
    return ObservableAutomatedTask.fromJson(jsonDecode(response.body));
  } else {
    throw Exception(response.body);
  }
}

List<ObservableAutomatedTask> parseAutomatedTask(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<ObservableAutomatedTask>(
          (json) => ObservableAutomatedTask.fromJson(json))
      .toList();
}

Future<List<ObservableAutomatedTask>> fetchAutomatedTask() async {
  final response = await http.get(Uri.parse(automatedTaskUrl));

  if (response.statusCode == 200) {
    return parseAutomatedTask(response.body);
  } else {
    throw Exception('Failed to load tasks');
  }
}

Future<ObservableAutomatedTask> toggleAutomatedTask(
    ObservableAutomatedTask task) async {
  final response =
      await http.patch(Uri.parse(automatedTaskUrl + task.id.toString() + "/"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<dynamic, dynamic>{
            'active': task.active,
          }));
  if (response.statusCode == 200) {
    return ObservableAutomatedTask.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to toggle automated task.');
  }
}

Future<http.Response> deleteAutomatedTask(ObservableAutomatedTask task) async {
  final http.Response response = await http.delete(
    Uri.parse(automatedTaskUrl + task.id.toString() + "/"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == 204) {
    return response;
  } else {
    throw Exception('Failed to delete task.');
  }
}

Future<ObservableAutomatedTask> editAutomatedTask(
    ObservableAutomatedTask task) async {
  final response =
      await http.patch(Uri.parse(automatedTaskUrl + task.id.toString() + "/"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<dynamic, dynamic>{
            'title': task.title,
            'time': task.time,
            'hour': task.hour,
            'minute': task.minute,
            'active': task.active,
          }));
  if (response.statusCode == 200) {
    return ObservableAutomatedTask.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to edit alarm.');
  }
}
