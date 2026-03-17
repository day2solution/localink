import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final Color primaryBlue = const Color(0xFF2563EB);

  @override
  Widget build(BuildContext context) {
    // 1. RESPONSIVE & THEME DETECTION
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 600;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // 1 column for mobile, 2 for tablet, 3 for large screens
    int crossAxisCount = screenWidth > 950 ? 3 : (isTablet ? 2 : 1);

    // 2. DYNAMIC COLOR PALETTE
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
          "Local Services",
          style: GoogleFonts.plusJakartaSans(
            color: textColor,
            fontWeight: FontWeight.w800,
            fontSize: isTablet ? 24 : 20,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // 1. SEARCH & CATEGORY CHIPS
          SliverToBoxAdapter(
            child: Container(
              color: cardColor,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: isTablet ? 25 : 15),
              child: Column(
                children: [
                  _buildSearchBar(isTablet, isDarkMode, inputFill, textColor),
                  const SizedBox(height: 15),
                  _buildServiceCategories(isTablet, isDarkMode, cardColor, textColor),
                ],
              ),
            ),
          ),

          // 2. FEATURED PROFESSIONALS
          SliverToBoxAdapter(
            child: _buildSectionHeader("Top Rated Pros", "See All", isTablet, textColor),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: isTablet ? 280 : 220,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 20),
                children: [
                  _buildFeaturedProCard("Alex Rivara", "Master Plumber", "4.9", "120 Reviews", "https://i.pravatar.cc/150?u=12", isTablet, isDarkMode, cardColor, textColor, secondaryTextColor),
                  _buildFeaturedProCard("Sarah Chen", "Math Tutor", "5.0", "85 Reviews", "https://i.pravatar.cc/150?u=15", isTablet, isDarkMode, cardColor, textColor, secondaryTextColor),
                  _buildFeaturedProCard("Marc Miller", "Electrician", "4.8", "200 Reviews", "https://i.pravatar.cc/150?u=11", isTablet, isDarkMode, cardColor, textColor, secondaryTextColor),
                ],
              ),
            ),
          ),

          // 3. ALL SERVICES (Responsive Grid)
          SliverToBoxAdapter(
            child: _buildSectionHeader("Nearby Services", "Filter", isTablet, textColor),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                mainAxisExtent: isTablet ? 120 : 100,
              ),
              delegate: SliverChildListDelegate([
                _buildServiceListItem("Home Cleaning Pro", "Apartments & houses.", "₹499/hr", "4.8", "0.5 km", isTablet, isDarkMode, cardColor, textColor, secondaryTextColor),
                _buildServiceListItem("Fix-It Electrical", "Certified electrician.", "₹299/v", "4.7", "1.2 km", isTablet, isDarkMode, cardColor, textColor, secondaryTextColor),
                _buildServiceListItem("Urban Pet Grooming", "Professional grooming.", "₹800/s", "4.9", "0.8 km", isTablet, isDarkMode, cardColor, textColor, secondaryTextColor),
                _buildServiceListItem("Yoga at Home", "Private sessions.", "₹1200/h", "5.0", "2.1 km", isTablet, isDarkMode, cardColor, textColor, secondaryTextColor),
              ]),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildSearchBar(bool isTablet, bool isDarkMode, Color fill, Color text) {
    return Container(
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(12),
        border: isDarkMode ? Border.all(color: Colors.white10) : null,
      ),
      child: TextField(
        style: TextStyle(fontSize: isTablet ? 16 : 14, color: text),
        decoration: InputDecoration(
          hintText: "Search 'Plumber' or 'Tutor'...",
          hintStyle: GoogleFonts.plusJakartaSans(
              fontSize: isTablet ? 16 : 14,
              color: isDarkMode ? Colors.white38 : Colors.grey
          ),
          prefixIcon: Icon(Icons.search, color: isDarkMode ? Colors.white38 : Colors.grey, size: isTablet ? 24 : 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildServiceCategories(bool isTablet, bool isDarkMode, Color cardBg, Color text) {
    final List<Map<String, dynamic>> categories = [
      {"name": "Cleaning", "icon": Icons.cleaning_services},
      {"name": "Repairs", "icon": Icons.handyman},
      {"name": "Tutoring", "icon": Icons.menu_book},
      {"name": "Health", "icon": Icons.spa},
    ];

    return SizedBox(
      height: isTablet ? 50 : 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(right: 10),
            padding: EdgeInsets.symmetric(horizontal: isTablet ? 22 : 16),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: isDarkMode ? Colors.white10 : const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                Icon(categories[index]['icon'], size: isTablet ? 20 : 16, color: primaryBlue),
                const SizedBox(width: 8),
                Text(
                    categories[index]['name'],
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: isTablet ? 14 : 12,
                      fontWeight: FontWeight.w600,
                      color: text,
                    )
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, String action, bool isTablet, Color text) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, isTablet ? 35 : 25, 20, 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.plusJakartaSans(fontSize: isTablet ? 22 : 18, fontWeight: FontWeight.w800, color: text)),
          Text(action, style: GoogleFonts.plusJakartaSans(fontSize: isTablet ? 16 : 14, fontWeight: FontWeight.bold, color: primaryBlue)),
        ],
      ),
    );
  }

  Widget _buildFeaturedProCard(String name, String role, String rating, String reviews, String img, bool isTablet, bool isDarkMode, Color bg, Color text, Color subText) {
    return Container(
      width: isTablet ? 200 : 160,
      margin: const EdgeInsets.only(right: 15),
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: isDarkMode ? Border.all(color: Colors.white10) : null,
        boxShadow: isDarkMode ? null : [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        children: [
          CircleAvatar(radius: isTablet ? 45 : 35, backgroundImage: NetworkImage(img)),
          const SizedBox(height: 12),
          Text(name, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: isTablet ? 16 : 14, color: text)),
          Text(role, style: GoogleFonts.plusJakartaSans(fontSize: isTablet ? 13 : 11, color: subText)),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, color: Colors.orange, size: 14),
              const SizedBox(width: 4),
              Text(rating, style: TextStyle(fontWeight: FontWeight.bold, fontSize: isTablet ? 14 : 12, color: text)),
              Text(" ($reviews)", style: TextStyle(color: subText, fontSize: isTablet ? 12 : 10)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildServiceListItem(String name, String desc, String price, String rating, String dist, bool isTablet, bool isDarkMode, Color bg, Color text, Color subText) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDarkMode ? Colors.white10 : const Color(0xFFF1F5F9)),
      ),
      child: Row(
        children: [
          Container(
            height: isTablet ? 70 : 60, width: isTablet ? 70 : 60,
            decoration: BoxDecoration(
              color: primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.business_center, color: primaryBlue, size: isTablet ? 28 : 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(name, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: isTablet ? 16 : 14, color: text)),
                    Text(price, style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold, fontSize: isTablet ? 14 : 12)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                    desc,
                    style: GoogleFonts.plusJakartaSans(fontSize: isTablet ? 13 : 11, color: subText),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 14),
                    const SizedBox(width: 4),
                    Text(rating, style: TextStyle(fontWeight: FontWeight.bold, fontSize: isTablet ? 13 : 11, color: text)),
                    const SizedBox(width: 12),
                    const Icon(Icons.location_on, color: Colors.grey, size: 14),
                    const SizedBox(width: 4),
                    Text(dist, style: TextStyle(color: subText, fontSize: isTablet ? 12 : 11)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}