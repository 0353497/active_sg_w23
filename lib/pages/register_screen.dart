import 'package:active_sg/pages/home_screen.dart';
import 'package:active_sg/pages/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _submitRegistration() {
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    final email = _emailController.text.trim();
    if (email == 'john@gmail.com') {
      Get.snackbar(
        'Registration failed',
        'This email is already registered.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    Get.to(() => HomeScreen(isLoggedIn: true), transition: Transition.fadeIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Get.theme.colorScheme.primary,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset("assets/images/logo.png"),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    validator: (value) {
                      final email = value?.trim() ?? '';
                      if (email.isEmpty) {
                        return "* email can not be empty!";
                      }
                      if (!GetUtils.isEmail(email)) {
                        return "* value is not a valid email";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(hintText: "Email"),
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    autofillHints: const [AutofillHints.newPassword],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "* Password can not be empty!";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(hintText: "Password"),
                  ),
                  TextFormField(
                    controller: _nameController,
                    autofillHints: const [AutofillHints.name],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "* Name can not be empty!";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(hintText: "Name"),
                  ),
                  TextFormField(
                    controller: _addressController,
                    autofillHints: const [AutofillHints.streetAddressLine1],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "* Address can not be empty!";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(hintText: "Address"),
                  ),
                  const SizedBox(height: 24),
                  OwnRedButton(onTap: _submitRegistration, text: "SIGN UP"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
