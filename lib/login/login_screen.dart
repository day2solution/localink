import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localink/api_service.dart';
import 'package:localink/home/home_screen.dart';
import 'package:localink/login/otp_screen.dart';
import 'package:localink/login/signup_screen.dart';
import 'package:localink/model/auth_response.dart';
import 'package:localink/util/app-icon.dart';
import 'package:localink/util/app_theme.dart';
import 'package:logging/logging.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoader = false;
  String _locationMessage = "Fetching location...";
  String _addressMessage = "";
  double latitude = 0.0;
  double longitude = 0.0;
  final Logger _log = Logger('LoginScreen');

  @override
  void initState() {
    super.initState();
    _getCurrentLocationAndAddress();
    checkTokenAndNavigate();
  }

  checkTokenAndNavigate() {
    _log.info("Checking token for navigation...");
    final ApiService apiService = ApiService();
    apiService.getMobileFromToken().then((mobileNumber) {
      if (mobileNumber != null) {
        _log.info("Token navigation successful for: $mobileNumber");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(mobileNumber: mobileNumber),
          ),
          (route) => false,
        );
      }
    });
  }

  Future<void> _getCurrentLocationAndAddress() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1. Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _locationMessage = 'Location services are disabled.';
      });
      return;
    }

    // 2. Check and request permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _locationMessage = 'Location permissions are denied';
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _locationMessage = 'Location permissions are permanently denied.';
      });
      return;
    }

    try {
      // 3. Get the Position (Latitude and Longitude)
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
        _locationMessage =
            "Lat: ${position.latitude} \nLong: ${position.longitude}";
      });

      // 4. Get the Address (Reverse Geocoding)
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      // Placemark contains formatting like street, city, country, zip code, etc.
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _addressMessage =
              "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
        });
        _log.info("Address: ${_addressMessage}");

        String streetName = place.street ?? "";

        // Check if it's a Plus Code
        if (streetName.contains('+')) {
          // Fall back to a neighborhood or road name if the street is just a Plus Code
          streetName = place.subLocality ?? place.thoroughfare ?? "";
        }

        setState(() {
          _addressMessage = "$streetName, ${place.locality}, ${place.country}";
        });
        _log.info("Address: ${_addressMessage}");
      }
    } catch (e) {
      setState(() {
        _addressMessage = "Failed to get address: $e";
      });
      _log.severe("Error getting address: $e");
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. GET CENTRALIZED THEME COLORS & RESPONSIVE DETECTION
    final colors = AppTheme.getColors(context);
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 600;

    // Logic for unified background on mobile vs dual-tone on tablet
    final Color effectiveBgColor = isTablet
        ? colors.scaffold
        : (colors.isDarkMode ? colors.scaffold : Colors.white);
    final Color effectiveContentColor = isTablet
        ? colors.card
        : effectiveBgColor;

    return Scaffold(
      backgroundColor: effectiveBgColor,
      body: Stack(
        children: [
          // 2. DECORATIVE BACKGROUND (Tablet Only)
          if (isTablet) ...[
            Positioned(
              top: -100,
              right: -100,
              child: _buildBlurCircle(
                colors.primary.withOpacity(colors.isDarkMode ? 0.08 : 0.05),
                300,
              ),
            ),
            Positioned(
              bottom: -50,
              left: -50,
              child: _buildBlurCircle(
                colors.primary.withOpacity(colors.isDarkMode ? 0.08 : 0.05),
                200,
              ),
            ),
          ],

          // 3. MAIN CONTENT
          Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: isTablet ? 460 : double.infinity,
                  minHeight: isTablet ? 0 : MediaQuery.of(context).size.height,
                ),
                margin: EdgeInsets.all(isTablet ? 32 : 0),
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 48 : 24.0,
                  vertical: isTablet ? 56 : 40,
                ),
                decoration: BoxDecoration(
                  color: effectiveContentColor,
                  borderRadius: BorderRadius.circular(isTablet ? 32 : 0),
                  boxShadow: isTablet
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(
                              colors.isDarkMode ? 0.3 : 0.06,
                            ),
                            blurRadius: 40,
                            offset: const Offset(0, 20),
                          ),
                        ]
                      : null,
                ),
                child: SafeArea(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: isTablet
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.center,
                      children: [
                        // --- BRANDING ---
                        Center(
                          child: AppIcon(
                            size: isTablet ? 120 : 100,
                            heroTag: 'app_logo',
                          ),
                        ),
                        const SizedBox(height: 48),

                        // --- HEADERS ---
                        Text(
                          "Welcome back",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: isTablet ? 32 : 28,
                            fontWeight: FontWeight.w800,
                            color: colors.text,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Enter your mobile number to connect with your local community.",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: isTablet ? 16 : 15,
                            color: colors.subText,
                            height: 1.6,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 40),

                        // --- INPUT SECTION ---
                        _buildInputLabel("MOBILE NUMBER", colors.subText),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            color: colors.text,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          decoration: _buildInputDecoration(
                            colors.primary,
                            colors.input,
                            colors.text,
                            colors.subText,
                          ),
                          validator: (value) {
                            if (value == null || value.length < 10) {
                              return "Please enter a valid 10-digit number";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 40),

                        // --- ACTION BUTTON ---
                        _buildLoginButton(colors.primary),

                        const SizedBox(height: 32),

                        // --- FOOTER ---
                        _buildFooter(colors.primary, colors.subText),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- UI HELPER WIDGETS ---

  Widget _buildBlurCircle(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _buildInputLabel(String label, Color color) {
    return Text(
      label,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        color: color,
        letterSpacing: 1.2,
      ),
    );
  }

  InputDecoration _buildInputDecoration(
    Color primary,
    Color fill,
    Color text,
    Color hint,
  ) {
    return InputDecoration(
      filled: true,
      fillColor: fill,
      prefixIcon: Container(
        padding: const EdgeInsets.only(left: 16, right: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("🇮🇳", style: TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text(
              "+91",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: text,
              ),
            ),
            const SizedBox(width: 12),
            Container(height: 24, width: 1.5, color: hint.withOpacity(0.3)),
          ],
        ),
      ),
      hintText: "00000 00000",
      hintStyle: GoogleFonts.plusJakartaSans(
        fontSize: 18,
        color: hint.withOpacity(0.5),
        letterSpacing: 2,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: primary, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: hint.withOpacity(0.1), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: primary, width: 2),
      ),
      errorStyle: GoogleFonts.plusJakartaSans(
        fontWeight: FontWeight.w600,
        color: Colors.redAccent,
      ),
    );
  }

  Widget _buildLoginButton(Color primaryColor) {
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        onPressed: _isLoader ? null : _handleLogin,
        child: _isLoader
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              )
            : Text(
                "Send Verification Code",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoader = true);

    try {
      final ApiService apiService = ApiService();
      final String phoneNumber = _phoneController.text;

      _log.info("Sending OTP to: $phoneNumber");
      // Prepare the data map
      final Map<String, dynamic> login_data = {
        "mobileNumber": phoneNumber,
        "otp": "123456",
        "latitude": latitude,
        "longitude": longitude,
      };

      // Attempt the API call
      final AuthResponse response = await apiService.loginWithMobile(
        login_data,
      );

      if (response.accessToken.isNotEmpty) {
        _log.info("Login successful for: ${response.mobileNumber}");

        if (mounted) {
          setState(() => _isLoader = false);

          // Show success message if needed
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpScreen(phoneNumber: phoneNumber),
            ),
          );
        }
      }else{
        if (mounted) {
          setState(() => _isLoader = false);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      // Log the full error for debugging
      _log.severe("Auth Error: $e");

      if (mounted) {
        setState(() => _isLoader = false);

        // Use a helper method or clean the error string for the UI
        String errorMessage = e.toString().replaceAll('Exception:', '').trim();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text("Authentication Failed: $errorMessage")),
              ],
            ),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'RETRY',
              textColor: Colors.white,
              onPressed: _handleLogin,
            ),
          ),
        );
      }
    }
  }

  Widget _buildFooter(Color primaryColor, Color secondaryColor) {
    return Column(
      children: [
        // --- SIGN UP LINK ---
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an account? ",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: secondaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignupScreen()),
                );
              },
              child: Text(
                "Sign Up",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),

        // --- TERMS & PRIVACY ---
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: secondaryColor,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
            children: [
              const TextSpan(text: "By continuing, you agree to our "),
              TextSpan(
                text: "Terms",
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const TextSpan(text: " & "),
              TextSpan(
                text: "Privacy Policy",
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Text(_locationMessage),
      ],
    );
  }
}
