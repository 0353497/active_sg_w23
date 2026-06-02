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
