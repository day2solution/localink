import 'package:flutter/material.dart';
import 'package:localink/login/login_screen.dart';
import 'package:localink/home/home_screen.dart';
import 'package:localink/profile/profile_setup_screen.dart';
import 'package:localink/main/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LocaLink',

      // 1. THIS IS THE KEY: Set themeMode to system
      themeMode: ThemeMode.system,

      // 2. Define your Light Theme
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF2563EB),
        scaffoldBackgroundColor: Colors.white,
        // ... rest of your light theme
      ),

      // 3. Define your Dark Theme
      // (If this is missing, Theme.of(context).brightness will always be Light)
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF2563EB),
        scaffoldBackgroundColor: const Color(0xFF0F172A), // Dark Navy
        // ... rest of your dark theme
      ),

      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile-setup': (context) => const ProfileSetupScreen(),
      },
    );
  }
}
