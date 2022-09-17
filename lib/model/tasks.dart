import 'dart:convert';

import 'package:flutter/src/widgets/editable_text.dart';

class Task {
  int? id, isCompleted, color, remind;
  String? title, note, date, startDate, endDate, repeat;

  Task({
    this.id,
    this.isCompleted,
    this.color,
    this.remind,
    this.title,
    this.note,
    this.date,
    this.startDate,
    this.endDate,
    this.repeat,
  });
  Task.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    isCompleted = json['isCompleted'];
    color = json['color'];
    remind = json['remind'];
    title = json['title'];
    note = json['note'];
    date = json['date'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    repeat = json['repeat'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data['isCompleted'] = isCompleted;
    data['color'] = color;
    data['remind'] = remind;
    data['title'] = title;
    data['note'] = note;
    data['date'] = date;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['repeat'] = repeat;
    return data;
  }
}
