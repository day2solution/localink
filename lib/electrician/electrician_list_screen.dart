import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localink/electrician/electrician_detail_screen.dart';

class ElectricianListScreen extends StatelessWidget {
  ElectricianListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Detect Screen Type
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 600;

    const Color primaryBlue = Color(0xFF2563EB);
    const Color textDark = Color(0xFF0F172A);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: isTablet, // Center title on tablets
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textDark, size: isTablet ? 24 : 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Electricians Nearby",
          style: GoogleFonts.plusJakartaSans(
            color: textDark,
            fontWeight: FontWeight.w800,
            fontSize: isTablet ? 24 : 18, // Scaled Font
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
      // 2. Responsive Body: Grid for Tablet, List for Mobile
      body: isTablet
          ? GridView.builder(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 Columns on Tablet
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          mainAxisExtent: 220, // Prevents cards from stretching vertically
        ),
        itemCount: _electricianData.length,
        itemBuilder: (context, index) => _buildCard(context, index, isTablet),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _electricianData.length,
        itemBuilder: (context, index) => _buildCard(context, index, isTablet),
      ),
    );
  }

  // Data Helper
  final List<Map<String, dynamic>> _electricianData = [
    {
      "name": "Rajesh Kumar",
      "specialty": "Short Circuit & Wiring Expert",
      "rating": "4.8",
      "reviews": "120 Reviews",
      "distance": "0.5 km away",
      "fee": "₹299",
      "img": "https://i.pravatar.cc/150?u=12",
      "isVerified": true,
    },
    {
      "name": "Amit Sharma",
      "specialty": "Appliance Repair & Installation",
      "rating": "4.6",
      "reviews": "85 Reviews",
      "distance": "1.2 km away",
      "fee": "₹199",
      "img": "https://i.pravatar.cc/150?u=14",
      "isVerified": false,
    },
    {
      "name": "Vikram Singh",
      "specialty": "Full House Wiring Specialist",
      "rating": "4.9",
      "reviews": "210 Reviews",
      "distance": "2.0 km away",
      "fee": "₹499",
      "img": "https://i.pravatar.cc/150?u=19",
      "isVerified": true,
    },
  ];

  Widget _buildCard(BuildContext context, int index, bool isTablet) {
    final item = _electricianData[index];
    return _buildElectricianCard(
      context,
      item['name'],
      item['specialty'],
      item['rating'],
      item['reviews'],
      item['distance'],
      item['fee'],
      item['img'],
      isTablet,
      isVerified: item['isVerified'],
    );
  }

  Widget _buildElectricianCard(
      BuildContext context,
      String name,
      String specialty,
      String rating,
      String reviews,
      String distance,
      String fee,
      String img,
      bool isTablet, // Pass isTablet here
          {bool isVerified = false}) {
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
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                  img,
                  height: isTablet ? 90 : 70,
                  width: isTablet ? 90 : 70,
                  fit: BoxFit.cover
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
                          name,
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w800,
                            fontSize: isTablet ? 18 : 16,
                            color: const Color(0xFF0F172A),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isVerified)
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Icon(Icons.verified, color: Colors.blue, size: isTablet ? 18 : 16),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    specialty,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: isTablet ? 14 : 12,
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
                      Text(rating, style: TextStyle(fontWeight: FontWeight.bold, fontSize: isTablet ? 15 : 13)),
                      Text(" ($reviews)", style: TextStyle(color: Colors.grey, fontSize: isTablet ? 13 : 12)),
                      const Spacer(),
                      Text(
                        fee,
                        style: TextStyle(
                          color: const Color(0xFF2563EB),
                          fontWeight: FontWeight.w900,
                          fontSize: isTablet ? 18 : 15,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, color: Colors.grey, size: 14),
                      const SizedBox(width: 4),
                      Text(distance, style: TextStyle(color: Colors.grey, fontSize: isTablet ? 13 : 12)),
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