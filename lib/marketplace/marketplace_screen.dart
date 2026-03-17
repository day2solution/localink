import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  final Color primaryBlue = const Color(0xFF2563EB);
  String selectedCategory = "All";

  @override
  Widget build(BuildContext context) {
    // 1. RESPONSIVE & THEME DETECTION
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 600;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // 2. DYNAMIC COLOR PALETTE
    final Color textColor = isDarkMode ? Colors.white : const Color(0xFF0F172A);
    final Color secondaryTextColor = isDarkMode ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final Color scaffoldBg = isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final Color cardColor = isDarkMode ? const Color(0xFF1E293B) : Colors.white;
    final Color inputFill = isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9);
    final Color borderColor = isDarkMode ? Colors.white10 : const Color(0xFFE2E8F0);

    // Grid Column Logic
    int crossAxisCount = screenWidth > 900 ? 4 : (isTablet ? 3 : 2);

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 0,
        centerTitle: isTablet,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textColor, size: isTablet ? 24 : 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Marketplace Nearby",
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
          if (isTablet) const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          // 3. SEARCH & QUICK CATEGORIES
          Container(
            color: cardColor,
            padding: EdgeInsets.only(bottom: isTablet ? 25 : 15),
            child: Column(
              children: [
                _buildSearchBar(isTablet, isDarkMode, inputFill, textColor),
                const SizedBox(height: 15),
                _buildHorizontalCategories(isTablet, isDarkMode, cardColor, textColor, borderColor),
              ],
            ),
          ),

          // 4. PRODUCT GRID
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(isTablet ? 30 : 20),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: isTablet ? 20 : 15,
                crossAxisSpacing: isTablet ? 20 : 15,
                mainAxisExtent: isTablet ? 320 : 260,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                return _buildMarketplaceCard(
                  context,
                  index % 2 == 0 ? "MacBook Pro 2021" : "Ergonomic Chair",
                  index % 2 == 0 ? "₹75,000" : "₹4,500",
                  "0.5 km",
                  index % 2 == 0
                      ? "https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=400"
                      : "https://images.unsplash.com/photo-1592078615290-033ee584e267?w=400",
                  isTablet,
                  isDarkMode,
                  cardColor,
                  textColor,
                  secondaryTextColor,
                  borderColor,
                  isVerified: index % 3 == 0,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildSearchBar(bool isTablet, bool isDarkMode, Color fill, Color text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: isTablet ? 60 : 50,
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(12),
          border: isDarkMode ? Border.all(color: Colors.white10) : null,
        ),
        child: TextField(
          style: TextStyle(fontSize: isTablet ? 16 : 14, color: text),
          decoration: InputDecoration(
            hintText: "Search items nearby...",
            hintStyle: TextStyle(fontSize: isTablet ? 16 : 14, color: isDarkMode ? Colors.white38 : Colors.grey),
            prefixIcon: Icon(Icons.search, color: isDarkMode ? Colors.white38 : Colors.grey, size: isTablet ? 26 : 22),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalCategories(bool isTablet, bool isDarkMode, Color cardBg, Color text, Color border) {
    final categories = ["All", "Electronics", "Furniture", "Hobbies", "Free Items"];
    return SizedBox(
      height: isTablet ? 45 : 35,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 20),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          bool isSelected = selectedCategory == categories[index];
          return GestureDetector(
            onTap: () => setState(() => selectedCategory = categories[index]),
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: EdgeInsets.symmetric(horizontal: isTablet ? 24 : 16),
              decoration: BoxDecoration(
                color: isSelected ? primaryBlue : (isDarkMode ? Colors.transparent : cardBg),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: isSelected ? primaryBlue : border),
              ),
              child: Center(
                child: Text(
                  categories[index],
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: isTablet ? 15 : 12,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : (isDarkMode ? Colors.white70 : const Color(0xFF64748B)),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMarketplaceCard(
      BuildContext context,
      String title,
      String price,
      String distance,
      String img,
      bool isTablet,
      bool isDarkMode,
      Color bg,
      Color text,
      Color subText,
      Color border,
      {bool isVerified = false}
      ) {
    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: isDarkMode ? Border.all(color: border) : null,
        boxShadow: isDarkMode ? null : [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(img, width: double.infinity, height: double.infinity, fit: BoxFit.cover),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: CircleAvatar(
                    radius: isTablet ? 18 : 14,
                    backgroundColor: isDarkMode ? Colors.black45 : Colors.white.withOpacity(0.9),
                    child: Icon(Icons.favorite_border, size: isTablet ? 20 : 16, color: isDarkMode ? Colors.white70 : Colors.grey),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(isTablet ? 16 : 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w700,
                          fontSize: isTablet ? 16 : 13,
                          color: text,
                        ),
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isVerified) Icon(Icons.verified, color: Colors.blue, size: isTablet ? 18 : 14),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        price,
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: isTablet ? 18 : 14,
                            color: const Color(0xFF2563EB)
                        )
                    ),
                    Text(
                        distance,
                        style: TextStyle(
                            fontSize: isTablet ? 13 : 10,
                            color: subText
                        )
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}