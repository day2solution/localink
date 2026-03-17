import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final Color primaryBlue = const Color(0xFF2563EB);
  final Color textDark = const Color(0xFF0F172A);

  @override
  Widget build(BuildContext context) {
    // 1. Responsive Detection
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 600;
    // 1 column for mobile, 2 for tablet, 3 for large screens
    int crossAxisCount = screenWidth > 950 ? 3 : (isTablet ? 2 : 1);

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
          "Local Services",
          style: GoogleFonts.plusJakartaSans(
            color: textDark,
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
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: isTablet ? 25 : 15),
              child: Column(
                children: [
                  _buildSearchBar(isTablet),
                  const SizedBox(height: 15),
                  _buildServiceCategories(isTablet),
                ],
              ),
            ),
          ),

          // 2. FEATURED PROFESSIONALS
          SliverToBoxAdapter(
            child: _buildSectionHeader("Top Rated Pros", "See All", isTablet),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: isTablet ? 280 : 220, // Taller for tablet
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 20),
                children: [
                  _buildFeaturedProCard("Alex Rivara", "Master Plumber", "4.9", "120 Reviews", "https://i.pravatar.cc/150?u=12", isTablet),
                  _buildFeaturedProCard("Sarah Chen", "Math Tutor", "5.0", "85 Reviews", "https://i.pravatar.cc/150?u=15", isTablet),
                  _buildFeaturedProCard("Marc Miller", "Electrician", "4.8", "200 Reviews", "https://i.pravatar.cc/150?u=11", isTablet),
                ],
              ),
            ),
          ),

          // 3. ALL SERVICES (Responsive Grid)
          SliverToBoxAdapter(
            child: _buildSectionHeader("Nearby Services", "Filter", isTablet),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                mainAxisExtent: isTablet ? 120 : 100, // Fixed height per item
              ),
              delegate: SliverChildListDelegate([
                _buildServiceListItem("Home Cleaning Pro", "Apartments & houses.", "₹499/hr", "4.8", "0.5 km", isTablet),
                _buildServiceListItem("Fix-It Electrical", "Certified electrician.", "₹299/v", "4.7", "1.2 km", isTablet),
                _buildServiceListItem("Urban Pet Grooming", "Professional grooming.", "₹800/s", "4.9", "0.8 km", isTablet),
                _buildServiceListItem("Yoga at Home", "Private sessions.", "₹1200/h", "5.0", "2.1 km", isTablet),
              ]),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildSearchBar(bool isTablet) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        style: TextStyle(fontSize: isTablet ? 16 : 14),
        decoration: InputDecoration(
          hintText: "Search 'Plumber' or 'Tutor'...",
          hintStyle: GoogleFonts.plusJakartaSans(fontSize: isTablet ? 16 : 14, color: Colors.grey),
          prefixIcon: Icon(Icons.search, color: Colors.grey, size: isTablet ? 24 : 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildServiceCategories(bool isTablet) {
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                Icon(categories[index]['icon'], size: isTablet ? 20 : 16, color: primaryBlue),
                const SizedBox(width: 8),
                Text(categories[index]['name'],
                    style: GoogleFonts.plusJakartaSans(fontSize: isTablet ? 14 : 12, fontWeight: FontWeight.w600)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, String action, bool isTablet) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, isTablet ? 35 : 25, 20, 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.plusJakartaSans(fontSize: isTablet ? 22 : 18, fontWeight: FontWeight.w800, color: textDark)),
          Text(action, style: GoogleFonts.plusJakartaSans(fontSize: isTablet ? 16 : 14, fontWeight: FontWeight.bold, color: primaryBlue)),
        ],
      ),
    );
  }

  Widget _buildFeaturedProCard(String name, String role, String rating, String reviews, String img, bool isTablet) {
    return Container(
      width: isTablet ? 200 : 160,
      margin: const EdgeInsets.only(right: 15),
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        children: [
          CircleAvatar(radius: isTablet ? 45 : 35, backgroundImage: NetworkImage(img)),
          const SizedBox(height: 12),
          Text(name, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: isTablet ? 16 : 14)),
          Text(role, style: GoogleFonts.plusJakartaSans(fontSize: isTablet ? 13 : 11, color: Colors.grey)),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, color: Colors.orange, size: 14),
              const SizedBox(width: 4),
              Text(rating, style: TextStyle(fontWeight: FontWeight.bold, fontSize: isTablet ? 14 : 12)),
              Text(" ($reviews)", style: TextStyle(color: Colors.grey, fontSize: isTablet ? 12 : 10)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildServiceListItem(String name, String desc, String price, String rating, String dist, bool isTablet) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
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
                    Text(name, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: isTablet ? 16 : 14)),
                    Text(price, style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold, fontSize: isTablet ? 14 : 12)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(desc, style: GoogleFonts.plusJakartaSans(fontSize: isTablet ? 13 : 11, color: Colors.grey[600]), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 14),
                    const SizedBox(width: 4),
                    Text(rating, style: TextStyle(fontWeight: FontWeight.bold, fontSize: isTablet ? 13 : 11)),
                    const SizedBox(width: 12),
                    const Icon(Icons.location_on, color: Colors.grey, size: 14),
                    const SizedBox(width: 4),
                    Text(dist, style: TextStyle(color: Colors.grey, fontSize: isTablet ? 12 : 11)),
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