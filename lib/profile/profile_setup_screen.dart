import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localink/login/login_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final Color primaryColor = const Color(0xFF2563EB);
  final Color textDark = const Color(0xFF0F172A);

  @override
  Widget build(BuildContext context) {
    // 1. Detect Screen Type
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: isTablet,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: textDark,
            size: isTablet ? 24 : 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Set Up Profile",
          style: GoogleFonts.plusJakartaSans(
            color: textDark,
            fontWeight: FontWeight.w800,
            fontSize: isTablet ? 24 : 18,
          ),
        ),
        // --- ADDED LOGOUT BUTTON ---
        actions: [
          IconButton(
            onPressed: () => _showLogoutDialog(context, isTablet),
            icon: Icon(
              Icons.logout_rounded,
              color: Colors.redAccent,
              size: isTablet ? 28 : 24,
            ),
            tooltip: "Logout",
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        // Center content on tablets
        child: Container(
          // 2. Limit width on tablets to prevent the form from stretching
          constraints: BoxConstraints(
            maxWidth: isTablet ? 550 : double.infinity,
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: isTablet ? 40 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // --- PROFILE PICTURE SECTION ---
                Center(
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: primaryColor.withOpacity(0.2),
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: isTablet ? 75 : 60, // Scaled for Tablet
                          backgroundImage: const NetworkImage(
                            'https://i.pravatar.cc/150?u=9',
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.white,
                            size: isTablet ? 24 : 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // --- FORM FIELDS ---
                _buildFieldLabel("Full Name", isTablet),
                _buildTextField("John Doe", Icons.person_outline, isTablet),

                const SizedBox(height: 20),

                _buildFieldLabel("Bio / About You", isTablet),
                _buildTextField(
                  "Passionate about local gardening and dog walking!",
                  Icons.edit_note_rounded,
                  isTablet,
                  maxLines: 3,
                ),

                const SizedBox(height: 20),

                _buildFieldLabel("Home Neighborhood", isTablet),
                _buildTextField(
                  "Greenwood Heights, NY",
                  Icons.location_on_outlined,
                  isTablet,
                  readOnly: true,
                ),

                const SizedBox(height: 32),

                // --- TRUST & VERIFICATION CARD (Responsive) ---
                Container(
                  padding: EdgeInsets.all(isTablet ? 24 : 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(isTablet ? 14 : 10),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.verified_user_rounded,
                          color: primaryColor,
                          size: isTablet ? 28 : 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Verified Neighbor",
                              style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.w800,
                                fontSize: isTablet ? 18 : 15, // Scaled Font
                                color: textDark,
                              ),
                            ),
                            Text(
                              "Verify your ID to increase community trust.",
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: isTablet ? 14 : 12, // Scaled Font
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.grey,
                        size: isTablet ? 24 : 20,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // --- SAVE BUTTON ---
                SizedBox(
                  width: double.infinity,
                  height: isTablet ? 70 : 60, // Taller button for Tablet
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Save Profile",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: isTablet ? 18 : 16, // Scaled Font
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- HELPER UI WIDGETS ---

  Widget _buildFieldLabel(String label, bool isTablet) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: isTablet ? 16 : 14,
          fontWeight: FontWeight.w700,
          color: textDark,
        ),
      ),
    );
  }

  Widget _buildTextField(
    String hint,
    IconData icon,
    bool isTablet, {
    int maxLines = 1,
    bool readOnly = false,
  }) {
    return TextFormField(
      readOnly: readOnly,
      maxLines: maxLines,
      style: GoogleFonts.plusJakartaSans(
        fontSize: isTablet ? 18 : 16,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(
          icon,
          color: Colors.grey[400],
          size: isTablet ? 26 : 22,
        ),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: isTablet ? 20 : 16,
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, bool isTablet) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            "Logout",
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800),
          ),
          content: Text(
            "Are you sure you want to log out of LocaLink?",
            style: GoogleFonts.plusJakartaSans(fontSize: isTablet ? 16 : 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: GoogleFonts.plusJakartaSans(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                // Remove all previous routes and go to LoginScreen
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login', // Ensure this route is defined in your main.dart
                  (route) => false,
                );

              },
              child: Text(
                "Logout",
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
