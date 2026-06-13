import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localink/alert/alerts_screen.dart';
import 'package:localink/api_service.dart';
import 'package:localink/dogwalker/dog_walker_list_screen.dart';
import 'package:localink/electrician/electrician_list_screen.dart';
import 'package:localink/help/help_screen.dart';
import 'package:localink/marketplace/marketplace_screen.dart';
import 'package:localink/marketplace/product_detail_screen.dart';
import 'package:localink/marketplace/promo.dart';
import 'package:localink/popularservices/popular_services_screen.dart';
import 'package:localink/profile/profile_setup_screen.dart';
import 'package:localink/sell/sell_item_screen.dart';
import 'package:localink/services/services_screen.dart';
import 'package:localink/util/app-icon.dart';
import 'package:logging/logging.dart';

class HomeScreen extends StatefulWidget {
  final String mobileNumber;

  const HomeScreen({super.key, required this.mobileNumber});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _promoController = PageController();
  String _selectedCategory = "All Items";
  final ApiService _apiService = ApiService();
  final Logger _log = Logger('HomeScreen');
  late Future<List<dynamic>> _productsFuture;
  late Future<List<Promo>> _promoFuture;
  // --- PROMO DATA ---
  // final List<Map<String, dynamic>> _promoData = [
  //   {
  //     "title": "Summer Block Party!",
  //     "subtitle": "Saturday at 5PM • Central Park",
  //     "tag": "COMMUNITY EVENT",
  //     "icon": Icons.celebration_rounded,
  //     "colors": [const Color(0xFF6366F1), const Color(0xFFA855F7)],
  //   },
  //   {
  //     "title": "Safety Workshop",
  //     "subtitle": "Learn home security • Monday 6PM",
  //     "tag": "NEIGHBORHOOD WATCH",
  //     "icon": Icons.shield_rounded,
  //     "colors": [const Color(0xFFF59E0B), const Color(0xFFEF4444)],
  //   },
  //   {
  //     "title": "Flash Sale Nearby",
  //     "subtitle": "Up to 50% off on furniture items",
  //     "tag": "MARKETPLACE",
  //     "icon": Icons.shopping_bag_rounded,
  //     "colors": [const Color(0xFF10B981), const Color(0xFF3B82F6)],
  //   },
  // ];
  @override
  void initState() {
    super.initState();
    _log.info("Initializing HomeScreen for: ${widget.mobileNumber}");

    // 3. Initial API Call
    _loadProducts();
    _loadPromo();
  }

  // lib/api_service.dart


// Helper to map backend string names (like "celebration") to Flutter IconData
  IconData _getIconData(String name) {
    switch (name) {
      case 'celebration': return Icons.celebration_rounded;
      case 'shield': return Icons.shield_rounded;
      case 'shopping': return Icons.shopping_bag_rounded;
      default: return Icons.info_outline;
    }
  }

