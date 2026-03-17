import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localink/home/home_screen.dart';
import 'package:pinput/pinput.dart';
import 'dart:async';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpScreen({super.key, required this.phoneNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _pinController = TextEditingController();

  int _counter = 30;
  late Timer _timer;
  bool _canResend = false;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_counter > 0) {
        if (mounted) setState(() => _counter--);
      } else {
        if (mounted) setState(() => _canResend = true);
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pinController.dispose();
    super.dispose();
  }

  void _handleVerify() {
    final otp = _pinController.text;

    // Check if OTP is empty or less than 6 digits
    if (otp.isEmpty || otp.length < 6) {
      final double screenWidth = MediaQuery.of(context).size.width;
      final bool isTablet = screenWidth > 600;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  otp.isEmpty
                      ? "Please enter the OTP"
                      : "Please enter all 6 digits",
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFFEF4444),
          // Modern Red-500
          behavior: SnackBarBehavior.floating,
          // Constrain width on tablets so it doesn't stretch across the whole screen
          margin: EdgeInsets.symmetric(
            horizontal: isTablet ? (screenWidth - 400) / 2 : 20,
            vertical: 24,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    setState(() => _isVerifying = true);

    // Simulate API Verification
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 600;

    const Color primaryColor = Color(0xFF2563EB);
    const Color secondaryColor = Color(0xFF64748B);

    final defaultPinTheme = PinTheme(
      width: isTablet ? 64 : 52,
      height: isTablet ? 70 : 58,
      textStyle: GoogleFonts.plusJakartaSans(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        color: const Color(0xFF0F172A),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: primaryColor, width: 2),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: isTablet ? const Color(0xFFEEF2FF) : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF0F172A),
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: isTablet ? 480 : double.infinity,
            ),
            margin: EdgeInsets.all(isTablet ? 24 : 0),
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 48 : 28.0,
              vertical: isTablet ? 48 : 10,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(isTablet ? 32 : 0),
              boxShadow: isTablet
                  ? [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.08),
                        blurRadius: 40,
                        offset: const Offset(0, 20),
                      ),
                    ]
                  : null,
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- HERO BRANDING ---
                  Center(
                    child: Hero(
                      tag: 'app_logo',
                      child: Container(
                        height: isTablet ? 100 : 80,
                        // Slightly larger on tablet
                        width: isTablet ? 100 : 80,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              primaryColor,
                              primaryColor.withOpacity(0.7),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(
                            isTablet ? 28 : 22,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.verified_user_rounded,
                          // More professional for verification
                          size: isTablet ? 42 : 36,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // --- HEADER ---
                  Text(
                    "Verification",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: isTablet ? 32 : 28,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F172A),
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: isTablet ? 16 : 15,
                        color: secondaryColor,
                        height: 1.6,
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        const TextSpan(text: "We have sent a code to "),
                        TextSpan(
                          text: "+91 ${widget.phoneNumber}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),

                  // --- OTP INPUT ---
                  Center(
                    child: Pinput(
                      length: 6,
                      controller: _pinController,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: focusedPinTheme,
                      hapticFeedbackType: HapticFeedbackType.mediumImpact,
                      onCompleted: (pin) => _handleVerify(),
                      cursor: Container(
                        width: 2,
                        height: 24,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // --- RESEND LOGIC ---
                  Center(
                    child: Column(
                      children: [
                        Text(
                          "Didn't receive the code?",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: secondaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        TextButton(
                          onPressed: _canResend
                              ? () {
                                  setState(() {
                                    _counter = 30;
                                    _canResend = false;
                                  });
                                  _startTimer();
                                }
                              : null,
                          style: TextButton.styleFrom(
                            foregroundColor: primaryColor,
                          ),
                          child: Text(
                            _canResend
                                ? "Resend New Code"
                                : "Resend in ${_counter}s",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: _canResend
                                  ? primaryColor
                                  : secondaryColor.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: isTablet ? 48 : 60),

                  // --- VERIFY BUTTON ---
                  SizedBox(
                    width: double.infinity,
                    height: 64, // Taller button for better reachability
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 8,
                        shadowColor: primaryColor.withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: _isVerifying ? null : _handleVerify,
                      child: _isVerifying
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : Text(
                              "Verify & Continue",
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
