import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SellerProfileScreen extends StatelessWidget {
  const SellerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. THEME & RESPONSIVE DETECTION
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 600;

    // 2. DYNAMIC COLOR PALETTE
    const Color primaryBlue = Color(0xFF2563EB);
    final Color textColor = isDarkMode ? Colors.white : const Color(0xFF0F172A);
    final Color scaffoldBg = isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final Color cardColor = isDarkMode ? const Color(0xFF1E293B) : Colors.white;
    final Color borderColor = isDarkMode ? Colors.white10 : const Color(0xFFE2E8F0);
    final Color subTextColor = isDarkMode ? const Color(0xFF94A3B8) : Colors.grey[600]!;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 0,
        centerTitle: isTablet,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share_outlined, color: textColor),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert_rounded, color: textColor),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. SELLER HEADER CARD (Adaptive)
            Container(
              color: cardColor,
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: isTablet ? 70 : 50,
                    backgroundImage: const NetworkImage('https://i.pravatar.cc/150?u=seller'),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Aditya Varma",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: isTablet ? 28 : 22,
                          fontWeight: FontWeight.w800,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.verified, color: Colors.blue, size: 20),
                    ],
                  ),
                  Text(
                    "Greenwood Heights • Member since 2022",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: isTablet ? 15 : 13,
                      color: subTextColor,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Trust Stats Row
                  Container(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatColumn("4.9", "Rating", Icons.star_rounded, Colors.orange, textColor),
                        _buildStatDivider(isDarkMode),
                        _buildStatColumn("12", "Sold", Icons.shopping_bag_outlined, primaryBlue, textColor),
                        _buildStatDivider(isDarkMode),
                        _buildStatColumn("98%", "Response", Icons.bolt_rounded, Colors.green, textColor),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 2. ACTIVE LISTINGS SECTION
            Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: isTablet ? 800 : double.infinity),
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Active Listings",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: isTablet ? 22 : 18,
                            fontWeight: FontWeight.w800,
                            color: textColor,
                          ),
                        ),
                        Text(
                          "4 items",
                          style: TextStyle(color: subTextColor, fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Grid for Products
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: screenWidth > 900 ? 3 : 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: isTablet ? 0.85 : 0.8,
                      ),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return _buildSellerProductCard(cardColor, textColor, borderColor, isDarkMode);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomContactBar(primaryBlue, cardColor, isDarkMode, isTablet),
    );
  }

  // --- UI HELPER WIDGETS ---

  Widget _buildStatColumn(String val, String label, IconData icon, Color color, Color textColor) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 4),
            Text(val, style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w800, color: textColor)),
          ],
        ),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildStatDivider(bool isDarkMode) {
    return Container(
        height: 30,
        width: 1,
        color: isDarkMode ? Colors.white10 : Colors.grey[200]
    );
  }

  Widget _buildSellerProductCard(Color bg, Color text, Color border, bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
        boxShadow: isDarkMode ? null : [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                "https://images.unsplash.com/photo-1592078615290-033ee584e267?w=300",
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Ergonomic Chair",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: text)
                ),
                Text("₹4,500",
                    style: TextStyle(fontWeight: FontWeight.w900, color: Colors.blue[600])
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBottomContactBar(Color primary, Color bg, bool isDarkMode, bool isTablet) {
    return Container(
      padding: EdgeInsets.fromLTRB(24, 16, 24, isTablet ? 32 : 40),
      decoration: BoxDecoration(
        color: bg,
        border: Border(top: BorderSide(color: isDarkMode ? Colors.white10 : Colors.black12)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.05),
              blurRadius: 20,
              offset: const Offset(0, -5)
          )
        ],
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 0,
          ),
          onPressed: () {},
          child: const Text("Message Aditya",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)
          ),
        ),
      ),
    );
  }
}