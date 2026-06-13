import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localink/api_service.dart';
import 'package:localink/home/home_screen.dart';
import 'package:localink/login/login_screen.dart';
// import 'package:localink/login/login_screen.dart';
import 'package:localink/util/app-icon.dart';
import 'package:logging/logging.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final Logger _log = Logger('SplashScreen');
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutBack,
    );

    // Navigate to Home after 3 seconds
    // Inside SplashScreen State (usually initState)
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        // ONLY navigate if the splash screen is the one actually visible
        if (ModalRoute.of(context)?.isCurrent ?? false) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      }
    });
  }

  checkTokenAndNavigate() async{
    final ApiService apiService = ApiService();
    await apiService.getMobileFromToken().then((mobileNumber) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(mobileNumber: mobileNumber),
        ),
        (route) => false,
      );
    }).catchError((error) {
         _log.severe("Error checking token: $error");
    });


  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Matches your Home Screen BG
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // buildAppIcon(120), // Using your custom icon code
              const AppIcon(size: 120),
              const SizedBox(height: 24),
              Text(
                "LocaLink",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF0F172A),
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Your Neighborhood, Connected",
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAppIcon(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563EB).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.location_on_rounded,
              size: size * 0.6,
              color: Colors.white.withOpacity(0.2),
            ),
            Icon(Icons.link_rounded, size: size * 0.45, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
