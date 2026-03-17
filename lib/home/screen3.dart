import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF2563EB); // Royal Blue
    const Color bgColor = Color(0xFFF8FAFC); // Slate 50
    const Color textDark = Color(0xFF0F172A); // Slate 900

    return Scaffold(
      backgroundColor: bgColor,
      body: CustomScrollView(
        slivers: [
          // 1. DYNAMIC HEADER
          SliverAppBar(
            expandedHeight: 110.0,
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(color: Colors.white),
              titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              centerTitle: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.near_me_rounded, color: primaryColor, size: 16),
                          const SizedBox(width: 4),
                          Text("Greenwood Heights",
                              style: GoogleFonts.plusJakartaSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: textDark)),
                        ],
                      ),
                      Text("Brooklyn, New York",
                          style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const CircleAvatar(
                    radius: 18,
                    backgroundColor: Color(0xFFE2E8F0),
                    child: Icon(Icons.person, color: Colors.grey),
                  )
                ],
              ),
            ),
          ),

          // 2. SEARCH BAR (STAYS ACCESSIBLE)
          SliverToBoxAdapter(
            child: _buildSearchBar(primaryColor),
          ),

          // 3. BENTO GRID - CORE SERVICES
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("What do you need?",
                      style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildBigBentoCard("Help", "Request a favor", Icons.volunteer_activism, Colors.orange, primaryColor)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          children: [
                            _buildSmallBentoCard("Services", Icons.handyman, Colors.blue),
                            const SizedBox(height: 12),
                            _buildSmallBentoCard("Market", Icons.local_mall, Colors.green),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 4. LIVE ALERTS (URGENT)
          SliverToBoxAdapter(
            child: _buildSectionHeader("Live Alerts", "View All"),
          ),
          SliverToBoxAdapter(
            child: _buildUrgentAlertCard(),
          ),

          // 5. MARKETPLACE PREVIEW
          SliverToBoxAdapter(
            child: _buildSectionHeader("Marketplace Nearby", "See More"),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildProductCard(
                  ["iPhone 13", "Sofa", "Bicycle", "Monitor"][index % 4],
                  ["₹45,000", "₹12,000", "₹8,000", "₹15,000"][index % 4],
                  "0.5 km",
                  "https://picsum.photos/200/300?random=$index",
                  isVerified: index % 2 == 0,
                ),
                childCount: 4,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text("Post", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildSearchBar(Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4)),
          ],
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: "Search for services, help or items...",
            hintStyle: GoogleFonts.plusJakartaSans(fontSize: 14, color: Colors.grey[400]),
            prefixIcon: Icon(Icons.search, color: primaryColor),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildBigBentoCard(String title, String sub, IconData icon, Color color, Color primary) {
    return Container(
      height: 152,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(backgroundColor: color.withOpacity(0.1), child: Icon(icon, color: color)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 18)),
              Text(sub, style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSmallBentoCard(String title, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Text(title, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildUrgentAlertCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          const Icon(Icons.campaign_rounded, color: Colors.red),
          const SizedBox(width: 12),
          Expanded(
            child: Text("Scheduled Power Outage: 11 PM to 2 AM",
                style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF991B1B))),
          ),
          const Icon(Icons.chevron_right, color: Colors.red, size: 18),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String action) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w800)),
          Text(action, style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF2563EB))),
        ],
      ),
    );
  }

  Widget _buildProductCard(String name, String price, String dist, String img, {bool isVerified = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(20)), child: Image.network(img, width: double.infinity, fit: BoxFit.cover))),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Expanded(child: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis)),
                  if (isVerified) const Icon(Icons.verified, color: Colors.blue, size: 14)
                ]),
                const SizedBox(height: 4),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(price, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
                      Text(dist, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                    ]
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}