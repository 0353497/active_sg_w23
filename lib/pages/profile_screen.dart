import 'package:active_sg/pages/onboarding_screen.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Uint8List? _profileImageBytes;

  Future<void> _pickProfileImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);

    if (pickedImage == null) {
      return;
    }

    final imageBytes = await pickedImage.readAsBytes();

    if (!mounted) {
      return;
    }

    setState(() {
      _profileImageBytes = imageBytes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        leading: IconButton(
          onPressed: Get.back,
          icon: Icon(
            Icons.arrow_back_ios,
            color: Get.theme.colorScheme.primary,
          ),
        ),

        centerTitle: true,
        title: Text(
          "Edit Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Get.theme.colorScheme.primary,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(23.0),
          child: Center(
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 24,
                children: [
                  InkWell(
                    onTap: () {
                      Get.bottomSheet(
                        Container(
                          color: Colors.white,
                          width: double.maxFinite,
                          height: 120,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                onTap: () async {
                                  Navigator.of(context).pop();
                                  await _pickProfileImage(ImageSource.gallery);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  spacing: 12,
                                  children: [
                                    Icon(Icons.photo_album),
                                    Text(
                                      "Gallery",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  Navigator.of(context).pop();
                                  await _pickProfileImage(ImageSource.camera);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  spacing: 12,
                                  children: [
                                    Icon(Icons.camera_alt),
                                    Text(
                                      "Camera",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Badge(
                      label: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Get.theme.primaryColor,
                        ),
                        width: 24,
                        height: 24,
                        child: Icon(Icons.camera_alt, color: Colors.white),
                      ),
                      offset: Offset(-50, 175),
                      child: CircleAvatar(
                        radius: 100,
                        backgroundColor: Colors.grey.shade200,
                        child: _profileImageBytes == null
                            ? Icon(
                                Icons.person,
                                size: 90,
                                color: Colors.grey.shade600,
                              )
                            : ClipOval(
                                child: Image.memory(
                                  _profileImageBytes!,
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                  ),
                  TextFormField(decoration: InputDecoration(hintText: "email")),
                  TextFormField(
                    decoration: InputDecoration(hintText: "Password"),
                  ),
                  TextFormField(decoration: InputDecoration(hintText: "Name")),
                  TextFormField(
                    decoration: InputDecoration(hintText: "Address"),
                  ),
                  TextFormField(
                    decoration: InputDecoration(hintText: "Number"),
                  ),
                  OwnRedButton(onTap: () {}, text: "SAVE"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
