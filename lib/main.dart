import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      debugShowCheckedModeBanner: false,

      // 1. GLOBAL THEME DATA
      // Setting this here ensures all screens use your professional font automatically
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF2563EB),
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.plusJakartaSansTextTheme(
          Theme.of(context).textTheme,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF0F172A)),
        ),
      ),

      // 2. INITIAL ROUTE
      // The app starts at the Splash Screen
      initialRoute: '/',

      // 3. NAMED ROUTES TABLE
      // This allows you to use Navigator.pushNamedAndRemoveUntil(context, '/login', ...)
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile-setup': (context) => const ProfileSetupScreen(),
      },

      // 4. FALLBACK (Optional)
      // Handles cases where a route name might be misspelled
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      },
    );
  }
}
