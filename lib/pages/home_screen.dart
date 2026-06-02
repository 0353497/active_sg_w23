import 'package:active_sg/pages/announcements_screen.dart';
import 'package:active_sg/pages/bookings_screen.dart';
import 'package:active_sg/pages/login_screen.dart';
import 'package:active_sg/pages/onboarding_screen.dart';
import 'package:active_sg/pages/profile_screen.dart';
import 'package:active_sg/pages/register_screen.dart';
import 'package:active_sg/services/json_reader.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.isLoggedIn = false});
  final bool isLoggedIn;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final PageController _bannerController;
  late final Future<List> _facilitiesFuture;
  Timer? _bannerTimer;
  int _currentBannerIndex = 0;
  bool filterCurrentLoc = false;

  final List<String> _bannerImages = const [
    "assets/images/playon.png",
    "assets/images/teamnila.jpg",
    "assets/images/yeah.jpg",
  ];

  @override
  void initState() {
    super.initState();
    _bannerController = PageController();
    _facilitiesFuture = JsonReader.readFacilities();
    _startBannerAutoScroll();
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  void _startBannerAutoScroll() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted || !_bannerController.hasClients || _bannerImages.isEmpty) {
        return;
      }

      final nextPage = (_currentBannerIndex + 1) % _bannerImages.length;
      _bannerController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    });
  }

  Widget _facilityImage(String? picture) {
    final imageValue = picture?.trim();
    if (imageValue == null || imageValue.isEmpty) {
      return const SizedBox.shrink();
    }

    if (imageValue.startsWith('data:image/')) {
      final commaIndex = imageValue.indexOf(',');
      if (commaIndex == -1) {
        return const SizedBox.shrink();
      }

      final base64Part = imageValue.substring(commaIndex + 1);
      return Image.memory(
        base64Decode(base64Part),
        fit: BoxFit.cover,
        width: double.maxFinite,
        errorBuilder: (context, error, stackTrace) {
          return Center(child: Icon(Icons.error));
        },
      );
    }

    if (imageValue.startsWith('http://') || imageValue.startsWith('https://')) {
      return Image.network(
        imageValue,
        fit: BoxFit.cover,
        width: double.maxFinite,
      );
    }

    return Image.asset(imageValue, fit: BoxFit.cover, width: double.maxFinite);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Johhn Tan",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.menu),
                      title: const Text("My Bookings"),
                      onTap: () => Get.to(
                        () => BookingsScreen(),
                        transition: Transition.fadeIn,
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.person_rounded),
                      title: const Text("Edit Profile"),
                      onTap: () {
                        Navigator.pop(context);
                        Get.to(
                          () => ProfileScreen(),
                          transition: Transition.fadeIn,
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text("Log Out"),
                      onTap: () {
                        Navigator.pop(context);
                        Get.to(
                          () => LoginScreen(),
                          transition: Transition.fadeIn,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Color(0xffF5E6E4),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          if (!widget.isLoggedIn && value >= 1) {
            Get.snackbar("unauthorised acces", "sorry");
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
      body: Stack(
        children: [
          Container(
            color: Theme.of(context).colorScheme.primary,
            width: double.maxFinite,
            height: 200,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 24,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        spacing: 12,
                        children: [
                          InkWell(
                            onTap: () {
                              if (widget.isLoggedIn) {
                                _scaffoldKey.currentState?.openDrawer();
                              }
                            },
                            child: CircleAvatar(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.secondary,
                              foregroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              child: Icon(Icons.person),
                            ),
                          ),
                          Text(
                            widget.isLoggedIn ? "Hi, John" : "Hello!",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          if (!widget.isLoggedIn) {
                            Get.snackbar("unauthorised acces", "sorry");
                            return;
                          }
                          Get.to(
                            () => AnnouncementsScreen(),
                            transition: Transition.fadeIn,
                          );
                        },
                        icon: Icon(
                          Icons.notifications_outlined,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    height: 200,
                    child: PageView(
                      controller: _bannerController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentBannerIndex = index;
                        });
                      },
                      children: [
                        for (final bannerImage in _bannerImages)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              bannerImage,
                              fit: BoxFit.cover,
                              width: double.maxFinite,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 12,
                    children: [
                      for (int i = 0; i < _bannerImages.length; i++)
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 1,
                            ),
                            shape: BoxShape.circle,
                            color: i == _currentBannerIndex
                                ? Theme.of(context).colorScheme.primary
                                : null,
                          ),
                          width: 24,
                          height: 24,
                        ),
                    ],
                  ),
                  if (!widget.isLoggedIn)
                    Row(
                      spacing: 48,
                      children: [
                        Expanded(
                          child: OwnRedButton(
                            onTap: () => Get.to(
                              () => LoginScreen(),
                              transition: Transition.fadeIn,
                            ),
                            text: "LOGIN",
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 64,
                            child: TextButton(
                              style: ButtonStyle(
                                elevation: WidgetStatePropertyAll(8),
                                shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadiusGeometry.circular(
                                      8,
                                    ),
                                    side: BorderSide(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                foregroundColor: WidgetStatePropertyAll(
                                  Theme.of(context).colorScheme.primary,
                                ),
                                backgroundColor: WidgetStatePropertyAll(
                                  Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              onPressed: () => Get.to(
                                () => RegisterScreen(),
                                transition: Transition.fadeIn,
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  spacing: 12,
                                  children: [
                                    Text(
                                      "SIGN UP",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Facilities",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 12,
                        children: [
                          Text("Filter by current location"),
                          CupertinoSwitch(
                            value: filterCurrentLoc,
                            onChanged: (value) {
                              setState(() {
                                filterCurrentLoc = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  Expanded(
                    child: FutureBuilder(
                      future: _facilitiesFuture,
                      builder: (context, asyncSnapshot) {
                        if (asyncSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final facilities = asyncSnapshot.data ?? [];
                        return ListView.builder(
                          itemCount: facilities.length,
                          itemBuilder: (context, index) {
                            final item = facilities[index];
                            return Column(
                              children: [
                                SizedBox(
                                  width: double.maxFinite,
                                  height: 160,
                                  child: Card(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 72,
                                          width: double.maxFinite,
                                          child: _facilityImage(
                                            item["picture"],
                                          ),
                                        ),
                                        Text(
                                          item["name"],
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
