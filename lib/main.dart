import 'package:flutter/material.dart';
import 'package:localink/api_service.dart';
import 'package:localink/login/login_screen.dart';
import 'package:localink/home/home_screen.dart';
import 'package:localink/login/signup_screen.dart';
import 'package:localink/main/splash_screen.dart';
import 'package:localink/util/app_theme.dart';
import 'package:logging/logging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _setupLogging();

  String? currentUserMobile;
  String initialRoute = '/login';

  try {
    final ApiService apiService = ApiService();
    // Fetch user data from backend using stored token
    currentUserMobile = await apiService.getMobileFromToken();

    // FIX 1: Correctly set initial route if user is found
    if (currentUserMobile != null && currentUserMobile.isNotEmpty) {
      initialRoute = '/home';
    } else {
      initialRoute = '/login';
    }
  } catch (e) {
    debugPrint("Startup Auth Check Failed: $e");
    initialRoute = '/login';
  }

  runApp(MyApp(
    initialRoute: initialRoute,
    mobileNumber: currentUserMobile,
  ));
}

void _setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.loggerName}: ${record.message}');
  });
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  final String? mobileNumber;

  const MyApp({
    super.key,
    required this.initialRoute,
    this.mobileNumber
  });

  @override
  Widget build(BuildContext context) {
    debugPrint("App launching with Initial Route: $initialRoute");

    return MaterialApp(
      title: 'LocaLink',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      // FIX 2: Set the initial route dynamically
      initialRoute: initialRoute,

      routes: {
        // We use '/splash' instead of '/' to prevent Flutter from
        // automatically loading it behind other screens.
        '/splash': (context) => const SplashScreen(),

        '/login': (context) => const LoginScreen(),

        '/signup': (context) => const SignupScreen(),

        '/home': (context) {
          // FIX 3: Robust argument handling
          // 1. Check if arguments were passed via Navigator (Manual Login)
          final args = ModalRoute.of(context)?.settings.arguments as String?;

          // 2. Fallback to the number from main() (Auto Login)
          // 3. Last resort "User" to prevent the '!' crash
          final String finalMobile = args ?? mobileNumber ?? "User";

          return HomeScreen(mobileNumber: finalMobile);
        },
      },
    );
  }
}