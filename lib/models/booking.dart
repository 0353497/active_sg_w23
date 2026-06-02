import 'package:intl/intl.dart';

class Booking {
  Booking({
    required this.date,
    required this.type,
    required this.time,
    required this.facility,
  });

  final String date;
  final String time;
  final String type;
  final String facility;

  DateTime get dateTime {
    try {
      return DateFormat('dd/MM/yyyy').parseStrict(date);
    } on FormatException {
      return DateTime.fromMillisecondsSinceEpoch(0);
    }
  }

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      date: json['booking_date']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
      facility: json['facility']?.toString() ?? '',
    );
  }
}
