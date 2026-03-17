import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ElectricianDetailScreen extends StatelessWidget {
  const ElectricianDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF2563EB);
    const Color textDark = Color(0xFF0F172A);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. TOP IMAGE HEADER
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageHeader(),

                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 2. TITLE & BADGE
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "Expert Electrical Repairs & Wiring",
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: textDark,
                              ),
                            ),
                          ),
                          _buildPriceBadge("₹299", "Visit Fee"),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // 3. PRO INFO ROW
                      _buildProInfoRow(primaryBlue),

                      const SizedBox(height: 32),

                      // 4. DESCRIPTION
                      Text(
                        "About the Service",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: textDark,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Professional electrical services for your home. We handle everything from short circuit repairs, ceiling fan installations, to full house wiring. All our electricians are certified and follow safety protocols.",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          color: Colors.grey[600],
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // 5. WHAT'S INCLUDED (BENTO STYLE)
                      Text(
                        "What's Included",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildIncludedGrid(),

                      const SizedBox(height: 120), // Padding for Bottom Bar
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 6. BACK BUTTON
          Positioned(
            top: 50,
            left: 20,
            child: _buildCircularButton(Icons.arrow_back_ios_new, () => Navigator.pop(context)),
          ),

          // 7. BOTTOM ACTION BAR
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildBottomActionBar(primaryBlue),
          ),
        ],
      ),
    );
  }

  // --- UI HELPER WIDGETS ---

  Widget _buildImageHeader() {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage("https://images.unsplash.com/photo-1621905251189-08b45d6a269e?w=800"),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withOpacity(0.7), Colors.transparent],
          ),
        ),
      ),
    );
  }

  Widget _buildProInfoRow(Color primary) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage("https://i.pravatar.cc/150?u=12"),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text("Rajesh Kumar", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
                const SizedBox(width: 4),
                const Icon(Icons.verified, color: Colors.blue, size: 14),
              ],
            ),
            Text("10+ Years Experience", style: TextStyle(fontSize: 12, color: Colors.grey[500])),
          ],
        ),
        const Spacer(),
        _buildStat("4.8", Icons.star, Colors.orange),
      ],
    );
  }

  Widget _buildStat(String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 4),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildPriceBadge(String price, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(price, style: GoogleFonts.plusJakartaSans(fontSize: 22, fontWeight: FontWeight.w900, color: const Color(0xFF2563EB))),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  Widget _buildIncludedGrid() {
    final List<String> items = ["Safety Check", "Internal Wiring", "Component Repair", "Post-work Cleanup"];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 3.5,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 16),
              const SizedBox(width: 8),
              Text(items[index], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCircularButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Icon(icon, size: 18),
      ),
    );
  }

  Widget _buildBottomActionBar(Color primary) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))],
      ),
      child: Row(
        children: [
          _buildActionButton(Icons.chat_bubble_outline, "Chat", Colors.grey[200]!, Colors.black),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              onPressed: () {},
              child: Text("Book Now", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color bg, Color text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Icon(icon, size: 20, color: text),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(color: text, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}