import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ElectricianDetailScreen extends StatelessWidget {
  const ElectricianDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. THEME & RESPONSIVE DETECTION
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 600;

    // 2. DYNAMIC COLOR PALETTE
    const Color primaryBlue = Color(0xFF2563EB);
    final Color textColor = isDarkMode ? Colors.white : const Color(0xFF0F172A);
    final Color scaffoldBg = isDarkMode
        ? const Color(0xFF0F172A)
        : Colors.white;
    final Color cardColor = isDarkMode ? const Color(0xFF1E293B) : Colors.white;
    final Color bentoBoxColor = isDarkMode
        ? const Color(0xFF1E293B)
        : const Color(0xFFF8FAFC);
    final Color borderColor = isDarkMode
        ? Colors.white10
        : const Color(0xFFE2E8F0);
    final Color subTextColor = isDarkMode
        ? const Color(0xFF94A3B8)
        : Colors.grey[600]!;

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: Stack(
        children: [
          // 1. MAIN CONTENT
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageHeader(isTablet),

                Center(
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: isTablet ? 700 : double.infinity,
                    ),
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 2. TITLE & PRICE
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                "Expert Electrical Repairs & Wiring",
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: isTablet ? 30 : 24,
                                  fontWeight: FontWeight.w800,
                                  color: textColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            _buildPriceBadge("₹299", "Visit Fee", isTablet),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // 3. PRO INFO ROW
                        _buildProInfoRow(
                          primaryBlue,
                          textColor,
                          subTextColor,
                          isTablet,
                        ),

                        const SizedBox(height: 32),

                        // 4. DESCRIPTION
                        Text(
                          "About the Service",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Professional electrical services for your home. We handle everything from short circuit repairs, ceiling fan installations, to full house wiring. All our electricians are certified and follow safety protocols.",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            color: subTextColor,
                            height: 1.6,
                          ),
                        ),

                        const SizedBox(height: 32),

                        // 5. WHAT'S INCLUDED (BENTO STYLE)
                        Text(
                          "What's Included",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildIncludedGrid(
                          bentoBoxColor,
                          borderColor,
                          textColor,
                          isTablet,
                        ),

                        const SizedBox(height: 140), // Padding for Bottom Bar
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 6. BACK BUTTON
          Positioned(
            top: 50,
            left: 20,
            child: _buildCircularButton(
              Icons.arrow_back_ios_new,
              () => Navigator.pop(context),
              cardColor,
              textColor,
            ),
          ),

          // 7. BOTTOM ACTION BAR
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildBottomActionBar(
              primaryBlue,
              cardColor,
              textColor,
              isDarkMode,
              isTablet,
              screenWidth,
            ),
          ),
        ],
      ),
    );
  }

  // --- UI HELPER WIDGETS ---

  Widget _buildImageHeader(bool isTablet) {
    return Container(
      height: isTablet ? 400 : 300,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            "https://images.unsplash.com/photo-1621905251189-08b45d6a269e?w=800",
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withOpacity(0.7), Colors.transparent],
          ),
        ),
      ),
    );
  }

  Widget _buildProInfoRow(
    Color primary,
    Color text,
    Color subText,
    bool isTablet,
  ) {
    return Row(
      children: [
        CircleAvatar(
          radius: isTablet ? 25 : 20,
          backgroundImage: const NetworkImage("https://i.pravatar.cc/150?u=12"),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Rajesh Kumar",
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    color: text,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.verified, color: Colors.blue, size: 14),
              ],
            ),
            Text(
              "10+ Years Experience",
              style: TextStyle(fontSize: 12, color: subText),
            ),
          ],
        ),
        const Spacer(),
        _buildStat("4.8", Icons.star, Colors.orange),
      ],
    );
  }

  Widget _buildStat(String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceBadge(String price, String label, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          price,
          style: GoogleFonts.plusJakartaSans(
            fontSize: isTablet ? 28 : 22,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF2563EB),
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  Widget _buildIncludedGrid(Color bg, Color border, Color text, bool isTablet) {
    final List<String> items = [
      "Safety Check",
      "Internal Wiring",
      "Component Repair",
      "Post-work Cleanup",
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isTablet ? 2 : 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: isTablet ? 4.5 : 3.5,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: border),
          ),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 16),
              const SizedBox(width: 8),
              Text(
                items[index],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: text,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCircularButton(
    IconData icon,
    VoidCallback onTap,
    Color bg,
    Color iconColor,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
        child: Icon(icon, size: 18, color: iconColor),
      ),
    );
  }

  Widget _buildBottomActionBar(
    Color primary,
    Color bg,
    Color text,
    bool isDarkMode,
    bool isTablet,
    double screenWidth,
  ) {
    return Container(
      // 1. Re-enable padding for safe area and spacing
      padding: EdgeInsets.fromLTRB(24, 16, 24, isTablet ? 32 : 15),
      decoration: BoxDecoration(
        color: bg,
        border: Border(
          top: BorderSide(color: isDarkMode ? Colors.white10 : Colors.black12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        // 2. This centers the content horizontally for tablets
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            // 3. Constrain the width for tablets, otherwise take full width
            constraints: BoxConstraints(
              maxWidth: isTablet
                  ? 700
                  : (screenWidth - 48), // screenWidth minus horizontal padding
            ),
            child: Row(
              children: [
                _buildActionButton(
                  Icons.chat_bubble_outline,
                  "Chat",
                  isDarkMode
                      ? Colors.white.withOpacity(0.05)
                      : Colors.grey[200]!,
                  text,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {},
                    child: Text(
                      "Book Now",
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color bg, Color text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: text),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(color: text, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
