import 'dart:convert';

import 'package:active_sg/models/announcement.dart';
import 'package:active_sg/models/booking.dart';
import 'package:flutter/services.dart';

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

  static Future<List<Booking>> readBookings() async {
    final json = await rootBundle.loadString("assets/bookings.json");
    final List data = await jsonDecode(json);
    return data.map((e) => Booking.fromJson(e)).toList();
  }
}
