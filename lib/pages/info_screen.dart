import 'package:active_sg/pages/home_screen.dart';
import 'package:active_sg/pages/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'bookings_screen.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "Information",
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
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
          child: Column(
            spacing: 12,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset("assets/images/logo.png"),
              Text("3 Stadium Drive, Singapore 397630"),
              Text(
                "helpme@jappasia.com",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.blue,
                  decorationColor: Colors.blue,
                ),
              ),
              Text(
                "Leave a Feedback",
                style: TextStyle(
                  color: Get.theme.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              Row(),
              TextField(decoration: InputDecoration(hintText: "Title")),
              TextField(
                minLines: 5,
                maxLines: 5,
                decoration: InputDecoration(hintText: "Description"),
              ),
              OwnRedButton(
                onTap: () {
                  Get.dialog(
                    Dialog(
                      child: SizedBox(
                        width: Get.width * .8,
                        height: Get.height * .4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Feedback \n Submitted",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "Thank you for your \n feedback.",
                              textAlign: TextAlign.center,
                            ),
                            Padding(
                              padding: EdgeInsetsGeometry.symmetric(
                                horizontal: 48,
                              ),
                              child: OwnRedButton(
                                onTap: Get.back,
                                text: "DISMISS",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                text: "SUBMIT",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
