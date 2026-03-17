import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localink/electrician/electrician_detail_screen.dart';

class ElectricianListScreen extends StatelessWidget {
  ElectricianListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. THEME & RESPONSIVE DETECTION
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 600;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // 2. DYNAMIC COLOR PALETTE
    const Color primaryBlue = Color(0xFF2563EB);
    final Color textColor = isDarkMode ? Colors.white : const Color(0xFF0F172A);
    final Color secondaryTextColor = isDarkMode ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final Color scaffoldBg = isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final Color cardColor = isDarkMode ? const Color(0xFF1E293B) : Colors.white;
    final Color appBarBg = isDarkMode ? const Color(0xFF1E293B) : Colors.white;
    final Color borderColor = isDarkMode ? Colors.white10 : const Color(0xFFE2E8F0);

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
          "Electricians Nearby",
          style: GoogleFonts.plusJakartaSans(
            color: textColor,
            fontWeight: FontWeight.w800,
            fontSize: isTablet ? 24 : 18,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.tune_rounded, color: primaryBlue, size: isTablet ? 28 : 24),
            onPressed: () {},
          ),
          if (isTablet) const SizedBox(width: 20),
        ],
      ),
      // 3. RESPONSIVE GRID/LIST
      body: isTablet
          ? GridView.builder(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          mainAxisExtent: 230, // Adjusted for padding
        ),
        itemCount: _electricianData.length,
        itemBuilder: (context, index) => _buildCard(context, index, isTablet, isDarkMode, cardColor, textColor, secondaryTextColor, borderColor),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _electricianData.length,
        itemBuilder: (context, index) => _buildCard(context, index, isTablet, isDarkMode, cardColor, textColor, secondaryTextColor, borderColor),
      ),
    );
  }

  // DATA HELPER
  final List<Map<String, dynamic>> _electricianData = [
    {
      "name": "Rajesh Kumar",
      "specialty": "Short Circuit & Wiring Expert",
      "rating": "4.8",
      "reviews": "120",
      "distance": "0.5 km",
      "fee": "₹299",
      "img": "https://i.pravatar.cc/150?u=12",
      "isVerified": true,
    },
    {
      "name": "Amit Sharma",
      "specialty": "Appliance Repair & Installation",
      "rating": "4.6",
      "reviews": "85",
      "distance": "1.2 km",
      "fee": "₹199",
      "img": "https://i.pravatar.cc/150?u=14",
      "isVerified": false,
    },
    {
      "name": "Vikram Singh",
      "specialty": "Full House Wiring Specialist",
      "rating": "4.9",
      "reviews": "210",
      "distance": "2.0 km",
      "fee": "₹499",
      "img": "https://i.pravatar.cc/150?u=19",
      "isVerified": true,
    },
  ];

  Widget _buildCard(BuildContext context, int index, bool isTablet, bool isDarkMode, Color bg, Color text, Color subText, Color border) {
    final item = _electricianData[index];
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ElectricianDetailScreen()),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: isTablet ? 0 : 16),
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: border),
          boxShadow: isDarkMode ? null : [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                item['img'],
                height: isTablet ? 90 : 70,
                width: isTablet ? 90 : 70,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item['name'],
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w800,
                            fontSize: isTablet ? 18 : 16,
                            color: text,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (item['isVerified'])
                        Icon(Icons.verified, color: Colors.blue, size: isTablet ? 18 : 16),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['specialty'],
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: isTablet ? 14 : 12,
                      color: subText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 14),
                      const SizedBox(width: 4),
                      Text(item['rating'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: isTablet ? 15 : 13, color: text)),
                      Text(" (${item['reviews']})", style: TextStyle(color: subText, fontSize: isTablet ? 13 : 12)),
                      const Spacer(),
                      Text(
                        item['fee'],
                        style: TextStyle(
                          color: const Color(0xFF2563EB),
                          fontWeight: FontWeight.w900,
                          fontSize: isTablet ? 18 : 15,
                        ),
                      ),
                    ],
                  ),
                  Divider(height: 20, color: isDarkMode ? Colors.white10 : const Color(0xFFE2E8F0)),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, color: subText.withOpacity(0.7), size: 14),
                      const SizedBox(width: 4),
                      Text(item['distance'], style: TextStyle(color: subText, fontSize: isTablet ? 13 : 12)),
                      const Spacer(),
                      Text(
                        "Available Now",
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.green,
                          fontWeight: FontWeight.w700,
                          fontSize: isTablet ? 13 : 11,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}