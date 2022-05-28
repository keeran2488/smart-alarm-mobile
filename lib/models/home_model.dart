class Room {
  final int id;
  final String name;
  final int iconData;

  Room({required this.id, required this.name, required this.iconData});

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      name: json['name'],
      iconData: json['icon_data'],
    );
  }
}

class Device {
  final int id;
  final String name;
  final bool status;
  final int iconData;
  final int room;
  final int pin;

  Device(
      {required this.id,
      required this.name,
      required this.status,
      required this.iconData,
      required this.room,
      required this.pin});

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
        id: json['id'],
        name: json['name'],
        status: json['status'],
        iconData: json['icon_data'],
        room: json['room'],
        pin: json['pin']);
  }
}
