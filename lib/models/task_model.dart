import 'package:mobx/mobx.dart';

part 'task_model.g.dart';

class Task extends TaskBase with _$Task {
  int? id;
  int? automatedtask;
  int? room;
  int? device;

  bool status;
  bool toDO;

  Task(
      {this.id,
      required this.automatedtask,
      required this.room,
      required this.device,
      required this.status,
      required this.toDO})
      : super(
            automatedtask: automatedtask,
            room: room,
            device: device,
            status: status,
            toD0: toDO);

  factory Task.fromJson(Map<dynamic, dynamic> json) {
    return Task(
        id: json['id'],
        automatedtask: json['automatedtask'],
        room: json['room'],
        device: json['device'],
        status: json['status'],
        toDO: json['to_do']);
  }
}

abstract class TaskBase with Store {
  @observable
  int? id;

  @observable
  int? automatedtask;

  @observable
  int? room;

  @observable
  int? device;

  @observable
  bool status;

  @observable
  bool toD0;

  TaskBase(
      {this.id,
      required this.automatedtask,
      required this.room,
      required this.device,
      required this.status,
      required this.toD0});
}

// class Task {
//   int? id;
//   int? automatedtask;
//   int? room;
//   int? device;

//   bool status;

//   Task(
//       {this.id,
//       required this.automatedtask,
//       required this.room,
//       required this.device,
//       required this.status});

//   factory Task.fromJson(Map<dynamic, dynamic> json) {
//     return Task(
//         id: json['id'],
//         automatedtask: json['automatedtask'],
//         room: json['room'],
//         device: json['device'],
//         status: json['status']);
//   }
// }
