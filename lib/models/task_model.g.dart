// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$Task on TaskBase, Store {
  final _$idAtom = Atom(name: 'TaskBase.id');

  @override
  int? get id {
    _$idAtom.reportRead();
    return super.id;
  }

  @override
  set id(int? value) {
    _$idAtom.reportWrite(value, super.id, () {
      super.id = value;
    });
  }

  final _$automatedtaskAtom = Atom(name: 'TaskBase.automatedtask');

  @override
  int? get automatedtask {
    _$automatedtaskAtom.reportRead();
    return super.automatedtask;
  }

  @override
  set automatedtask(int? value) {
    _$automatedtaskAtom.reportWrite(value, super.automatedtask, () {
      super.automatedtask = value;
    });
  }

  final _$roomAtom = Atom(name: 'TaskBase.room');

  @override
  int? get room {
    _$roomAtom.reportRead();
    return super.room;
  }

  @override
  set room(int? value) {
    _$roomAtom.reportWrite(value, super.room, () {
      super.room = value;
    });
  }

  final _$deviceAtom = Atom(name: 'TaskBase.device');

  @override
  int? get device {
    _$deviceAtom.reportRead();
    return super.device;
  }

  @override
  set device(int? value) {
    _$deviceAtom.reportWrite(value, super.device, () {
      super.device = value;
    });
  }

  final _$statusAtom = Atom(name: 'TaskBase.status');

  @override
  bool get status {
    _$statusAtom.reportRead();
    return super.status;
  }

  @override
  set status(bool value) {
    _$statusAtom.reportWrite(value, super.status, () {
      super.status = value;
    });
  }

  final _$toD0Atom = Atom(name: 'TaskBase.toD0');

  @override
  bool get toD0 {
    _$toD0Atom.reportRead();
    return super.toD0;
  }

  @override
  set toD0(bool value) {
    _$toD0Atom.reportWrite(value, super.toD0, () {
      super.toD0 = value;
    });
  }

  @override
  String toString() {
    return '''
id: ${id},
automatedtask: ${automatedtask},
room: ${room},
device: ${device},
status: ${status},
toD0: ${toD0}
    ''';
  }
}
