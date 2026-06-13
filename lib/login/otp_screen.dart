import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localink/home/home_screen.dart';
import 'package:localink/util/app_theme.dart';
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
          behavior: SnackBarBehavior.floating,
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

    // Simulate verification delay
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(mobileNumber: widget.phoneNumber,)),
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 1. GET CENTRALIZED THEME COLORS & RESPONSIVE DETECTION
    final colors = AppTheme.getColors(context);
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 600;

    // Logic for unified background on mobile vs card on tablet
    final Color effectiveBgColor = isTablet
        ? colors.scaffold
        : (colors.isDarkMode ? colors.scaffold : Colors.white);
    final Color effectiveContentColor = isTablet
        ? colors.card
        : effectiveBgColor;

    // 2. PINPUT THEME SETUP (Using AppTheme)
    final defaultPinTheme = PinTheme(
      width: isTablet ? 64 : 52,
      height: isTablet ? 70 : 58,
      textStyle: GoogleFonts.plusJakartaSans(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        color: colors.text,
      ),
      decoration: BoxDecoration(
        color: colors.input,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border, width: 1.5),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: colors.primary, width: 2),
        color: isTablet ? colors.card : effectiveBgColor,
        boxShadow: [
          BoxShadow(
            color: colors.primary.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: effectiveBgColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: colors.text,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Stack(
        children: [
          // 3. DECORATIVE BACKGROUND (Tablet Only)
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

          // 4. MAIN CONTENT
          Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: isTablet ? 480 : double.infinity,
                  minHeight: isTablet ? 0 : MediaQuery.of(context).size.height,
                ),
                margin: EdgeInsets.all(isTablet ? 24 : 0),
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 48 : 28.0,
                  vertical: isTablet ? 56 : 40,
                ),
                decoration: BoxDecoration(
                  color: effectiveContentColor,
                  borderRadius: BorderRadius.circular(isTablet ? 32 : 0),
                  boxShadow: isTablet
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(
                              colors.isDarkMode ? 0.3 : 0.08,
                            ),
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
                    mainAxisAlignment: isTablet
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.center,
                    children: [
                      // --- HERO BRANDING ---
                      Center(
                        child: Hero(
                          tag: 'app_logo',
                          child: Container(
                            height: isTablet ? 100 : 80,
                            width: isTablet ? 100 : 80,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  colors.primary,
                                  colors.primary.withOpacity(0.7),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(
                                isTablet ? 28 : 22,
                              ),
                              boxShadow: colors.isDarkMode
                                  ? null
                                  : [
                                      BoxShadow(
                                        color: colors.primary.withOpacity(0.3),
                                        blurRadius: 20,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                            ),
                            child: const Icon(
                              Icons.verified_user_rounded,
                              size: 36,
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
                          color: colors.text,
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 12),
                      RichText(
                        text: TextSpan(
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: isTablet ? 16 : 15,
                            color: colors.subText,
                            height: 1.6,
                            fontWeight: FontWeight.w500,
                          ),
                          children: [
                            const TextSpan(text: "We have sent a code to "),
                            TextSpan(
                              text: "+91 ${widget.phoneNumber}",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: colors.text,
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
                            color: colors.primary,
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
                                color: colors.subText,
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
                                foregroundColor: colors.primary,
                              ),
                              child: Text(
                                _canResend
                                    ? "Resend New Code"
                                    : "Resend in ${_counter}s",
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: _canResend
                                      ? colors.primary
                                      : colors.subText.withOpacity(0.5),
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
                        height: 64,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.primary,
                            foregroundColor: Colors.white,
                            elevation: colors.isDarkMode ? 0 : 8,
                            shadowColor: colors.primary.withOpacity(0.4),
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
        ],
      ),
    );
  }

  // Helper for Tablet Background
  Widget _buildBlurCircle(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
