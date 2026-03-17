import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  final Color primaryBlue = const Color(0xFF2563EB);
  final Color textDark = const Color(0xFF0F172A);
  String selectedCategory = "All";

  @override
  Widget build(BuildContext context) {
    // 1. Detect Screen Type
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 600;

    // 2 columns for mobile, 3 for small tablets, 4 for large tablets
    int crossAxisCount = screenWidth > 900 ? 4 : (isTablet ? 3 : 2);

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
          "Marketplace Nearby",
          style: GoogleFonts.plusJakartaSans(
            color: textDark,
            fontWeight: FontWeight.w800,
            fontSize: isTablet ? 24 : 18, // Scaled Font
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.tune_rounded, color: primaryBlue, size: isTablet ? 28 : 24),
            onPressed: () {}, // Filter logic
          ),
          if (isTablet) const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          // 2. SEARCH & QUICK CATEGORIES (White Header)
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(bottom: isTablet ? 25 : 15),
            child: Column(
              children: [
                _buildSearchBar(isTablet),
                const SizedBox(height: 15),
                _buildHorizontalCategories(isTablet),
              ],
            ),
          ),

          // 3. PRODUCT GRID (Responsive Grid)
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(isTablet ? 30 : 20),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: isTablet ? 20 : 15,
                crossAxisSpacing: isTablet ? 20 : 15,
                mainAxisExtent: isTablet ? 320 : 260, // Fixed height prevents stretching
              ),
              itemCount: 12, // Example count
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

  Widget _buildSearchBar(bool isTablet) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: isTablet ? 60 : 50, // Taller for tablets
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          style: TextStyle(fontSize: isTablet ? 16 : 14),
          decoration: InputDecoration(
            hintText: "Search items nearby...",
            hintStyle: TextStyle(fontSize: isTablet ? 16 : 14),
            prefixIcon: Icon(Icons.search, color: Colors.grey, size: isTablet ? 26 : 22),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalCategories(bool isTablet) {
    final categories = ["All", "Electronics", "Furniture", "Hobbies", "Free Items"];
    return SizedBox(
      height: isTablet ? 45 : 35, // Taller menu for tablets
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
                color: isSelected ? primaryBlue : Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: isSelected ? primaryBlue : const Color(0xFFE2E8F0)),
              ),
              child: Center(
                child: Text(
                  categories[index],
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: isTablet ? 15 : 12, // Scaled Font
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : const Color(0xFF64748B),
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
      {bool isVerified = false}
      ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
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
                    backgroundColor: Colors.white.withOpacity(0.9),
                    child: Icon(Icons.favorite_border, size: isTablet ? 20 : 16, color: Colors.grey),
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
                          fontSize: isTablet ? 16 : 13, // Scaled Font
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
                            fontSize: isTablet ? 18 : 14, // Scaled Font
                            color: const Color(0xFF2563EB)
                        )
                    ),
                    Text(
                        distance,
                        style: TextStyle(
                            fontSize: isTablet ? 13 : 10,
                            color: Colors.grey
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