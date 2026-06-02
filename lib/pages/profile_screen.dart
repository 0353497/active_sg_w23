import 'package:active_sg/pages/onboarding_screen.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Uint8List? _profileImageBytes;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();

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
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    _emailController.text = prefs.getString('profile_email') ?? '';
    _passwordController.text = prefs.getString('profile_password') ?? '';
    _nameController.text = prefs.getString('profile_name') ?? '';
    _addressController.text = prefs.getString('profile_address') ?? '';
    _numberController.text = prefs.getString('profile_number') ?? '';
    final imgString = prefs.getString('profile_image');
    if (imgString != null && imgString.isNotEmpty) {
      try {
        _profileImageBytes = base64Decode(imgString);
      } catch (_) {}
    }
    if (mounted) setState(() {});
  }

  Future<void> _saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_email', _emailController.text);
    await prefs.setString('profile_password', _passwordController.text);
    await prefs.setString('profile_name', _nameController.text);
    await prefs.setString('profile_address', _addressController.text);
    await prefs.setString('profile_number', _numberController.text);
    if (_profileImageBytes != null) {
      await prefs.setString('profile_image', base64Encode(_profileImageBytes!));
    }
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Profile saved locally')));
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
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(hintText: "email"),
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(hintText: "Password"),
                  ),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(hintText: "Name"),
                  ),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(hintText: "Address"),
                  ),
                  TextFormField(
                    controller: _numberController,
                    decoration: InputDecoration(hintText: "Number"),
                  ),
                  OwnRedButton(
                    onTap: () async {
                      await _saveProfile();
                    },
                    text: "SAVE",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
