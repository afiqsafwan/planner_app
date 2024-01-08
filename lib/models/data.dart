//import 'package:flutter/foundation.dart';

class Data {
  final String id; // final mean value can not change
  final String title;
  final String note;
  final DateTime duedate;
  final DateTime date;

  Data({
    required this.id,
    required this.title,
    required this.note,
    required this.duedate,
    required this.date,
  });
}