  void _loadProducts() {
    _log.info("Requesting marketplace items for category: $_selectedCategory");

    setState(() {
      _productsFuture = _apiService
          .fetchMarketplaceItems(_selectedCategory)
          .catchError((Object error, StackTrace stackTrace) {

        _log.severe(
          "Exception caught in _loadProducts for category $_selectedCategory: $error",
          error,
          stackTrace,
        );
        throw error;
      });
    });
  }
void _loadPromo(){
    _log.info("Requesting marketplace _loadPromo");
    setState(() {
      _promoFuture = _apiService.fetchPromos().catchError((Object error, StackTrace stackTrace) {
        _log.severe(
          "Exception caught in _loadPromo : $error",
          error,
          stackTrace,
        );
        throw error;
      });
    });

}
  // Helper method to show the error
  void _showErrorSnackBar(String message) {
    // Clean the message (remove "Exception: " prefix if present)
    final cleanMessage = message.replaceAll('Exception:', '').trim();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(child: Text(cleanMessage)),
          ],
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        action: SnackBarAction(
          label: "RETRY",
          textColor: Colors.white,
          onPressed: _loadProducts,
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    // 1. RESPONSIVE & THEME DETECTION
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 600;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // 2. ADAPTIVE COLOR PALETTE
    const Color primaryColor = Color(0xFF2563EB);
    final Color textColor = isDarkMode ? Colors.white : const Color(0xFF0F172A);
    final Color secondaryTextColor = isDarkMode ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final Color cardColor = isDarkMode ? const Color(0xFF1E293B) : Colors.white;
    final Color scaffoldBg = isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9);
    final Color appBarBg = isDarkMode ? const Color(0xFF1E293B) : Colors.white;

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 1. DYNAMIC APP BAR
          SliverAppBar(
            expandedHeight: isTablet ? 140.0 : 120.0,
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: appBarBg,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(color: appBarBg),
              titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AppIcon(size: 35, showShadow: false),
                  const SizedBox(width: 12),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.near_me, color: primaryColor, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            "Greenwood Heights",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: isTablet ? 18 : 14,
                              fontWeight: FontWeight.w800,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "Brooklyn, New York",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: isTablet ? 14 : 10,
                          color: secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  _buildProfileAvatar(isTablet),
                ],
              ),
            ),
          ),

          // 2. SEARCH & PROMO BANNER
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildSearchBar(primaryColor, isTablet, isDarkMode, cardColor, textColor),
                _buildAttractivePromoCarousel(isTablet, isDarkMode),
              ],
            ),
          ),

          // 3. ICON NAVIGATION
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
                _buildNavIcon("Help", Icons.volunteer_activism, Colors.orange, isTablet, isDarkMode, () => _navigateTo(const HelpScreen())),
                _buildNavIcon("Services", Icons.handyman, Colors.blue, isTablet, isDarkMode, () => _navigateTo(const ServicesScreen())),
                _buildNavIcon("Sell", Icons.storefront, Colors.green, isTablet, isDarkMode, () => _navigateTo(const SellItemScreen())),
                _buildNavIcon("Alerts", Icons.campaign, Colors.red, isTablet, isDarkMode, () => _navigateTo(const AlertsScreen())),
              ]),
            ),
          ),

          // 4. ALERTS SECTION
          SliverToBoxAdapter(
            child: _buildSectionHeader("Local Alerts", "See All", isTablet, textColor, primaryColor, () => _navigateTo(const AlertsScreen())),
          ),
          SliverToBoxAdapter(
            child: _buildUrgentAlertCard(isTablet, isDarkMode, cardColor, textColor, secondaryTextColor),
          ),

          // 5. SERVICES SECTION
          SliverToBoxAdapter(
            child: _buildSectionHeader("Popular Services", "Explore", isTablet, textColor, primaryColor, () => _navigateTo(const PopularServicesScreen())),
          ),
          SliverToBoxAdapter(
            child: _buildHorizontalServices(isTablet, isDarkMode, cardColor, textColor, secondaryTextColor),
          ),

          // 6. MARKETPLACE
          SliverToBoxAdapter(
            child: _buildSectionHeader("Marketplace Nearby", "View All", isTablet, textColor, primaryColor, () => _navigateTo(const MarketplaceScreen())),
          ),

          // CATEGORY CHIPS
          SliverToBoxAdapter(
            child: SizedBox(
              height: isTablet ? 50 : 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 20),
                children: ["All Items", "Electronics", "Furniture", "Kitchen", "Free Stuff"].map((category) {
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = category),
                    child: _buildCategoryChip(category, _selectedCategory == category, isTablet, isDarkMode, primaryColor),
                  );
                }).toList(),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 15)),
          // PRODUCT GRID
          FutureBuilder<List<dynamic>>(
            future: _productsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverToBoxAdapter(child: Center(child: Padding(padding: EdgeInsets.all(40.0), child: CircularProgressIndicator(color: primaryColor))));
              }
              if (snapshot.hasError) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Column(
                      children: [
                        const Icon(Icons.cloud_off, size: 48, color: Colors.grey),
                        const SizedBox(height: 10),
                        Text("Marketplace temporarily unavailable", style: GoogleFonts.plusJakartaSans(color: textColor, fontWeight: FontWeight.w600)),
                        TextButton(onPressed: _loadProducts, child: const Text("RETRY"))
                      ],
                    ),
                  ),
                );
              }

              final products = snapshot.data ?? [];
              if (products.isEmpty) {
                return SliverToBoxAdapter(child: Center(child: Padding(padding: const EdgeInsets.all(40.0), child: Text("No items found", style: TextStyle(color: secondaryTextColor)))));
              }

              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isTablet ? 4 : 2, mainAxisSpacing: 15, crossAxisSpacing: 15, mainAxisExtent: isTablet ? 320 : 280,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final p = products[index];
                      return _buildProductCard(
                        p['name'] ?? "Unknown", "₹${p['price']}", p['distance'] ?? "Nearby",
                        p['imageUrl'] ?? "https://via.placeholder.com/150",
                        isTablet, isDarkMode, cardColor, textColor, secondaryTextColor,
                      );
                    },
                    childCount: products.length,
                  ),
                ),
              );
            },
          ),
          // PRODUCT GRID
          // SliverPadding(
          //   padding: const EdgeInsets.symmetric(horizontal: 20),
          //   sliver: SliverGrid(
          //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //       crossAxisCount: isTablet ? 4 : 2,
          //       mainAxisSpacing: 15,
          //       crossAxisSpacing: 15,
          //       mainAxisExtent: isTablet ? 320 : 280,
          //     ),
          //     delegate: SliverChildListDelegate([
          //       _buildProductCard("MacBook Pro 2021", "₹75,000", "0.2 km", "https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=400", isTablet, isDarkMode, cardColor, textColor, secondaryTextColor),
          //       _buildProductCard("Ergonomic Chair", "₹4,500", "1.5 km", "https://images.unsplash.com/photo-1592078615290-033ee584e267?w=400", isTablet, isDarkMode, cardColor, textColor, secondaryTextColor),
          //       _buildProductCard("iPhone 13 Pro", "₹62,000", "0.8 km", "https://images.unsplash.com/photo-1632661674596-df8be070a5c5?w=400", isTablet, isDarkMode, cardColor, textColor, secondaryTextColor),
          //       _buildProductCard("Mechanical Keyboard", "₹2,200", "2.1 km", "https://images.unsplash.com/photo-1511467687858-23d96c32e4ae?w=400", isTablet, isDarkMode, cardColor, textColor, secondaryTextColor),
          //       _buildProductCard("Coffee Espresso Machine", "₹8,900", "1.2 km", "https://images.unsplash.com/photo-1517668808822-9ebb02f2a0e6?w=400", isTablet, isDarkMode, cardColor, textColor, secondaryTextColor),
          //       _buildProductCard("Wooden Dining Table", "₹12,000", "3.5 km", "https://images.unsplash.com/photo-1577140917170-285929fb55b7?w=400", isTablet, isDarkMode, cardColor, textColor, secondaryTextColor),
          //       _buildProductCard("Sony Headphones", "₹18,000", "1.1 km", "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400", isTablet, isDarkMode, cardColor, textColor, secondaryTextColor),
          //       _buildProductCard("Indoor Plant Set", "₹950", "0.3 km", "https://images.unsplash.com/photo-1485955900006-10f4d324d411?w=400", isTablet, isDarkMode, cardColor, textColor, secondaryTextColor),
          //       _buildProductCard("Electric Kettle", "₹1,200", "1.8 km", "https://images.unsplash.com/photo-1594212699903-ec8a3eca50f5?w=400", isTablet, isDarkMode, cardColor, textColor, secondaryTextColor),
          //     ]),
          //   ),
          // ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: primaryColor,
        icon: Icon(Icons.add, color: Colors.white, size: isTablet ? 28 : 24),
        label: Text("Create Post", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }

  // --- HELPER METHODS ---

  void _navigateTo(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  Widget _buildProfileAvatar(bool isTablet) {
    return GestureDetector(
      onTap: () => _navigateTo(const ProfileSetupScreen()),
      child: CircleAvatar(
        radius: isTablet ? 24 : 18,
        backgroundColor: const Color(0xFFE2E8F0),
        backgroundImage: const NetworkImage('https://i.pravatar.cc/150?u=9'),
      ),
    );
  }

  Widget _buildSearchBar(Color primary, bool isTablet, bool isDarkMode, Color bg, Color text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        height: isTablet ? 60 : 50,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(15),
          border: isDarkMode ? Border.all(color: Colors.white10) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: TextField(
          style: TextStyle(color: text),
          decoration: InputDecoration(
            hintText: "Search your neighborhood...",
            hintStyle: GoogleFonts.plusJakartaSans(fontSize: isTablet ? 16 : 14, color: isDarkMode ? Colors.white38 : Colors.grey),
            prefixIcon: Icon(Icons.search, color: primary, size: isTablet ? 28 : 24),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildNavIcon(String label, IconData icon, Color color, bool isTablet, bool isDarkMode, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(isTablet ? 20 : 15),
            decoration: BoxDecoration(
              color: color.withOpacity(isDarkMode ? 0.2 : 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: color, size: isTablet ? 32 : 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : const Color(0xFF0F172A))),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String action, bool isTablet, Color text, Color primary, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.plusJakartaSans(fontSize: isTablet ? 22 : 18, fontWeight: FontWeight.w800, color: text)),
          GestureDetector(onTap: onTap, child: Text(action, style: GoogleFonts.plusJakartaSans(color: primary, fontWeight: FontWeight.bold, fontSize: isTablet ? 16 : 14))),
        ],
      ),
    );
  }

  Widget _buildUrgentAlertCard(bool isTablet, bool isDarkMode, Color bg, Color text, Color subText) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red.withOpacity(0.3), width: 1.5),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 30),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Water Supply Outage", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: text)),
                Text("Repairs ongoing in Sector 4 until 8 PM.", style: GoogleFonts.plusJakartaSans(fontSize: 12, color: subText)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalServices(bool isTablet, bool isDarkMode, Color bg, Color text, Color subText) {
    return SizedBox(
      height: isTablet ? 250 : 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 20),
        children: [
          _serviceItem(
            "Electrician",
            "4.8 ★",
            "from ₹299",
            "https://images.unsplash.com/photo-1621905251189-08b45d6a269e?w=200",
            isTablet,
            bg,
            text,
            subText,
                () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ElectricianListScreen()),
              );
            },
          ),
          _serviceItem(
            "Dog Walker",
            "4.9 ★",
            "from ₹150",
            "https://images.unsplash.com/photo-1516733725897-1aa73b87c8e8?w=200",
            isTablet,
            bg,
            text,
            subText,
                () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DogWalkerListScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _serviceItem(
      String name,
      String rate,
      String price,
      String img,
      bool isTablet,
      Color bg,
      Color text,
      Color subText,
      VoidCallback onTap, // Added this parameter
      ) {
    return GestureDetector(
      onTap: onTap, // Added this
      child: Container(
        width: isTablet ? 200 : 160,
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
          // Subtle border for Dark Mode consistency
          border: Theme.of(context).brightness == Brightness.dark
              ? Border.all(color: Colors.white10)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(img, height: isTablet ? 140 : 110, width: double.infinity, fit: BoxFit.cover)
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: text)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(rate, style: const TextStyle(color: Colors.orange, fontSize: 12)),
                      Text(price, style: TextStyle(color: subText, fontSize: 12)),
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

  Widget _buildCategoryChip(String label, bool isSelected, bool isTablet, bool isDarkMode, Color primary) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 24 : 18),
      decoration: BoxDecoration(
        color: isSelected ? primary : (isDarkMode ? const Color(0xFF1E293B) : Colors.white),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isSelected ? primary : (isDarkMode ? Colors.white10 : Colors.transparent)),
      ),
      child: Center(
        child: Text(label, style: GoogleFonts.plusJakartaSans(color: isSelected ? Colors.white : (isDarkMode ? Colors.white70 : const Color(0xFF0F172A)), fontWeight: FontWeight.bold, fontSize: 13)),
      ),
    );
  }

  Widget _buildProductCard(
      String title,
      String price,
      String dist,
      String img,
      bool isTablet,
      bool isDarkMode,
      Color bg,
      Color text,
      Color subText
      ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              title: title,
              price: price,
              distance: dist,
              imageUrl: img,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
          // Adding a slight border in dark mode for better definition
          border: isDarkMode ? Border.all(color: Colors.white10) : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(img, height: isTablet ? 180 : 140, width: double.infinity, fit: BoxFit.cover)
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      title,
                      style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: text, fontSize: isTablet ? 16 : 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis
                  ),
                  const SizedBox(height: 4),
                  Text(
                      price,
                      style: GoogleFonts.plusJakartaSans(color: const Color(0xFF2563EB), fontWeight: FontWeight.w800)
                  ),
                  Text(
                      dist,
                      style: GoogleFonts.plusJakartaSans(color: subText, fontSize: 12)
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttractivePromoCarousel(bool isTablet, bool isDarkMode) {
    return FutureBuilder<List<Promo>>(
      future: _promoFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: isTablet ? 200 : 160,
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.white10 : Colors.black12,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }

        final List<Promo> promos = snapshot.data!;

        return Column(
          children: [
            SizedBox(
              height: isTablet ? 200 : 160,
              child: PageView.builder(
                controller: _promoController,
                itemCount: promos.length,
                itemBuilder: (context, index) {
                  final promo = promos[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: promo.colors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: promo.colors[0].withOpacity(0.3),
                          blurRadius: 1,
                          offset: const Offset(0, 6),
                        )
                      ],
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: -20,
                          bottom: -20,
                          child: Icon(
                            promo.icon,
                            size: isTablet ? 150 : 120,
                            color: Colors.white.withOpacity(0.15),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  promo.tag.toUpperCase(),
                                  style: GoogleFonts.plusJakartaSans(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                promo.title,
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white,
                                  fontSize: isTablet ? 24 : 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                promo.subtitle,
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: isTablet ? 16 : 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // --- CAROUSEL INDICATOR ---
            const SizedBox(height: 8),
            AnimatedBuilder(
              animation: _promoController,
              builder: (context, child) {
                // Determine current page index safely
                int currentPage = 0;
                if (_promoController.hasClients) {
                  currentPage = _promoController.page?.round() ?? 0;
                }

                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(promos.length, (index) {
                    bool isActive = currentPage == index;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width: isActive ? 24 : 8, // Expansion effect for active dot
                      decoration: BoxDecoration(
                        color: isActive
                            ? (isDarkMode ? Colors.white : const Color(0xFF2563EB))
                            : (isDarkMode ? Colors.white24 : Colors.black12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                );
              },
            ),
          ],
        );
      },
    );
  }
}