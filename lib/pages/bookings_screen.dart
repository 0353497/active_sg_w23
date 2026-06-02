import 'package:active_sg/pages/home_screen.dart';
import 'package:active_sg/pages/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  bool isFuture = true;

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
            Get.to(() => BookingsScreen(), transition: Transition.fadeIn);
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
          child: Column(
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
                              borderRadius: BorderRadiusGeometry.circular(8),
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
                              borderRadius: BorderRadiusGeometry.circular(8),
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
              if (!isFuture) SizedBox(),
            ],
          ),
        ),
      ),
    );
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
