import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localink/alert/alerts_screen.dart';
import 'package:localink/dogwalker/dog_walker_list_screen.dart';
import 'package:localink/electrician/electrician_list_screen.dart';
import 'package:localink/help/help_screen.dart';
import 'package:localink/marketplace/marketplace_screen.dart';
import 'package:localink/marketplace/product_detail_screen.dart';
import 'package:localink/popularservices/popular_services_screen.dart';
import 'package:localink/profile/profile_setup_screen.dart';
import 'package:localink/sell/sell_item_screen.dart';
import 'package:localink/services/services_screen.dart';
import 'package:localink/util/app-icon.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _promoController = PageController();
  final Color primaryBlue = const Color(0xFF2563EB);
  final Color textDark = const Color(0xFF0F172A);
  String _selectedCategory = "All Items"; // Track selected category
  // --- PROMO DATA ---
  final List<Map<String, dynamic>> _promoData = [
    {
      "title": "Summer Block Party!",
      "subtitle": "Saturday at 5PM • Central Park",
      "tag": "COMMUNITY EVENT",
      "icon": Icons.celebration_rounded,
      "colors": [const Color(0xFF6366F1), const Color(0xFFA855F7)],
    },
    {
      "title": "Safety Workshop",
      "subtitle": "Learn home security • Monday 6PM",
      "tag": "NEIGHBORHOOD WATCH",
      "icon": Icons.shield_rounded,
      "colors": [const Color(0xFFF59E0B), const Color(0xFFEF4444)],
    },
    {
      "title": "Flash Sale Nearby",
      "subtitle": "Up to 50% off on furniture items",
      "tag": "MARKETPLACE",
      "icon": Icons.shopping_bag_rounded,
      "colors": [const Color(0xFF10B981), const Color(0xFF3B82F6)],
    },
    {
      "title": "Adopt a Pet Day",
      "subtitle": "Meet furry friends at the shelter",
      "tag": "LOCAL CAUSE",
      "icon": Icons.pets_rounded,
      "colors": [const Color(0xFFEC4899), const Color(0xFFF43F5E)],
    },
  ];

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.width > 600;
    const Color primaryColor = Color(0xFF2563EB);
    const Color bgColor = Color(0xFFF1F5F9);
    const Color textDarkColor = Color(0xFF0F172A);

    return Scaffold(
      backgroundColor: bgColor,
      body: CustomScrollView(
        slivers: [
          // 1. PROFESSIONAL APP BAR
          SliverAppBar(
            expandedHeight: isTablet ? 140.0 : 120.0,
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(color: Colors.white),
              titlePadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // buildAppIcon(isTablet ? 48 : 38),
                  const AppIcon(size: 35),
                  const SizedBox(width: 12),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.near_me,
                            color: primaryColor,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "Greenwood Heights",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: isTablet ? 18 : 14,
                              fontWeight: FontWeight.w800,
                              color: textDarkColor,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "Brooklyn, New York",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: isTablet ? 14 : 10,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileSetupScreen(),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      radius: isTablet ? 24 : 18,
                      backgroundColor: const Color(0xFFE2E8F0),
                      backgroundImage: const NetworkImage(
                        'https://i.pravatar.cc/150?u=9',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. SEARCH & PROMO BANNER
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildSearchBar(primaryColor, isTablet),
                _buildAttractivePromoCarousel(isTablet),
              ],
            ),
          ),

          // 3. MODERN ICON NAVIGATION
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 20,
                crossAxisSpacing: 10,
                mainAxisExtent: isTablet ? 130 : 100,
              ),
              delegate: SliverChildListDelegate([
                _buildNavIcon(
                  "Help",
                  Icons.volunteer_activism,
                  Colors.orange,
                  isTablet,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HelpScreen(),
                      ),
                    );
                  },
                ),
                _buildNavIcon(
                  "Services",
                  Icons.handyman,
                  Colors.blue,
                  isTablet,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ServicesScreen(),
                      ),
                    );
                  },
                ),
                _buildNavIcon(
                  "Sell",
                  Icons.storefront,
                  Colors.green,
                  isTablet,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SellItemScreen(),
                      ),
                    );
                  },
                ),
                _buildNavIcon(
                  "Alerts",
                  Icons.campaign,
                  Colors.red,
                  isTablet,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AlertsScreen(),
                      ),
                    );
                  },
                ),
              ]),
            ),
          ),

          // 4. URGENT ALERTS SECTION
          SliverToBoxAdapter(
            child: _buildSectionHeader("Local Alerts", "See All", isTablet, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AlertsScreen()),
              );
            }),
          ),
          SliverToBoxAdapter(
            child: _buildUrgentAlertCard(isTablet, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AlertsScreen()),
              );
            }),
          ),

          // 5. SERVICES SECTION
          SliverToBoxAdapter(
            child: _buildSectionHeader(
              "Popular Services",
              "Explore",
              isTablet,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PopularServicesScreen(),
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: isTablet ? 250 : 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 20),
                children: [
                  _buildServiceCard(
                    "Electrician",
                    "4.8 ★",
                    "from ₹299",
                    "https://images.unsplash.com/photo-1621905251189-08b45d6a269e?w=200",
                    isTablet,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ElectricianListScreen(),
                        ),
                      );
                    },
                  ),
                  _buildServiceCard(
                    "Dog Walker",
                    "4.9 ★",
                    "from ₹150",
                    "https://images.unsplash.com/photo-1516733725897-1aa73b87c8e8?w=200",
                    isTablet,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DogWalkerListScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // 6. MARKETPLACE SECTION
          SliverToBoxAdapter(
            child: _buildSectionHeader(
              "Marketplace Nearby",
              "View All",
              isTablet,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MarketplaceScreen(),
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: isTablet ? 50 : 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 20),
                children:
                    [
                      "All Items",
                      "Electronics",
                      "Furniture",
                      "Kitchen",
                      "Free Stuff",
                    ].map((category) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                        child: _buildCategoryChip(
                          category,
                          _selectedCategory == category, // Highlighting logic
                          isTablet,
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 15)),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isTablet ? 4 : 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                mainAxisExtent: isTablet ? 320 : 280,
              ),
              delegate: SliverChildListDelegate([
                _buildProductCard(
                  context,
                  "MacBook Pro 2021",
                  "₹75,000",
                  "0.2 km",
                  "https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=400",
                  isTablet,
                  isVerified: true,
                ),
                _buildProductCard(
                  context,
                  "Ergonomic Chair",
                  "₹4,500",
                  "1.5 km",
                  "https://images.unsplash.com/photo-1592078615290-033ee584e267?w=400",
                  isTablet,
                ),
                _buildProductCard(
                  context,
                  "Acoustic Guitar",
                  "₹3,200",
                  "0.8 km",
                  "https://images.unsplash.com/photo-1510915361894-db8b60106cb1?w=400",
                  isTablet,
                ),
                _buildProductCard(
                  context,
                  "Nike Air Max",
                  "₹2,800",
                  "2.1 km",
                  "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400",
                  isTablet,
                  isNew: true,
                ),
              ]),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: primaryColor,
        icon: Icon(Icons.add, color: Colors.white, size: isTablet ? 28 : 24),
        label: Text(
          "Create Post",
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: isTablet ? 18 : 14,
          ),
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildSearchBar(Color primaryColor, bool isTablet) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        height: isTablet ? 60 : 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: "Search your neighborhood...",
            hintStyle: GoogleFonts.plusJakartaSans(
              fontSize: isTablet ? 16 : 14,
              color: Colors.grey,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: primaryColor,
              size: isTablet ? 28 : 24,
            ),
            suffixIcon: Icon(
              Icons.tune,
              color: Colors.grey,
              size: isTablet ? 24 : 20,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildAttractivePromoCarousel(bool isTablet) {
    return Column(
      children: [
        SizedBox(
          height: isTablet ? 240 : 180,
          child: PageView.builder(
            controller: _promoController,
            itemCount: _promoData.length,
            itemBuilder: (context, index) {
              final data = _promoData[index];
              return Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: isTablet ? 15 : 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  color: const Color(0xFF0F172A),
                  boxShadow: [
                    BoxShadow(
                      color: data['colors'][0].withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Stack(
                    children: [
                      Positioned(
                        top: -40,
                        right: -40,
                        child: _glow(data['colors'][1]),
                      ),
                      Positioned(
                        bottom: -60,
                        left: -20,
                        child: _glow(data['colors'][0]),
                      ),
                      Positioned(
                        right: -10,
                        bottom: -20,
                        child: Icon(
                          data['icon'],
                          size: isTablet ? 200 : 150,
                          color: Colors.white.withOpacity(0.07),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(isTablet ? 32 : 24),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      data['tag'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: isTablet ? 12 : 9,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    data['title'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: isTablet ? 28 : 20,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    data['subtitle'],
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: isTablet ? 16 : 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _glassButton(isTablet),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _glow(Color color) => Container(
    height: 180,
    width: 180,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: RadialGradient(
        colors: [color.withOpacity(0.4), color.withOpacity(0)],
      ),
    ),
  );

  Widget _glassButton(bool isTablet) => Container(
    padding: EdgeInsets.all(isTablet ? 16 : 12),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.15),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.white.withOpacity(0.2)),
    ),
    child: Icon(
      Icons.arrow_forward_ios_rounded,
      color: Colors.white,
      size: isTablet ? 20 : 16,
    ),
  );

  Widget _buildNavIcon(
    String label,
    IconData icon,
    Color color,
    bool isTablet,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: isTablet ? 75 : 55,
            width: isTablet ? 75 : 55,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: color, size: isTablet ? 32 : 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: isTablet ? 15 : 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF475569),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUrgentAlertCard(bool isTablet, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF1F2),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.red.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: isTablet ? 28 : 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "Scheduled Power Outage: Tonight 11PM to 2AM",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: isTablet ? 16 : 13,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF991B1B),
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.red,
              size: isTablet ? 24 : 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(
    String title,
    String rating,
    String price,
    String img,
    bool isTablet,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isTablet ? 200 : 150,
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15),
              ),
              child: Image.network(
                img,
                height: isTablet ? 140 : 100,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.bold,
                      fontSize: isTablet ? 16 : 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        rating,
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: isTablet ? 13 : 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        price,
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: isTablet ? 13 : 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    String title,
    String action,
    bool isTablet,
    VoidCallback onActionTap,
  ) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, isTablet ? 35 : 25, 20, 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: isTablet ? 24 : 18,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0F172A),
            ),
          ),
          GestureDetector(
            onTap: onActionTap,
            child: Text(
              action,
              style: GoogleFonts.plusJakartaSans(
                fontSize: isTablet ? 18 : 14,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2563EB),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isActive, bool isTablet) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 20 : 16),
      decoration: BoxDecoration(
        // Background color changes based on selection
        color: isActive ? const Color(0xFF2563EB) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? Colors.transparent : const Color(0xFFE2E8F0),
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: const Color(0xFF2563EB).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Center(
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: isTablet ? 15 : 12,
            fontWeight: FontWeight.w600,
            // Text color changes based on selection
            color: isActive ? Colors.white : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    String name,
    String price,
    String dist,
    String img,
    bool isTablet, {
    bool isVerified = false,
    bool isNew = false,
  }) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailScreen(
            name: name,
            price: price,
            dist: dist,
            img: img,
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
                child: Image.network(
                  img,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.bold,
                      fontSize: isTablet ? 16 : 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        price,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF0F172A),
                          fontSize: isTablet ? 18 : 14,
                        ),
                      ),
                      Text(
                        dist,
                        style: TextStyle(
                          fontSize: isTablet ? 12 : 10,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAppIcon(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563EB).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: Icon(Icons.link_rounded, size: size * 0.45, color: Colors.white),
      ),
    );
  }
}
