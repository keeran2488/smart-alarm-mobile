import 'package:mobx/mobx.dart';

part 'alarm.g.dart';

class ObservableAlarm extends ObservableAlarmBase with _$ObservableAlarm {
  ObservableAlarm(
      {id,
      required title,
      required time,
      required hour,
      required minute,
      required monday,
      required tuesday,
      required wednesday,
      required thursday,
      required friday,
      required saturday,
      required sunday,
      required active})
      : super(
          id: id,
          title: title,
          time: time,
          hour: hour,
          minute: minute,
          monday: monday,
          tuesday: tuesday,
          wednesday: wednesday,
          thursday: thursday,
          friday: friday,
          saturday: saturday,
          sunday: sunday,
          active: active,
        );

  factory ObservableAlarm.fromJson(Map<dynamic, dynamic> json) {
    return ObservableAlarm(
        id: json['id'],
        title: json['title'],
        time: json['time'],
        hour: json['hour'],
        minute: json['minute'],
        monday: json['monday'],
        tuesday: json['tuesday'],
        wednesday: json['wednesday'],
        thursday: json['thursday'],
        friday: json['friday'],
        saturday: json['saturday'],
        sunday: json['sunday'],
        active: json['active']);
  }
}

abstract class ObservableAlarmBase with Store {
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
  bool monday;

  @observable
  bool tuesday;

  @observable
  bool wednesday;

  @observable
  bool thursday;

  @observable
  bool friday;

  @observable
  bool saturday;

  @observable
  bool sunday;

  @observable
  bool active;

  ObservableAlarmBase(
      {this.id,
      required this.title,
      required this.time,
      required this.hour,
      required this.minute,
      required this.monday,
      required this.tuesday,
      required this.wednesday,
      required this.thursday,
      required this.friday,
      required this.saturday,
      required this.sunday,
      required this.active});
}
