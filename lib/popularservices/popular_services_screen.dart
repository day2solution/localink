import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PopularServicesScreen extends StatelessWidget {
  const PopularServicesScreen({super.key});

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
    final Color inputFill = isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9);

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
          "All Services",
          style: GoogleFonts.plusJakartaSans(
            color: textColor,
            fontWeight: FontWeight.w800,
            fontSize: isTablet ? 22 : 18,
          ),
        ),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: isTablet ? 800 : double.infinity),
          child: CustomScrollView(
            slivers: [
              // 1. SEARCH & CATEGORIES
              SliverToBoxAdapter(
                child: Container(
                  color: cardColor,
                  padding: EdgeInsets.all(isTablet ? 30 : 20),
                  child: Column(
                    children: [
                      _buildSearchBar(isTablet, isDarkMode, inputFill, textColor),
                      const SizedBox(height: 25),
                      _buildCategoryGrid(isTablet, isDarkMode, textColor),
                    ],
                  ),
                ),
              ),

              // 2. FEATURED PROFESSIONALS HEADER
              SliverToBoxAdapter(
                child: _buildSectionHeader("Recommended for You", isTablet, textColor),
              ),

              // 3. RESPONSIVE LIST/GRID
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: isTablet ? 10 : 0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildProListItem(context, "Rajesh Kumar", "Electrician", "4.8", "120 Reviews", "₹299/v", "https://i.pravatar.cc/150?u=12", isTablet, isDarkMode, cardColor, textColor, secondaryTextColor),
                    _buildProListItem(context, "Sarah Jenkins", "Dog Walker", "4.9", "85 Reviews", "₹150/h", "https://i.pravatar.cc/150?u=sarah", isTablet, isDarkMode, cardColor, textColor, secondaryTextColor),
                    _buildProListItem(context, "Amit Sharma", "Plumber", "4.7", "92 Reviews", "₹199/v", "https://i.pravatar.cc/150?u=14", isTablet, isDarkMode, cardColor, textColor, secondaryTextColor),
                  ]),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 50)),
            ],
          ),
        ),
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildSearchBar(bool isTablet, bool isDarkMode, Color fill, Color text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(15),
        border: isDarkMode ? Border.all(color: Colors.white10) : null,
      ),
      child: TextField(
        style: TextStyle(color: text, fontSize: isTablet ? 16 : 14),
        decoration: InputDecoration(
          hintText: "Search for 'Plumber' or 'Tutor'...",
          hintStyle: GoogleFonts.plusJakartaSans(fontSize: isTablet ? 16 : 14, color: isDarkMode ? Colors.white38 : Colors.grey),
          prefixIcon: Icon(Icons.search, color: isDarkMode ? Colors.white38 : Colors.grey, size: isTablet ? 24 : 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _buildCategoryGrid(bool isTablet, bool isDarkMode, Color textColor) {
    final List<Map<String, dynamic>> categories = [
      {"name": "Electrician", "icon": Icons.bolt, "color": Colors.orange},
      {"name": "Plumber", "icon": Icons.water_drop, "color": Colors.blue},
      {"name": "Cleaning", "icon": Icons.cleaning_services, "color": Colors.green},
      {"name": "Dog Walker", "icon": Icons.pets, "color": Colors.brown},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: categories.map((cat) {
        return Column(
          children: [
            Container(
              padding: EdgeInsets.all(isTablet ? 16 : 12),
              decoration: BoxDecoration(
                color: cat['color'].withOpacity(isDarkMode ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(cat['icon'], color: cat['color'], size: isTablet ? 30 : 24),
            ),
            const SizedBox(height: 8),
            Text(
                cat['name'],
                style: GoogleFonts.plusJakartaSans(
                    fontSize: isTablet ? 13 : 11,
                    fontWeight: FontWeight.w700,
                    color: textColor
                )
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildSectionHeader(String title, bool isTablet, Color text) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, isTablet ? 35 : 25, 20, 15),
      child: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
            fontSize: isTablet ? 22 : 18,
            fontWeight: FontWeight.w800,
            color: text
        ),
      ),
    );
  }

  Widget _buildProListItem(BuildContext context, String name, String job, String rating, String reviews, String price, String img, bool isTablet, bool isDarkMode, Color bg, Color text, Color subText) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDarkMode ? Colors.white10 : const Color(0xFFE2E8F0)),
        boxShadow: isDarkMode ? null : [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(img, height: isTablet ? 80 : 60, width: isTablet ? 80 : 60, fit: BoxFit.cover),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: isTablet ? 17 : 15, color: text)),
                Text(job, style: GoogleFonts.plusJakartaSans(fontSize: isTablet ? 14 : 12, color: subText)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 14),
                    const SizedBox(width: 4),
                    Text(rating, style: TextStyle(fontWeight: FontWeight.bold, fontSize: isTablet ? 14 : 13, color: text)),
                    Text(" ($reviews)", style: TextStyle(color: subText, fontSize: isTablet ? 13 : 12)),
                  ],
                )
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(price, style: TextStyle(color: const Color(0xFF2563EB), fontWeight: FontWeight.w900, fontSize: isTablet ? 17 : 15)),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: isTablet ? 20 : 12, vertical: isTablet ? 10 : 6),
                  decoration: BoxDecoration(color: const Color(0xFF2563EB), borderRadius: BorderRadius.circular(10)),
                  child: Text(
                      "Book",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: isTablet ? 14 : 12
                      )
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}