import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen2 extends StatelessWidget {
  const HomeScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF2563EB);
    const Color bgColor = Color(0xFFF1F5F9); // Lighter, premium grey-blue
    const Color textDark = Color(0xFF0F172A);

    return Scaffold(
      backgroundColor: bgColor,
      body: CustomScrollView(
        slivers: [
          // 1. PROFESSIONAL APP BAR (SLIVER)
          SliverAppBar(
            expandedHeight: 120.0,
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(color: Colors.white),
              titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.near_me, color: primaryColor, size: 14),
                          const SizedBox(width: 4),
                          Text("Greenwood Heights",
                              style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w800, color: textDark)),
                        ],
                      ),
                      Text("Brooklyn, New York",
                          style: GoogleFonts.plusJakartaSans(fontSize: 10, color: Colors.grey[500])),
                    ],
                  ),
                  const CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=9'),
                  )
                ],
              ),
            ),
          ),

          // 2. SEARCH & PROMO BANNER
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildSearchBar(primaryColor),
                _buildPromoBanner(),
              ],
            ),
          ),

          // 3. MODERN ICON NAVIGATION (QUICK ACTIONS)
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverGrid.count(
              crossAxisCount: 4,
              mainAxisSpacing: 20,
              crossAxisSpacing: 10,
              children: [
                _buildNavIcon("Help", Icons.volunteer_activism, Colors.orange),
                _buildNavIcon("Services", Icons.handyman, Colors.blue),
                _buildNavIcon("Sell", Icons.storefront, Colors.green),
                _buildNavIcon("Alerts", Icons.campaign, Colors.red),
              ],
            ),
          ),

          // 4. URGENT ALERTS SECTION
          SliverToBoxAdapter(
            child: _buildSectionHeader("Local Alerts", "See All"),
          ),
          SliverToBoxAdapter(
            child: _buildUrgentAlertCard(),
          ),

          // 5. SERVICES GRID (HORIZONTAL)
          SliverToBoxAdapter(
            child: _buildSectionHeader("Popular Services", "Explore"),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 180,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 20),
                children: [
                  _buildServiceCard("Electrician", "4.8 ★", "from \$20/hr", "https://images.unsplash.com/photo-1621905251189-08b45d6a269e?w=200"),
                  _buildServiceCard("Dog Walker", "4.9 ★", "from \$15/hr", "https://images.unsplash.com/photo-1516733725897-1aa73b87c8e8?w=200"),
                ],
              ),
            ),
          ),

          // 6. MARKETPLACE (STAGGERED FEEL)
          SliverToBoxAdapter(
            child: _buildSectionHeader("Marketplace Nearby", "Shop"),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              childAspectRatio: 0.8,
              children: [
                _buildProductCard("MacBook Pro 2021", "\$900", "0.2 km", "https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=300"),
                _buildProductCard("Comfy Sofa", "\$150", "1.5 km", "https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=300"),
              ],
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),

      // Floating Action Button for "Post Anything"
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text("Create Post", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildSearchBar(Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))],
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: "Search your neighborhood...",
            hintStyle: GoogleFonts.plusJakartaSans(fontSize: 14, color: Colors.grey),
            prefixIcon: Icon(Icons.search, color: primaryColor),
            suffixIcon: const Icon(Icons.tune, color: Colors.grey, size: 20),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      margin: const EdgeInsets.all(20),
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(colors: [Color(0xFF1E293B), Color(0xFF334155)]),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20, bottom: -20,
            child: Icon(Icons.location_city, size: 100, color: Colors.white.withOpacity(0.1)),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Summer Block Party!", style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text("Join your neighbors this Saturday at 5PM", style: GoogleFonts.plusJakartaSans(color: Colors.white70, fontSize: 12)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildNavIcon(String label, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          height: 55, width: 55,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [BoxShadow(color: color.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF475569))),
      ],
    );
  }

  Widget _buildUrgentAlertCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.red.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 12),
          Expanded(
            child: Text("Scheduled Power Outage: Tonight 11PM to 2AM",
                style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF991B1B))),
          ),
          const Icon(Icons.chevron_right, color: Colors.red),
        ],
      ),
    );
  }

  Widget _buildServiceCard(String title, String rating, String price, String img) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.network(img, height: 100, width: 150, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 13)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(rating, style: const TextStyle(color: Colors.orange, fontSize: 11, fontWeight: FontWeight.bold)),
                    Text(price, style: const TextStyle(color: Colors.blue, fontSize: 11, fontWeight: FontWeight.bold)),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProductCard(String name, String price, String dist, String img) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.network(img, width: double.infinity, fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(price, style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
                    Text(dist, style: TextStyle(fontSize: 10, color: Colors.grey[500])),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String action) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w800, color: const Color(0xFF0F172A))),
          Text(action, style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF2563EB))),
        ],
      ),
    );
  }
}