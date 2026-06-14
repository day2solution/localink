import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localink/api_service.dart';
import 'package:localink/login/otp_screen.dart';
import 'package:localink/model/auth_response.dart';
import 'package:localink/model/location_data.dart';
import 'package:localink/util/app-icon.dart';
import 'package:localink/util/app_theme.dart';
import 'package:localink/util/location_util.dart';
import 'package:logging/logging.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoader = false;
  bool _isLocationFetching = false;
  String _addressMessage = "";
  double latitude = 0.0;
  double longitude = 0.0;
  final Logger _log = Logger('SignupScreen');

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    setState(() => _isLocationFetching = true);
    try {
      final locationData = await LocationUtil.getCurrentLocation();
      if (locationData != null && mounted) {
        setState(() {
          latitude = locationData.latitude;
          longitude = locationData.longitude;
          _addressMessage = locationData.address;
        });
      }
    } finally {
      if (mounted) setState(() => _isLocationFetching = false);
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoader = true);

    try {
      final ApiService apiService = ApiService();
      final String phoneNumber = _phoneController.text;
      final String fullName = _nameController.text;

      final Map<String, dynamic> signupData = {
        "fullName": fullName,
        "mobileNumber": phoneNumber,
        "otp": "123456",
        "latitude": latitude,
        "longitude": longitude,
        "address": _addressMessage,
      };

      _log.info("Sending Signup Data: $signupData");

      final AuthResponse response = await apiService.signupWithMobile(signupData);

      if (mounted) {
        setState(() => _isLoader = false);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpScreen(phoneNumber: phoneNumber),
          ),
        );
      }
    } catch (e) {
      _log.severe("Signup error: $e");
      setState(() => _isLoader = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Signup failed: $e"), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.getColors(context);
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 600;

    final Color effectiveBgColor = isTablet ? colors.scaffold : (colors.isDarkMode ? colors.scaffold : Colors.white);
    final Color effectiveContentColor = isTablet ? colors.card : effectiveBgColor;

    return Scaffold(
      backgroundColor: effectiveBgColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: isTablet ? 460 : double.infinity),
                padding: EdgeInsets.symmetric(horizontal: isTablet ? 48 : 24.0, vertical: isTablet ? 56 : 60),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child: AppIcon(size: isTablet ? 120 : 100)),
                      const SizedBox(height: 48),
                      Text(
                        "Create Account",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: isTablet ? 32 : 28,
                          fontWeight: FontWeight.w800,
                          color: colors.text,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Join LocaLink to connect with your local neighborhood.",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          color: colors.subText,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Name Field
                      _buildLabel("FULL NAME", colors.subText),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        textCapitalization: TextCapitalization.words,
                        style: GoogleFonts.plusJakartaSans(color: colors.text, fontWeight: FontWeight.bold),
                        decoration: _buildInputDecoration(colors, hint: "John Doe", icon: Icons.person_outline),
                        validator: (v) => v!.isEmpty ? "Name is required" : null,
                      ),
                      const SizedBox(height: 24),

                      // Phone Field
                      _buildLabel("MOBILE NUMBER", colors.subText),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style: GoogleFonts.plusJakartaSans(color: colors.text, fontWeight: FontWeight.bold, letterSpacing: 2),
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                        decoration: _buildInputDecoration(colors),
                        validator: (v) => v!.length < 10 ? "Enter 10 digits" : null,
                      ),
                      const SizedBox(height: 40),

                      // Button
                      SizedBox(
                        width: double.infinity,
                        height: 64,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                          ),
                          onPressed: (_isLoader || _isLocationFetching) ? null : _handleSignup,
                          child: _isLoader
                              ? const CircularProgressIndicator(color: Colors.white)
                              : _isLocationFetching
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                        ),
                                        const SizedBox(width: 12),
                                        Text("Fetching Location...", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: Colors.white)),
                                      ],
                                    )
                                  : Text("Create Account", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                      ),

                      const SizedBox(height: 24),
                      Center(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("Already have an account? Login", style: TextStyle(color: colors.primary, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_isLocationFetching)
            Positioned(
              top: MediaQuery.of(context).padding.top,
              left: 0,
              right: 0,
              child: const LinearProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Widget _buildLabel(String label, Color color) {
    return Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w800, color: color, letterSpacing: 1.2));
  }

  InputDecoration _buildInputDecoration(dynamic colors, {String? hint, IconData? icon}) {
    return InputDecoration(
      filled: true,
      fillColor: colors.input,
      prefixIcon: icon != null
          ? Icon(icon, color: colors.primary)
          : Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(padding: EdgeInsets.only(left: 16, right: 8), child: Text("🇮🇳", style: TextStyle(fontSize: 20))),
          Text("+91", style: TextStyle(color: colors.text, fontWeight: FontWeight.bold)),
          const SizedBox(width: 12),
        ],
      ),
      hintText: hint ?? "00000 00000",
      // border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: colors.primary, width: 2),
      ),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: colors.subText.withOpacity(0.1))),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: colors.primary, width: 2),
      ),
    );
  }
}