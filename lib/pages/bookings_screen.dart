import 'package:active_sg/models/booking.dart';
import 'package:active_sg/pages/home_screen.dart';
import 'package:active_sg/pages/info_screen.dart';
import 'package:active_sg/pages/onboarding_screen.dart';
import 'package:active_sg/services/json_reader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  bool isFuture = true;

  List<MapEntry<DateTime, int>> get bookingsByMonth {
    final now = DateTime(2026, 1);
    final startMonth = DateTime(now.year, now.month - 2, 1);
    final months = List<DateTime>.generate(
      3,
      (i) => DateTime(startMonth.year, startMonth.month + i, 1),
    );

    return months.map((m) {
      final count = bookings
          .where(
            (b) => b.dateTime.year == m.year && b.dateTime.month == m.month,
          )
          .length;
      return MapEntry<DateTime, int>(m, count);
    }).toList();
  }

  late List<Booking> bookings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "Bookings",
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (value) {
          if (value == 0) {
            Get.to(
              () => HomeScreen(isLoggedIn: true),
              transition: Transition.fadeIn,
            );
            return;
          }
          if (value == 1) {
            Get.to(() => BookingsScreen(), transition: Transition.fadeIn);
            return;
          }
          if (value == 2) {
            Get.snackbar("Under Construction", "sorry");
            return;
          }
          if (value == 3) {
            Get.to(() => InfoScreen(), transition: Transition.fadeIn);
            return;
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Bookings"),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favourites",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: "Info"),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Row(
                      spacing: 48,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Flexible(
                          child: SizedBox(
                            height: 64,
                            width: double.maxFinite,
                            child: TextButton(
                              style: ButtonStyle(
                                elevation: WidgetStatePropertyAll(8),
                                shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadiusGeometry.circular(
                                      8,
                                    ),
                                    side: BorderSide(
                                      color: Color(0xffDB3116),
                                      width: 2,
                                    ),
                                  ),
                                ),
                                foregroundColor: WidgetStatePropertyAll(
                                  isFuture ? Colors.white : Color(0xffDB3116),
                                ),
                                backgroundColor: WidgetStatePropertyAll(
                                  isFuture ? Color(0xffDB3116) : Colors.white,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  isFuture = true;
                                });
                              },
                              child: Text(
                                "FUTURE",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: SizedBox(
                            height: 64,
                            width: double.maxFinite,
                            child: TextButton(
                              style: ButtonStyle(
                                elevation: WidgetStatePropertyAll(8),
                                shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadiusGeometry.circular(
                                      8,
                                    ),
                                    side: BorderSide(
                                      color: Color(0xffDB3116),
                                      width: 2,
                                    ),
                                  ),
                                ),
                                foregroundColor: WidgetStatePropertyAll(
                                  isFuture ? Color(0xffDB3116) : Colors.white,
                                ),
                                backgroundColor: WidgetStatePropertyAll(
                                  isFuture ? Colors.white : Color(0xffDB3116),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  isFuture = false;
                                });
                              },
                              child: Text(
                                "Past",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (isFuture) EmptyPlaceHolderBookings(),
                    if (!isFuture)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("No, of bookings"),
                            SizedBox(
                              width: double.maxFinite,
                              height: 350,
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  final monthlyBookings = bookingsByMonth;
                                  final monthCount = 3;
                                  final maxBookingCount = monthlyBookings
                                      .map((entry) => entry.value)
                                      .fold(0, math.max);

                                  const labelBottom = 14.0;
                                  const graphBottom = 56.0;
                                  const maxBarHeight = 220.0;
                                  final availableGraphWidth =
                                      constraints.maxWidth * 0.82;
                                  final segmentWidth = monthCount == 0
                                      ? 0.0
                                      : availableGraphWidth / monthCount;
                                  final barWidth = monthCount == 0
                                      ? 0.0
                                      : math.min(50.0, segmentWidth * 0.62);

                                  return Stack(
                                    children: [
                                      Positioned(
                                        left: 0,
                                        right: 0,
                                        top: 0,
                                        bottom: graphBottom,
                                        child: Container(color: Colors.white),
                                      ),
                                      for (int i = 0; i < monthCount; i++)
                                        Positioned(
                                          left:
                                              (segmentWidth * i) +
                                              ((segmentWidth - barWidth) / 2),
                                          bottom: graphBottom,
                                          child: Container(
                                            height: maxBookingCount == 0
                                                ? 0
                                                : math.max(
                                                    0,
                                                    (monthlyBookings[i].value /
                                                            maxBookingCount) *
                                                        maxBarHeight,
                                                  ),
                                            width: barWidth,
                                            color: Get.theme.primaryColor,
                                          ),
                                        ),
                                      for (int i = 0; i < monthCount; i++)
                                        Positioned(
                                          left: segmentWidth * i,
                                          width: segmentWidth,
                                          bottom: labelBottom,
                                          child: Text(
                                            DateFormat(
                                              "MMM yyyy",
                                            ).format(monthlyBookings[i].key),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      const Positioned(
                                        right: 0,
                                        bottom: labelBottom,
                                        child: Text("Month"),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: ListView.builder(
                                  itemCount: bookings.length,
                                  itemBuilder: (context, index) {
                                    final Booking booking = bookings[index];
                                    return SizedBox(
                                      height: 100,
                                      child: Card(
                                        color: Get.theme.colorScheme.primary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadiusGeometry.circular(16),
                                          side: BorderSide(
                                            color: Get.theme.primaryColor,
                                            width: 1,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    DateFormat(
                                                      "d MMM yyy, H a",
                                                    ).format(booking.dateTime),
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                  Icon(
                                                    booking.icon,
                                                    color: Colors.white,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                width: double.maxFinite,
                                                color: Colors.white,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                    8.0,
                                                  ),
                                                  child: Text(booking.facility),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
        ),
      ),
    );
  }

  void init() async {
    final data = await JsonReader.readBookings();

    data.sort(
      (a, b) => a.dateTime.millisecondsSinceEpoch.compareTo(
        b.dateTime.millisecondsSinceEpoch,
      ),
    );

    final now = DateTime(2026, 1);
    final startInclusive = DateTime(now.year, now.month - 2, 1);
    final endExclusive = DateTime(now.year, now.month + 1, 1);

    bookings = data.where((b) {
      final dt = b.dateTime;
      return (dt.isAtSameMomentAs(startInclusive) ||
              dt.isAfter(startInclusive)) &&
          dt.isBefore(endExclusive);
    }).toList();
    setState(() {
      isLoading = false;
    });
  }
}

class EmptyPlaceHolderBookings extends StatelessWidget {
  const EmptyPlaceHolderBookings({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 12,
        children: [
          Image.asset("assets/images/bookings.png"),
          Text(
            "No bookings at the moment.",
            style: TextStyle(color: Colors.grey),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: OwnRedButton(onTap: () {}, text: "BACK TO FACILITIES"),
          ),
          Row(),
        ],
      ),
    );
  }
}
