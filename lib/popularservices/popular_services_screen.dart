import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PopularServicesScreen extends StatelessWidget {
  const PopularServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF2563EB);
    const Color textDark = Color(0xFF0F172A);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: textDark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "All Services",
          style: GoogleFonts.plusJakartaSans(
            color: textDark,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // 1. SEARCH & CATEGORIES
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildSearchBar(),
                  const SizedBox(height: 20),
                  _buildCategoryGrid(),
                ],
              ),
            ),
          ),

          // 2. FEATURED PROFESSIONALS
          SliverToBoxAdapter(
            child: _buildSectionHeader("Recommended for You"),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              _buildProListItem(
                context,
                "Rajesh Kumar",
                "Electrician",
                "4.8",
                "120 Reviews",
                "₹299/visit",
                "https://i.pravatar.cc/150?u=12",
              ),
              _buildProListItem(
                context,
                "Sarah Jenkins",
                "Dog Walker",
                "4.9",
                "85 Reviews",
                "₹150/hr",
                "https://i.pravatar.cc/150?u=sarah",
              ),
              _buildProListItem(
                context,
                "Amit Sharma",
                "Plumber",
                "4.7",
                "92 Reviews",
                "₹199/visit",
                "https://i.pravatar.cc/150?u=14",
              ),
            ]),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 50)),
        ],
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search for 'Plumber' or 'Tutor'...",
          hintStyle: GoogleFonts.plusJakartaSans(fontSize: 14, color: Colors.grey),
          prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _buildCategoryGrid() {
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
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cat['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(cat['icon'], color: cat['color'], size: 24),
            ),
            const SizedBox(height: 8),
            Text(cat['name'], style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700)),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 15),
      child: Text(
        title,
        style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w800),
      ),
    );
  }

  Widget _buildProListItem(BuildContext context, String name, String job, String rating, String reviews, String price, String img) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(img, height: 60, width: 60, fit: BoxFit.cover),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 15)),
                Text(job, style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 14),
                    const SizedBox(width: 4),
                    Text(rating, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    Text(" ($reviews)", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                )
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(price, style: const TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.w900, fontSize: 15)),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  // Navigate based on Job Type
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: const Color(0xFF2563EB), borderRadius: BorderRadius.circular(10)),
                  child: const Text("Book", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}