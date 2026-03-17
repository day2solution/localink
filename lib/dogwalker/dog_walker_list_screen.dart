import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localink/dogwalker/dog_walker_detail_screen.dart'; // Ensure this import exists

class DogWalkerListScreen extends StatelessWidget {
  DogWalkerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. RESPONSIVE & THEME DETECTION
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
          "Dog Walkers Nearby",
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
      // 3. ADAPTIVE LAYOUT
      body: isTablet
          ? GridView.builder(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          mainAxisExtent: 220,
        ),
        itemCount: _dogWalkerData.length,
        itemBuilder: (context, index) => _buildWalkerCard(
            context, index, isTablet, isDarkMode, cardColor, textColor, secondaryTextColor, borderColor),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _dogWalkerData.length,
        itemBuilder: (context, index) => _buildWalkerCard(
            context, index, isTablet, isDarkMode, cardColor, textColor, secondaryTextColor, borderColor),
      ),
    );
  }

  // --- MOCK DATA ---
  final List<Map<String, dynamic>> _dogWalkerData = [
    {
      "name": "Sarah Jenkins",
      "bio": "Certified trainer • 5 years experience",
      "rating": "4.9",
      "reviews": "156",
      "distance": "0.3 km",
      "price": "₹150/hr",
      "img": "https://i.pravatar.cc/150?u=woman1",
      "isVerified": true,
    },
    {
      "name": "Michael Ross",
      "bio": "Large breeds specialist",
      "rating": "4.7",
      "reviews": "92",
      "distance": "0.9 km",
      "price": "₹120/hr",
      "img": "https://i.pravatar.cc/150?u=man2",
      "isVerified": true,
    },
    {
      "name": "Elena Rodriguez",
      "bio": "Puppy socializer • Group walks",
      "rating": "4.8",
      "reviews": "45",
      "distance": "1.5 km",
      "price": "₹200/hr",
      "img": "https://i.pravatar.cc/150?u=woman3",
      "isVerified": false,
    },
  ];

  Widget _buildWalkerCard(BuildContext context, int index, bool isTablet, bool isDarkMode, Color bg, Color text,
      Color subText, Color border) {
    final walker = _dogWalkerData[index];
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DogWalkerDetailScreen()),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: isTablet ? 0 : 16),
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: border),
          boxShadow: isDarkMode
              ? null
              : [
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
            // Profile Picture
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                walker['img'],
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
                          walker['name'],
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w800,
                            fontSize: isTablet ? 18 : 16,
                            color: text,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (walker['isVerified'])
                        Icon(Icons.verified, color: Colors.blue, size: isTablet ? 18 : 16),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    walker['bio'],
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
                      Text(walker['rating'],
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: isTablet ? 15 : 13, color: text)),
                      Text(" (${walker['reviews']})", style: TextStyle(color: subText, fontSize: isTablet ? 13 : 12)),
                      const Spacer(),
                      Text(
                        walker['price'],
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
                      Icon(Icons.pets, color: subText.withOpacity(0.5), size: 14),
                      const SizedBox(width: 4),
                      Text(walker['distance'], style: TextStyle(color: subText, fontSize: isTablet ? 13 : 12)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "ACTIVE",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: isTablet ? 12 : 10,
                          ),
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