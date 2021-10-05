import 'package:mobx/mobx.dart';

part 'automated_task.g.dart';

class ObservableAutomatedTask extends ObservableAutomatedTaskBase
    with _$ObservableAutomatedTask {
  ObservableAutomatedTask(
      {id,
      required title,
      required time,
      required hour,
      required minute,
      required active})
      : super(
          id: id,
          title: title,
          time: time,
          hour: hour,
          minute: minute,
          active: active,
        );

  factory ObservableAutomatedTask.fromJson(Map<dynamic, dynamic> json) {
    return ObservableAutomatedTask(
        id: json['id'],
        title: json['title'],
        time: json['time'],
        hour: json['hour'],
        minute: json['minute'],
        active: json['active']);
  }
}

abstract class ObservableAutomatedTaskBase with Store {
  int? id;

  @observable
  String title;

  @observable
  String time;

  @observable
  int hour;

  @observable
  int minute;

  @observable
  bool active;

  ObservableAutomatedTaskBase(
      {this.id,
      required this.title,
      required this.time,
      required this.hour,
      required this.minute,
      required this.active});
}
