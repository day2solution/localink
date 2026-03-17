import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DogWalkerListScreen extends StatelessWidget {
  DogWalkerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Responsive Detection
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 600;

    const Color primaryBlue = Color(0xFF2563EB);
    const Color textDark = Color(0xFF0F172A);

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
          "Dog Walkers Nearby",
          style: GoogleFonts.plusJakartaSans(
            color: textDark,
            fontWeight: FontWeight.w800,
            fontSize: isTablet ? 24 : 18, // Scaled for tablet
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
      // 2. Adaptive Layout
      body: isTablet
          ? GridView.builder(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 columns for tablet
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          mainAxisExtent: 220, // Prevents vertical stretching
        ),
        itemCount: _dogWalkerData.length,
        itemBuilder: (context, index) => _buildWalkerCard(context, index, isTablet),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _dogWalkerData.length,
        itemBuilder: (context, index) => _buildWalkerCard(context, index, isTablet),
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

  Widget _buildWalkerCard(BuildContext context, int index, bool isTablet) {
    final walker = _dogWalkerData[index];
    return Container(
      margin: EdgeInsets.only(bottom: isTablet ? 0 : 16),
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
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
                          fontSize: isTablet ? 18 : 16, // Scaled Font
                          color: const Color(0xFF0F172A),
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
                    fontSize: isTablet ? 14 : 12, // Scaled Font
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 14),
                    const SizedBox(width: 4),
                    Text(walker['rating'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: isTablet ? 15 : 13)),
                    Text(" (${walker['reviews']})", style: TextStyle(color: Colors.grey, fontSize: isTablet ? 13 : 12)),
                    const Spacer(),
                    Text(
                      walker['price'],
                      style: TextStyle(
                        color: const Color(0xFF2563EB),
                        fontWeight: FontWeight.w900,
                        fontSize: isTablet ? 18 : 15, // Scaled Font
                      ),
                    ),
                  ],
                ),
                const Divider(height: 20),
                Row(
                  children: [
                    Icon(Icons.pets, color: Colors.grey[400], size: 14),
                    const SizedBox(width: 4),
                    Text(walker['distance'], style: TextStyle(color: Colors.grey, fontSize: isTablet ? 13 : 12)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
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
    );
  }
}