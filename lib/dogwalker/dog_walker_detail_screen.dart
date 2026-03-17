import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DogWalkerDetailScreen extends StatelessWidget {
  const DogWalkerDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF2563EB);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Visual
                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage("https://images.unsplash.com/photo-1516733725897-1aa73b87c8e8?w=800"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Sarah Jenkins", style: GoogleFonts.plusJakartaSans(fontSize: 26, fontWeight: FontWeight.w800)),
                          const Icon(Icons.verified, color: Colors.blue, size: 28),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text("Greenwood Heights, Brooklyn", style: TextStyle(color: Colors.grey[600])),
                      const SizedBox(height: 24),

                      // Stats Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStat("4.9", "Rating"),
                          _buildStat("128", "Walks"),
                          _buildStat("5 yrs", "Exp"),
                        ],
                      ),

                      const SizedBox(height: 32),
                      Text("About Me", style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 12),
                      Text(
                        "I've been a dog lover all my life. I specialize in high-energy breeds that need long runs, but I'm just as happy strolling with seniors. CPR certified and fully insured.",
                        style: GoogleFonts.plusJakartaSans(fontSize: 15, color: Colors.grey[700], height: 1.6),
                      ),

                      const SizedBox(height: 32),
                      Text("Safety First", style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 12),
                      _buildSafetyBadge("Background Checked"),
                      _buildSafetyBadge("Pet CPR Certified"),

                      const SizedBox(height: 120),
                    ],
                  ),
                )
              ],
            ),
          ),

          // Persistent Booking Bar
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)],
              ),
              child: Row(
                children: [
                  const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("₹150", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: primaryBlue)),
                      Text("per hour", style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () {},
                      child: const Text("Book Sarah", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  )
                ],
              ),
            ),
          ),

          // Back Button
          Positioned(top: 50, left: 20, child: CircleAvatar(backgroundColor: Colors.white, child: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.pop(context)))),
        ],
      ),
    );
  }

  Widget _buildStat(String val, String label) {
    return Column(
      children: [
        Text(val, style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w800)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildSafetyBadge(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 20),
          const SizedBox(width: 10),
          Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}