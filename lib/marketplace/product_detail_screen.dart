import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localink/marketplace/seller_profile_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  final String name;
  final String price;
  final String dist;
  final String img;

  const ProductDetailScreen({
    super.key,
    required this.name,
    required this.price,
    required this.dist,
    required this.img
  });

  @override
  Widget build(BuildContext context) {
    // 1. Detect Screen Type
    final bool isTablet = MediaQuery.of(context).size.width > 600;
    const Color primaryBlue = Color(0xFF2563EB);
    const Color textDark = Color(0xFF0F172A);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 2. ADAPTIVE CONTENT
          isTablet
              ? _buildTabletLayout(context, primaryBlue, textDark)
              : _buildMobileLayout(context, primaryBlue, textDark),

          // 3. TOP NAVIGATION (Always visible)
          _buildTopNav(context, isTablet),

          // 4. BOTTOM ACTION BAR (Mobile only - Tablet has it in sidebar)
          if (!isTablet)
            Align(
              alignment: Alignment.bottomCenter,
              child: _buildBottomBar(primaryBlue, isTablet),
            ),
        ],
      ),
    );
  }

  // --- MOBILE LAYOUT (Original Scroll View) ---
  Widget _buildMobileLayout(BuildContext context, Color primary, Color textDark) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProductImage(400),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: _buildProductInfo(context, primary, textDark, false),
          ),
          const SizedBox(height: 120),
        ],
      ),
    );
  }

  // --- TABLET LAYOUT (Split Screen) ---
  Widget _buildTabletLayout(BuildContext context, Color primary, Color textDark) {
    return Row(
      children: [
        // Left Side: Large Image
        Expanded(
          flex: 5,
          child: _buildProductImage(double.infinity),
        ),
        // Right Side: Scrollable Details
        Expanded(
          flex: 4,
          child: Container(
            padding: const EdgeInsets.fromLTRB(40, 100, 40, 40),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProductInfo(context, primary, textDark, true),
                  const SizedBox(height: 40),
                  // On Tablet, we put the action button inside the scroll view sidebar
                  _buildBottomBar(primary, true),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- SHARED UI COMPONENTS ---

  Widget _buildProductInfo(BuildContext context, Color primary, Color textDark, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(price, style: GoogleFonts.plusJakartaSans(fontSize: isTablet ? 36 : 28, fontWeight: FontWeight.w900, color: primary)),
            _buildDistanceBadge(dist, isTablet),
          ],
        ),
        const SizedBox(height: 12),
        Text(name, style: GoogleFonts.plusJakartaSans(fontSize: isTablet ? 30 : 22, fontWeight: FontWeight.w800, color: textDark)),
        const SizedBox(height: 8),
        Text("Listed 2 hours ago in Greenwood Heights", style: TextStyle(color: Colors.grey[500], fontSize: isTablet ? 15 : 13)),
        const Divider(height: 60),
        Text("Seller Information", style: GoogleFonts.plusJakartaSans(fontSize: isTablet ? 18 : 16, fontWeight: FontWeight.w700)),
        const SizedBox(height: 16),
        _buildSellerCard(context, isTablet),
        const SizedBox(height: 32),
        Text("Description", style: GoogleFonts.plusJakartaSans(fontSize: isTablet ? 18 : 16, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        Text(
          "This $name is in excellent condition. Barely used for 3 months. Original packaging and bill available. Selling because I am moving out of the city.",
          style: GoogleFonts.plusJakartaSans(fontSize: isTablet ? 17 : 15, color: Colors.grey[700], height: 1.6),
        ),
      ],
    );
  }

  Widget _buildProductImage(double height) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(image: NetworkImage(img), fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildTopNav(BuildContext context, bool isTablet) {
    return Positioned(
      top: isTablet ? 40 : 50,
      left: 20,
      right: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _circleIcon(Icons.arrow_back_ios_new, isTablet, () => Navigator.pop(context)),
          _circleIcon(Icons.favorite_border, isTablet, () {}),
        ],
      ),
    );
  }

  Widget _circleIcon(IconData icon, bool isTablet, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(isTablet ? 14 : 10),
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
        child: Icon(icon, size: isTablet ? 24 : 20, color: Colors.black),
      ),
    );
  }

  Widget _buildDistanceBadge(String dist, bool isTablet) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 16 : 12, vertical: isTablet ? 8 : 6),
      decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Icon(Icons.location_on, size: isTablet ? 16 : 14, color: Colors.grey),
          const SizedBox(width: 4),
          Text(dist, style: TextStyle(fontWeight: FontWeight.bold, fontSize: isTablet ? 14 : 12)),
        ],
      ),
    );
  }

  Widget _buildSellerCard(BuildContext context, bool isTablet) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SellerProfileScreen())),
      child: Container(
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF1F5F9)),
        ),
        child: Row(
          children: [
            CircleAvatar(radius: isTablet ? 30 : 25, backgroundImage: const NetworkImage("https://i.pravatar.cc/150?u=seller")),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("Aditya Varma", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: isTablet ? 17 : 15)),
                      const SizedBox(width: 4),
                      Icon(Icons.verified, color: Colors.blue, size: isTablet ? 18 : 14),
                    ],
                  ),
                  Text("Member since 2022 • 4.9 ★", style: TextStyle(color: Colors.grey[500], fontSize: isTablet ? 13 : 11)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey[400], size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(Color primary, bool isTablet) {
    return Container(
      padding: isTablet ? EdgeInsets.zero : const EdgeInsets.fromLTRB(24, 16, 24, 40),
      decoration: BoxDecoration(
        color: isTablet ? Colors.transparent : Colors.white,
        boxShadow: isTablet ? [] : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(isTablet ? 18 : 16),
            decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(16)),
            child: Icon(Icons.share_outlined, size: isTablet ? 24 : 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                padding: EdgeInsets.symmetric(vertical: isTablet ? 22 : 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () {},
              child: Text("Message Seller", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: isTablet ? 16 : 14)),
            ),
          ),
        ],
      ),
    );
  }
}