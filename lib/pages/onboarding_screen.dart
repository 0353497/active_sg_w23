import 'package:active_sg/pages/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(64.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset("assets/images/logo.png"),
                Text(
                  "Welcome to ActiveSG!",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                Column(
                  spacing: 24,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("- Easily book ActiveSG facilities within our app"),
                    Text(
                      "- Add your favourites facilities to your favourtes list",
                    ),
                    Text("- Look at What's Happening for ActiveSG updates"),
                  ],
                ),

                OwnRedButton(
                  onTap: () =>
                      Get.to(() => HomeScreen(), transition: Transition.fadeIn),
                  text: "LET'S GO",
                  showIcon: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OwnRedButton extends StatelessWidget {
  const OwnRedButton({
    super.key,
    required this.onTap,
    required this.text,
    this.showIcon = false,
  });
  final VoidCallback onTap;
  final String text;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      width: double.maxFinite,
      child: TextButton(
        style: ButtonStyle(
          elevation: WidgetStatePropertyAll(8),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(8),
            ),
          ),
          foregroundColor: WidgetStatePropertyAll(Color(0xffF5E6E4)),
          backgroundColor: WidgetStatePropertyAll(Color(0xffDB3116)),
        ),
        onPressed: onTap,
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 12,
            children: [
              Text(
                text,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              if (showIcon) Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }
}
