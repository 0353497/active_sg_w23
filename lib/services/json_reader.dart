import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Announcement {
  Announcement({
    required this.date,
    required this.title,
    required this.content,
    required this.type,
    required this.read,
  });

  final String date;
  final String title;
  final String content;
  final String type;
  bool read;

  DateTime get dateTime {
    try {
      return DateFormat('dd/MM/yyyy').parseStrict(date);
    } on FormatException {
      return DateTime.fromMillisecondsSinceEpoch(0);
    }
  }

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      date: json['date']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      read: json['read'] == true,
    );
  }
}

class JsonReader {
  static Future<List> readFacilities() async {
    final json = await rootBundle.loadString("assets/facilities.json");
    final List data = await jsonDecode(json);
    return data;
  }

  static Future<List<Announcement>> readAnnouncements() async {
    final json = await rootBundle.loadString("assets/announcements.json");
    final List data = jsonDecode(json) as List;
    return data
        .map((item) => Announcement.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
