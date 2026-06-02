import 'package:active_sg/pages/home_screen.dart';
import 'package:active_sg/pages/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitLogin() {
    final isValid = formkey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email == 'john@gmail.com' && password == '123456') {
      Get.offAll(() => const HomeScreen(isLoggedIn: true));
      return;
    }

    Get.snackbar(
      'Login failed',
      'Incorrect username or password.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade50,
      colorText: Colors.red.shade900,
      margin: const EdgeInsets.all(16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Get.theme.colorScheme.primary,
        leading: IconButton(
          onPressed: () => Get.to(() => const OnboardingScreen()),
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: formkey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
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
                  decoration: InputDecoration(hintText: "Email"),
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  autofillHints: const [AutofillHints.password],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "* Password can not be empty!";
                    }
                    return null;
                  },
                  decoration: InputDecoration(hintText: "Password"),
                ),
                OwnRedButton(onTap: _submitLogin, text: "LOGIN"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
