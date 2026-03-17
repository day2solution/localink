import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  final Color primaryBlue = const Color(0xFF2563EB);
  final Color textDark = const Color(0xFF0F172A);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 600;

    // Dynamic column count: 1 for mobile, 2 for small tablets, 3 for large tablets
    int crossAxisCount = screenWidth > 900 ? 3 : (isTablet ? 2 : 1);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: isTablet,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textDark, size: isTablet ? 24 : 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Neighborhood Alerts",
          style: GoogleFonts.plusJakartaSans(
            color: textDark,
            fontWeight: FontWeight.w800,
            fontSize: isTablet ? 24 : 20,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // 1. Map Header (Full Width)
          SliverToBoxAdapter(child: _buildMapHeader(isTablet)),

          // 2. Section Label: Active Now (Full Width)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            sliver: SliverToBoxAdapter(child: _buildSectionLabel("Active Now", isTablet)),
          ),

          // 3. Active Alerts Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                mainAxisExtent: isTablet ? 150 : 130, // Fixed height per card
              ),
              delegate: SliverChildListDelegate([
                _buildAlertCard("Power Outage", "Scheduled maintenance impacting Blocks 4-12.", "High", "Today, 11:00 PM", Icons.power_off_rounded, Colors.red, isTablet),
                _buildAlertCard("Water Main Leak", "Main St closed between 5th and 6th Ave.", "Medium", "Today, 2:45 PM", Icons.water_drop_rounded, Colors.orange, isTablet),
              ]),
            ),
          ),

          // 4. Section Label: Recent Updates (Full Width)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
            sliver: SliverToBoxAdapter(child: _buildSectionLabel("Recent Updates", isTablet)),
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
                _buildAlertCard("Community Event", "Greenwood Heights Block Party starts soon!", "Low", "Yesterday", Icons.celebration_rounded, Colors.blue, isTablet),
                _buildAlertCard("Lost Pet Found", "Golden Retriever found near the dog park.", "Low", "2 days ago", Icons.pets_rounded, Colors.green, isTablet),
              ]),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildMapHeader(bool isTablet) {
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
          gradient: LinearGradient(colors: [Colors.black.withOpacity(0.6), Colors.transparent], begin: Alignment.bottomCenter, end: Alignment.topCenter),
        ),
        padding: const EdgeInsets.all(16),
        alignment: Alignment.bottomLeft,
        child: Text(
          "4 Active Alerts in your radius",
          style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.bold, fontSize: isTablet ? 18 : 14),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text, bool isTablet) {
    return Text(
      text,
      style: GoogleFonts.plusJakartaSans(
        fontSize: isTablet ? 20 : 14,
        fontWeight: FontWeight.w700,
        color: Colors.grey[600],
        letterSpacing: 1,
      ),
    );
  }

  Widget _buildAlertCard(String title, String desc, String urgency, String time, IconData icon, Color color, bool isTablet) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.1), width: 1.5),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
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
                  style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: isTablet ? 16 : 14, color: textDark),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(fontSize: isTablet ? 14 : 12, color: Colors.grey[600]),
                ),
                const Spacer(),
                Text(time, style: TextStyle(fontSize: isTablet ? 12 : 10, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}