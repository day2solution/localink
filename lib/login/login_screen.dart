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
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. RESPONSIVE & THEME DETECTION
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 600;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // 2. DYNAMIC COLOR PALETTE
    const Color primaryColor = Color(0xFF2563EB);
    final Color textColor = isDarkMode ? Colors.white : const Color(0xFF0F172A);
    final Color secondaryTextColor = isDarkMode ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final Color cardColor = isDarkMode ? const Color(0xFF1E293B) : Colors.white;
    final Color scaffoldBg = isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final Color inputFillColor = isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);

    return Scaffold(
      // On mobile, use standard scaffold bg. On tablet, use a slightly different shade for depth.
      backgroundColor: isTablet ? scaffoldBg : (isDarkMode ? const Color(0xFF0F172A) : Colors.white),
      body: Stack(
        children: [
          // Decorative background elements for Tablet
          if (isTablet) ...[
            Positioned(
              top: -100,
              right: -100,
              child: _buildBlurCircle(primaryColor.withOpacity(isDarkMode ? 0.08 : 0.05), 300),
            ),
            Positioned(
              bottom: -50,
              left: -50,
              child: _buildBlurCircle(Colors.blue.withOpacity(isDarkMode ? 0.08 : 0.05), 200),
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
                  color: cardColor,
                  borderRadius: BorderRadius.circular(isTablet ? 32 : 0),
                  boxShadow: isTablet
                      ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.06),
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
                            color: textColor,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Enter your mobile number to connect with your local community.",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: isTablet ? 16 : 15,
                            color: secondaryTextColor,
                            height: 1.6,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 40),

                        // --- INPUT SECTION ---
                        _buildInputLabel("MOBILE NUMBER", secondaryTextColor),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            color: textColor,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          decoration: _buildInputDecoration(
                              primaryColor,
                              inputFillColor,
                              textColor,
                              secondaryTextColor
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
                        _buildLoginButton(primaryColor),

                        const SizedBox(height: 32),

                        // --- FOOTER ---
                        _buildFooter(primaryColor, secondaryTextColor),
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

  InputDecoration _buildInputDecoration(Color primary, Color fill, Color text, Color hint) {
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
        borderSide: BorderSide.none,
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

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoader = true);
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() => _isLoader = false);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpScreen(phoneNumber: _phoneController.text),
            ),
          );
        }
      });
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