import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  final Color primaryBlue = const Color(0xFF2563EB);

  @override
  Widget build(BuildContext context) {
    // 1. RESPONSIVE & THEME DETECTION
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 600;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // 2. ADAPTIVE COLOR PALETTE
    final Color textColor = isDarkMode ? Colors.white : const Color(0xFF0F172A);
    final Color secondaryTextColor = isDarkMode ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final Color scaffoldBg = isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final Color cardColor = isDarkMode ? const Color(0xFF1E293B) : Colors.white;
    final Color appBarBg = isDarkMode ? const Color(0xFF1E293B) : Colors.white;

    // Dynamic column count: 1 for mobile, 2 for small tablets, 3 for large tablets
    int crossAxisCount = screenWidth > 900 ? 3 : (isTablet ? 2 : 1);

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: appBarBg,
        elevation: 0,
        centerTitle: isTablet,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textColor, size: isTablet ? 24 : 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Neighborhood Alerts",
          style: GoogleFonts.plusJakartaSans(
            color: textColor,
            fontWeight: FontWeight.w800,
            fontSize: isTablet ? 24 : 20,
          ),
        ),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 1. Map Header (Full Width)
          SliverToBoxAdapter(child: _buildMapHeader(isTablet, isDarkMode)),

          // 2. Section Label: Active Now
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            sliver: SliverToBoxAdapter(child: _buildSectionLabel("Active Now", isTablet, secondaryTextColor)),
          ),

          // 3. Active Alerts Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                mainAxisExtent: isTablet ? 150 : 130,
              ),
              delegate: SliverChildListDelegate([
                _buildAlertCard("Power Outage", "Scheduled maintenance impacting Blocks 4-12.", "High", "Today, 11:00 PM", Icons.power_off_rounded, Colors.red, isTablet, isDarkMode, cardColor, textColor, secondaryTextColor),
                _buildAlertCard("Water Main Leak", "Main St closed between 5th and 6th Ave.", "Medium", "Today, 2:45 PM", Icons.water_drop_rounded, Colors.orange, isTablet, isDarkMode, cardColor, textColor, secondaryTextColor),
              ]),
            ),
          ),

          // 4. Section Label: Recent Updates
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
            sliver: SliverToBoxAdapter(child: _buildSectionLabel("Recent Updates", isTablet, secondaryTextColor)),
          ),

          // 5. Recent Alerts Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                mainAxisExtent: isTablet ? 150 : 130,
              ),
              delegate: SliverChildListDelegate([
                _buildAlertCard("Community Event", "Greenwood Heights Block Party starts soon!", "Low", "Yesterday", Icons.celebration_rounded, Colors.blue, isTablet, isDarkMode, cardColor, textColor, secondaryTextColor),
                _buildAlertCard("Lost Pet Found", "Golden Retriever found near the dog park.", "Low", "2 days ago", Icons.pets_rounded, Colors.green, isTablet, isDarkMode, cardColor, textColor, secondaryTextColor),
              ]),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildMapHeader(bool isTablet, bool isDarkMode) {
    return Container(
      height: isTablet ? 200 : 120,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: NetworkImage("https://images.unsplash.com/photo-1524661135-423995f22d0b?w=800"),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(isDarkMode ? 0.8 : 0.6),
                Colors.transparent
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter
          ),
        ),
        padding: const EdgeInsets.all(16),
        alignment: Alignment.bottomLeft,
        child: Text(
          "4 Active Alerts in your radius",
          style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: isTablet ? 18 : 14
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text, bool isTablet, Color color) {
    return Text(
      text,
      style: GoogleFonts.plusJakartaSans(
        fontSize: isTablet ? 20 : 14,
        fontWeight: FontWeight.w700,
        color: color,
        letterSpacing: 1,
      ),
    );
  }

  Widget _buildAlertCard(String title, String desc, String urgency, String time, IconData icon, Color color, bool isTablet, bool isDarkMode, Color bg, Color text, Color subText) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: isDarkMode ? color.withOpacity(0.3) : color.withOpacity(0.1),
            width: 1.5
        ),
        boxShadow: isDarkMode
            ? null
            : [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: isTablet ? 28 : 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w800,
                      fontSize: isTablet ? 16 : 14,
                      color: text
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: isTablet ? 14 : 12,
                      color: subText
                  ),
                ),
                const Spacer(),
                Text(
                    time,
                    style: TextStyle(
                        fontSize: isTablet ? 12 : 10,
                        color: subText.withOpacity(0.7)
                    )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}