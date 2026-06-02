import 'package:active_sg/pages/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  static const Color _primaryRed = Color(0xffDB3116);
  static const Color _warmCream = Color(0xffFFF9F8);
  static const Color _softSurface = Color(0xffF5E6E4);

  @override
  Widget build(BuildContext context) {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: _primaryRed,
          brightness: Brightness.light,
        ).copyWith(
          primary: _primaryRed,
          secondary: _warmCream,
          surface: _softSurface,
        );

    return GetMaterialApp(
      home: const OnboardingScreen(),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: _warmCream,
        appBarTheme: const AppBarTheme(
          backgroundColor: _primaryRed,
          foregroundColor: _warmCream,
          centerTitle: false,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: _warmCream,
          selectedItemColor: _primaryRed,
          unselectedItemColor: _primaryRed.withValues(alpha: 0.55),
          type: BottomNavigationBarType.fixed,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: _primaryRed,
            textStyle: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return _primaryRed;
            }
            return Colors.white;
          }),
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return _primaryRed.withValues(alpha: 0.35);
            }
            return Colors.black12;
          }),
        ),
      ),
    );
  }
}
