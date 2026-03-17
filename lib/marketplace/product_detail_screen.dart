import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localink/marketplace/seller_profile_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  final String title;
  final String price;
  final String distance;
  final String imageUrl;

  const ProductDetailScreen({
    super.key,
    required this.title,
    required this.price,
    required this.distance,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    // 1. RESPONSIVE & THEME DETECTION
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 600;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final Color textColor = isDarkMode ? Colors.white : const Color(0xFF0F172A);
    final Color cardColor = isDarkMode ? const Color(0xFF1E293B) : Colors.white;
    final Color scaffoldBg = isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final Color borderColor = isDarkMode ? Colors.white10 : const Color(0xFFE2E8F0);

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: isTablet
          ? _buildTabletLayout(context, isDarkMode, textColor, cardColor, borderColor)
          : _buildMobileLayout(context, isDarkMode, textColor, cardColor, borderColor),

      // Fixed bottom bar for both views
      bottomSheet: _buildBottomAction(context, isDarkMode, cardColor, isTablet, screenWidth),
    );
  }

  // --- MOBILE LAYOUT (Sliver Scroll) ---
  Widget _buildMobileLayout(BuildContext context, bool isDarkMode, Color textColor, Color cardColor, Color borderColor) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 400,
          pinned: true,
          leading: _buildBackButton(context),
          flexibleSpace: FlexibleSpaceBar(
            background: Image.network(imageUrl, fit: BoxFit.cover),
          ),
        ),
        SliverToBoxAdapter(
          child: _buildProductInfo(context, isDarkMode, textColor, cardColor, borderColor, false),
        ),
      ],
    );
  }

  // --- TABLET LAYOUT (Split View) ---
  Widget _buildTabletLayout(BuildContext context, bool isDarkMode, Color textColor, Color cardColor, Color borderColor) {
    return Stack(
      children: [
        Row(
          children: [
            // Left Side: Large Image
            Expanded(
              flex: 5,
              child: Image.network(imageUrl, fit: BoxFit.cover, height: double.infinity),
            ),
            // Right Side: Content Area
            Expanded(
              flex: 4,
              child: Container(
                color: cardColor,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
                  child: _buildProductInfo(context, isDarkMode, textColor, cardColor, borderColor, true),
                ),
              ),
            ),
          ],
        ),
        Positioned(top: 40, left: 20, child: _buildBackButton(context)),
      ],
    );
  }

  // --- REUSABLE COMPONENTS ---

  Widget _buildBackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircleAvatar(
        backgroundColor: Colors.black26,
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  Widget _buildProductInfo(BuildContext context, bool isDarkMode, Color textColor, Color cardColor, Color borderColor, bool isTablet) {
    return Padding(
      padding: EdgeInsets.all(isTablet ? 0 : 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: isTablet ? 32 : 24,
                    fontWeight: FontWeight.w800,
                    color: textColor,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                price,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: isTablet ? 28 : 22,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF2563EB),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.location_on, size: 18, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                "$distance away",
                style: GoogleFonts.plusJakartaSans(color: Colors.grey, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Seller Section Added Here
          // _buildSellerSection(context, isDarkMode, textColor, cardColor, borderColor),
          _buildSellerCard(context, isTablet, isDarkMode, textColor, cardColor, borderColor),

          const SizedBox(height: 32),
          Text(
            "Description",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "This is a high-quality item available in your local neighborhood. Well-maintained and ready for a new home. Sellers in your area are verified for your safety.",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              height: 1.6,
              color: isDarkMode ? Colors.white70 : Colors.black87,
            ),
          ),
          const SizedBox(height: 120), // Bottom padding for button
        ],
      ),
    );
  }

  Widget _buildBottomAction(BuildContext context, bool isDarkMode, Color cardColor, bool isTablet, double screenWidth) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 40 : 20,
          vertical: 20
      ),
      width: isTablet ? screenWidth * 0.444 : double.infinity, // Match tablet side panel width
      decoration: BoxDecoration(
        color: cardColor,
        border: Border(top: BorderSide(color: isDarkMode ? Colors.white10 : Colors.black12)),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2563EB),
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SellerProfileScreen(),
            ),
          );
        },
        child: Text(
          "Chat with Seller",
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildSellerSection(BuildContext context, bool isDarkMode, Color textColor, Color cardColor, Color borderColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Seller Information",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: textColor,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            border: Border(top: BorderSide(color: isDarkMode ? Colors.white10 : Colors.black12)),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=seller'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Aditya Varma",
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.verified, color: Colors.blue, size: 16),

                      ],
                    ),
                    Text(
                      "4.9 ★ (120+ ratings)",
                      style: TextStyle(
                        color: isDarkMode ? Colors.white60 : Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SellerProfileScreen(),
                    ),
                  );
                },
                child: Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey[400], size: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }
  Widget _buildSellerCard(BuildContext context, bool isTablet, bool isDarkMode, Color textColor, Color cardColor, Color borderColor) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SellerProfileScreen())
      ),
      child: Container(
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        decoration: BoxDecoration(
          color: cardColor, // Adapts to theme
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor), // Adapts to theme
          boxShadow: isDarkMode ? null : [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
                radius: isTablet ? 30 : 25,
                backgroundImage: const NetworkImage("https://i.pravatar.cc/150?u=seller")
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                          "Aditya Varma",
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.bold,
                            fontSize: isTablet ? 17 : 15,
                            color: textColor, // Adapts to theme
                          )
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.verified, color: Colors.blue, size: isTablet ? 18 : 14),
                    ],
                  ),
                  Text(
                      "Member since 2022 • 4.9 ★",
                      style: TextStyle(
                          color: isDarkMode ? Colors.white60 : Colors.grey[500], // Softer contrast in dark mode
                          fontSize: isTablet ? 13 : 11
                      )
                  ),
                ],
              ),
            ),
            Icon(
                Icons.arrow_forward_ios_rounded,
                color: isDarkMode ? Colors.white38 : Colors.grey[400],
                size: 16
            ),
          ],
        ),
      ),
    );
  }
}