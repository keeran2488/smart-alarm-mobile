import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:smartClockFinal/api/urls.dart';
import 'package:smartClockFinal/models/automated_task.dart';
import 'package:smartClockFinal/models/task_model.dart';

Future<Task> createTask(Task task) async {
  final response = await http.post(Uri.parse(taskUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<dynamic, dynamic>{
        'automatedtask': task.automatedtask,
        'room': task.room,
        'device': task.device,
        'status': task.status,
      }));
  if (response.statusCode == 201) {
    return Task.fromJson(jsonDecode(response.body));
  } else {
    throw Exception(response.body);
  }
}

List<Task> parseTask(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Task>((json) => Task.fromJson(json)).toList();
}

Future<List<Task>> fetchTask() async {
  final response = await http.get(Uri.parse(taskUrl));

  if (response.statusCode == 200) {
    return parseTask(response.body);
  } else {
    throw Exception('Failed to load tasks');
  }
}

Future<List<Task>> fetchTaskList(ObservableAutomatedTask task) async {
  final response = await http
      .get(Uri.parse(automatedTaskUrl + task.id.toString() + "/tasks/"));

  if (response.statusCode == 200) {
    return parseTask(response.body);
  } else {
    throw Exception('Failed to load tasks');
  }
}

Future<http.Response> deleteTask(Task task) async {
  final http.Response response = await http.delete(
    Uri.parse(taskUrl + task.id.toString() + "/"),
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
