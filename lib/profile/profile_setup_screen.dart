import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final Color primaryColor = const Color(0xFF2563EB);

  @override
  Widget build(BuildContext context) {
    // 1. Detect Screen Type & Theme
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 600;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // 2. Dynamic Theme Colors
    final Color scaffoldBg = isDarkMode ? const Color(0xFF0F172A) : Colors.white;
    final Color textColor = isDarkMode ? Colors.white : const Color(0xFF0F172A);
    final Color inputFill = isDarkMode ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC);
    final Color borderColor = isDarkMode ? Colors.white10 : const Color(0xFFE2E8F0);
    final Color subCardColor = isDarkMode ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: scaffoldBg,
        elevation: 0,
        centerTitle: isTablet,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: textColor,
            size: isTablet ? 24 : 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Set Up Profile",
          style: GoogleFonts.plusJakartaSans(
            color: textColor,
            fontWeight: FontWeight.w800,
            fontSize: isTablet ? 24 : 18,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _showLogoutDialog(context, isTablet, isDarkMode, scaffoldBg, textColor),
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
        child: Container(
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
                          radius: isTablet ? 75 : 60,
                          backgroundColor: inputFill,
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
                            border: Border.all(color: scaffoldBg, width: 3),
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
                _buildFieldLabel("Full Name", isTablet, textColor),
                _buildTextField("John Doe", Icons.person_outline, isTablet, isDarkMode, inputFill, textColor, borderColor),

                const SizedBox(height: 20),

                _buildFieldLabel("Bio / About You", isTablet, textColor),
                _buildTextField(
                  "Passionate about local gardening and dog walking!",
                  Icons.edit_note_rounded,
                  isTablet,
                  isDarkMode,
                  inputFill,
                  textColor,
                  borderColor,
                  maxLines: 3,
                ),

                const SizedBox(height: 20),

                _buildFieldLabel("Home Neighborhood", isTablet, textColor),
                _buildTextField(
                  "Greenwood Heights, NY",
                  Icons.location_on_outlined,
                  isTablet,
                  isDarkMode,
                  inputFill,
                  textColor,
                  borderColor,
                  readOnly: true,
                ),

                const SizedBox(height: 32),

                // --- TRUST & VERIFICATION CARD ---
                Container(
                  padding: EdgeInsets.all(isTablet ? 24 : 20),
                  decoration: BoxDecoration(
                    color: subCardColor,
                    borderRadius: BorderRadius.circular(20),
                    border: isDarkMode ? Border.all(color: borderColor) : null,
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
                                fontSize: isTablet ? 18 : 15,
                                color: textColor,
                              ),
                            ),
                            Text(
                              "Verify your ID to increase community trust.",
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: isTablet ? 14 : 12,
                                color: isDarkMode ? Colors.white60 : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: isDarkMode ? Colors.white38 : Colors.grey,
                        size: isTablet ? 24 : 20,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // --- SAVE BUTTON ---
                SizedBox(
                  width: double.infinity,
                  height: isTablet ? 70 : 60,
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
                        fontSize: isTablet ? 18 : 16,
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

  Widget _buildFieldLabel(String label, bool isTablet, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: isTablet ? 16 : 14,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildTextField(
      String hint,
      IconData icon,
      bool isTablet,
      bool isDarkMode,
      Color fill,
      Color textColor,
      Color border, {
        int maxLines = 1,
        bool readOnly = false,
      }) {
    return TextFormField(
      readOnly: readOnly,
      maxLines: maxLines,
      style: GoogleFonts.plusJakartaSans(
        fontSize: isTablet ? 18 : 16,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: isDarkMode ? Colors.white38 : Colors.grey[400]),
        prefixIcon: Icon(
          icon,
          color: isDarkMode ? Colors.white38 : Colors.grey[400],
          size: isTablet ? 26 : 22,
        ),
        filled: true,
        fillColor: fill,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: border),
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

  void _showLogoutDialog(BuildContext context, bool isTablet, bool isDarkMode, Color bg, Color textColor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            "Logout",
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, color: textColor),
          ),
          content: Text(
            "Are you sure you want to log out of LocaLink?",
            style: GoogleFonts.plusJakartaSans(fontSize: isTablet ? 16 : 14, color: isDarkMode ? Colors.white70 : Colors.black87),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: GoogleFonts.plusJakartaSans(color: isDarkMode ? Colors.white38 : Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
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