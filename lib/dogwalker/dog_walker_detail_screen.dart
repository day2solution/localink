import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DogWalkerDetailScreen extends StatelessWidget {
  const DogWalkerDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. THEME & RESPONSIVE DETECTION
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 600;

    // 2. DYNAMIC COLOR PALETTE
    const Color primaryBlue = Color(0xFF2563EB);
    final Color textColor = isDarkMode ? Colors.white : const Color(0xFF0F172A);
    final Color cardColor = isDarkMode ? const Color(0xFF1E293B) : Colors.white;
    final Color scaffoldBg = isDarkMode ? const Color(0xFF0F172A) : Colors.white;
    final Color subTextColor = isDarkMode ? const Color(0xFF94A3B8) : Colors.grey[700]!;

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- TOP VISUAL (Adaptive Height) ---
                Container(
                  height: isTablet ? 450 : 320,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage("https://images.unsplash.com/photo-1516733725897-1aa73b87c8e8?w=800"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // --- CONTENT SECTION (Centered for Tablets) ---
                Center(
                  child: Container(
                    constraints: BoxConstraints(maxWidth: isTablet ? 700 : double.infinity),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "Sarah Jenkins",
                                style: GoogleFonts.plusJakartaSans(
                                    fontSize: isTablet ? 32 : 26,
                                    fontWeight: FontWeight.w800,
                                    color: textColor
                                )
                            ),
                            const Icon(Icons.verified, color: primaryBlue, size: 28),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                            "Greenwood Heights, Brooklyn",
                            style: TextStyle(color: isDarkMode ? Colors.white54 : Colors.grey[600])
                        ),
                        const SizedBox(height: 24),

                        // --- STATS ROW (Themed Card) ---
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(20),
                            border: isDarkMode ? Border.all(color: Colors.white10) : Border.all(color: const Color(0xFFF1F5F9)),
                            boxShadow: isDarkMode ? null : [
                              BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStat("4.9", "Rating", textColor),
                              _buildStat("128", "Walks", textColor),
                              _buildStat("5 yrs", "Exp", textColor),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),
                        Text("About Me", style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w800, color: textColor)),
                        const SizedBox(height: 12),
                        Text(
                          "I've been a dog lover all my life. I specialize in high-energy breeds that need long runs, but I'm just as happy strolling with seniors. CPR certified and fully insured.",
                          style: GoogleFonts.plusJakartaSans(fontSize: 15, color: subTextColor, height: 1.6),
                        ),

                        const SizedBox(height: 32),
                        Text("Safety First", style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w800, color: textColor)),
                        const SizedBox(height: 12),
                        _buildSafetyBadge("Background Checked", textColor),
                        _buildSafetyBadge("Pet CPR Certified", textColor),

                        const SizedBox(height: 140), // Space for bottom bar
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),

          // --- PERSISTENT BOOKING BAR (Themed) ---
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.fromLTRB(24, 16, 24, isTablet ? 24 : 40),
              decoration: BoxDecoration(
                color: cardColor,
                border: Border(top: BorderSide(color: isDarkMode ? Colors.white10 : Colors.black12)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1), blurRadius: 20)
                ],
              ),
              child: Row(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("₹150", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: primaryBlue)),
                      Text("per hour", style: TextStyle(fontSize: 12, color: isDarkMode ? Colors.white54 : Colors.grey)),
                    ],
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      onPressed: () {},
                      child: const Text("Book Sarah", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  )
                ],
              ),
            ),
          ),

          // --- BACK BUTTON ---
          Positioned(
              top: 50,
              left: 20,
              child: CircleAvatar(
                  backgroundColor: cardColor,
                  child: IconButton(
                      icon: Icon(Icons.arrow_back, color: textColor, size: 20),
                      onPressed: () => Navigator.pop(context)
                  )
              )
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String val, String label, Color textColor) {
    return Column(
      children: [
        Text(val, style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.w800, color: textColor)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildSafetyBadge(String text, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 22),
          const SizedBox(width: 12),
          Text(text, style: TextStyle(fontWeight: FontWeight.w600, color: textColor, fontSize: 15)),
        ],
      ),
    );
  }
}