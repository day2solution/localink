import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localink/login/otp_screen.dart';
import 'package:localink/util/app-icon.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoader = false;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 600;

    const Color primaryColor = Color(0xFF2563EB);
    const Color secondaryColor = Color(0xFF64748B);
    const Color darkColor = Color(0xFF0F172A);

    return Scaffold(
      backgroundColor: isTablet ? const Color(0xFFF8FAFC) : Colors.white,
      body: Stack(
        children: [

          // 1. DECORATIVE BACKGROUND (Only for Tablets)
          if (isTablet) ...[
            Positioned(
              top: -100,
              right: -100,
              child: _buildBlurCircle(primaryColor.withOpacity(0.05), 300),
            ),
            Positioned(
              bottom: -50,
              left: -50,
              child: _buildBlurCircle(Colors.blue.withOpacity(0.05), 200),
            ),
          ],

          Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: isTablet ? 460 : double.infinity,
                ),
                margin: EdgeInsets.all(isTablet ? 32 : 0),
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 48 : 24.0,
                  vertical: isTablet ? 56 : 40,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(isTablet ? 32 : 0),
                  boxShadow: isTablet
                      ? [
                          BoxShadow(
                            color: const Color(0xFF0F172A).withOpacity(0.06),
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
                      children: [
                        // --- BRANDING ---
                        Center(
                          // child: _buildBranding(isTablet, primaryColor),
                          child: const AppIcon(size: 120),
                        ),
                        const SizedBox(height: 48),

                        // --- HEADERS ---
                        Text(
                          "Welcome back",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: isTablet ? 32 : 28,
                            fontWeight: FontWeight.w800,
                            color: darkColor,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Enter your mobile number to connect with your local community.",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: isTablet ? 16 : 15,
                            color: secondaryColor,
                            height: 1.6,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 40),

                        // --- INPUT SECTION ---
                        _buildInputLabel("MOBILE NUMBER"),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            color: darkColor,
                          ),
                          decoration: _buildInputDecoration(primaryColor),
                          validator: (value) {
                            if (value == null || value.length < 10) {
                              return "Please enter a valid 10-digit number";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 40),

                        // --- ACTION BUTTON ---
                        _buildLoginButton(primaryColor),

                        const SizedBox(height: 32),

                        // --- FOOTER ---
                        _buildFooter(primaryColor, secondaryColor),
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

  Widget _buildBlurCircle(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _buildBranding(bool isTablet, Color primaryColor) {
    return Hero(
      tag: 'app_logo',
      child: Container(
        height: isTablet ? 90 : 80,
        width: isTablet ? 90 : 80,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryColor, primaryColor.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(isTablet ? 24 : 20),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.25),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: const Icon(
          Icons.share_location_rounded,
          size: 38,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        color: const Color(0xFF94A3B8), // Slate 400
        letterSpacing: 1.2,
      ),
    );
  }

  InputDecoration _buildInputDecoration(Color primaryColor) {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
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
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(width: 12),
            Container(height: 24, width: 1.5, color: const Color(0xFFCBD5E1)),
          ],
        ),
      ),
      hintText: "00000 00000",
      hintStyle: GoogleFonts.plusJakartaSans(
        fontSize: 18,
        color: const Color(0xFF94A3B8),
        letterSpacing: 2,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
      errorStyle: GoogleFonts.plusJakartaSans(
        fontWeight: FontWeight.w600,
        color: Colors.redAccent,
      ),
    );
  }

  Widget _buildLoginButton(Color primaryColor) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
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

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoader = true);
      if (mounted) {
        setState(() => _isLoader = false);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpScreen(phoneNumber: _phoneController.text),
          ),
        );
      }
    }
  }

  Widget _buildFooter(Color primaryColor, Color secondaryColor) {
    return Center(
      child: RichText(
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
    );
  }
}
