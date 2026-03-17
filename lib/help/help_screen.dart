import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Color helpAccent = const Color(0xFFF59E0B);
  final Color primaryBlue = const Color(0xFF2563EB);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    // 1. Detect Screen Type & Theme
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 600;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // 2. Dynamic Theme Colors
    final Color scaffoldBg = isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final Color cardColor = isDarkMode ? const Color(0xFF1E293B) : Colors.white;
    final Color textColor = isDarkMode ? Colors.white : const Color(0xFF0F172A);
    final Color subTextColor = isDarkMode ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 0,
        centerTitle: isTablet,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textColor, size: isTablet ? 24 : 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Community Help",
          style: GoogleFonts.plusJakartaSans(
            color: textColor,
            fontWeight: FontWeight.w800,
            fontSize: isTablet ? 24 : 20,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list_rounded, color: textColor, size: isTablet ? 28 : 24),
            onPressed: () {},
          ),
          if (isTablet) const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          // --- TAB SWITCHER ---
          Container(
            color: cardColor,
            child: TabBar(
              controller: _tabController,
              labelColor: primaryBlue,
              unselectedLabelColor: subTextColor,
              indicatorColor: primaryBlue,
              indicatorWeight: 3,
              labelStyle: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                fontSize: isTablet ? 16 : 14,
              ),
              tabs: const [
                Tab(text: "Nearby Requests"),
                Tab(text: "My Requests"),
              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildResponsiveHelpFeed(isTablet, screenWidth, isDarkMode, cardColor, textColor, subTextColor),
                Center(
                    child: Text(
                        "No active requests by you",
                        style: TextStyle(fontSize: isTablet ? 18 : 14, color: subTextColor)
                    )
                ),
              ],
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showRequestHelpBottomSheet(context, isTablet, isDarkMode, cardColor, textColor, scaffoldBg),
        backgroundColor: helpAccent,
        icon: Icon(Icons.handshake_rounded, color: Colors.white, size: isTablet ? 28 : 24),
        label: Text("Request Help",
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: isTablet ? 16 : 14,
            )),
      ),
    );
  }

  Widget _buildResponsiveHelpFeed(bool isTablet, double screenWidth, bool isDarkMode, Color cardColor, Color textColor, Color subTextColor) {
    int crossAxisCount = screenWidth > 900 ? 3 : (isTablet ? 2 : 1);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: _buildCategoryIcons(isTablet, textColor),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Urgent Requests",
              style: GoogleFonts.plusJakartaSans(
                  fontSize: isTablet ? 22 : 18,
                  fontWeight: FontWeight.w800,
                  color: textColor
              ),
            ),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              mainAxisExtent: isTablet ? 220 : 200,
            ),
            delegate: SliverChildListDelegate([
              _buildHelpCard("Need a Jump Start", "Car battery died near the park. Have cables, just need a car!", "High", "0.2 km away", "https://i.pravatar.cc/150?u=1", isTablet, isDarkMode, cardColor, textColor, subTextColor),
              _buildHelpCard("Tool Borrow: Power Drill", "Need to hang some shelves this afternoon. Will return by 6PM.", "Low", "0.8 km away", "https://i.pravatar.cc/150?u=2", isTablet, isDarkMode, cardColor, textColor, subTextColor),
              _buildHelpCard("Help Moving Sofa", "Just need 10 mins of help to carry a sofa to the 2nd floor.", "Medium", "1.2 km away", "https://i.pravatar.cc/150?u=3", isTablet, isDarkMode, cardColor, textColor, subTextColor),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryIcons(bool isTablet, Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _categoryItem("Elderly Care", Icons.elderly, Colors.blue, isTablet, textColor),
        _categoryItem("Tools", Icons.build_rounded, Colors.blueGrey, isTablet, textColor),
        _categoryItem("Pet Care", Icons.pets_rounded, Colors.orange, isTablet, textColor),
        _categoryItem("Moving", Icons.local_shipping_rounded, Colors.purple, isTablet, textColor),
      ],
    );
  }

  Widget _categoryItem(String label, IconData icon, Color color, bool isTablet, Color textColor) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(isTablet ? 16 : 12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(icon, color: color, size: isTablet ? 32 : 26),
        ),
        const SizedBox(height: 8),
        Text(label, style: GoogleFonts.plusJakartaSans(fontSize: isTablet ? 13 : 11, fontWeight: FontWeight.w600, color: textColor)),
      ],
    );
  }

  Widget _buildHelpCard(String title, String desc, String urgency, String dist, String img, bool isTablet, bool isDarkMode, Color cardBg, Color textColor, Color subTextColor) {
    Color urgencyColor = urgency == "High" ? Colors.red : (urgency == "Medium" ? Colors.orange : Colors.green);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isDarkMode ? null : [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))],
        border: isDarkMode ? Border.all(color: Colors.white10) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(backgroundImage: NetworkImage(img), radius: isTablet ? 22 : 18),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: isTablet ? 17 : 15, color: textColor)),
                    Text(dist, style: GoogleFonts.plusJakartaSans(fontSize: isTablet ? 13 : 11, color: subTextColor)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: urgencyColor.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                child: Text(urgency, style: TextStyle(color: urgencyColor, fontSize: isTablet ? 12 : 10, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Text(
              desc,
              style: GoogleFonts.plusJakartaSans(fontSize: isTablet ? 14 : 13, color: isDarkMode ? Colors.white70 : const Color(0xFF475569), height: 1.4),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: primaryBlue),
                    padding: EdgeInsets.symmetric(vertical: isTablet ? 12 : 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text("Message", style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold, fontSize: isTablet ? 14 : 12)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: isTablet ? 12 : 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text("Offer Help", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: isTablet ? 14 : 12)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _showRequestHelpBottomSheet(BuildContext context, bool isTablet, bool isDarkMode, Color cardBg, Color textColor, Color fieldBg) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: isTablet ? 500 : double.infinity,
          ),
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          padding: EdgeInsets.all(isTablet ? 35 : 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.white24 : Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Text(
                "How can neighbors help?",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: isTablet ? 26 : 22,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 20),
              _buildSheetField("Short Title", "e.g. Need help with groceries", isTablet, isDarkMode, textColor, fieldBg),
              const SizedBox(height: 15),
              _buildSheetField("Description", "Describe what you need in detail...", isTablet, isDarkMode, textColor, fieldBg, maxLines: 4),
              const SizedBox(height: 25),
              Text(
                "Urgency Level",
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700,
                  fontSize: isTablet ? 16 : 14,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _urgencyChip("Low", Colors.green, isTablet),
                  _urgencyChip("Medium", Colors.orange, isTablet),
                  _urgencyChip("High", Colors.red, isTablet),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Post Request",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: isTablet ? 16 : 14,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSheetField(String label, String hint, bool isTablet, bool isDarkMode, Color textColor, Color fieldBg, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: isTablet ? 15 : 14, color: textColor)),
        const SizedBox(height: 8),
        TextField(
          maxLines: maxLines,
          style: TextStyle(fontSize: isTablet ? 16 : 14, color: textColor),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: isDarkMode ? Colors.white38 : Colors.grey),
            filled: true,
            fillColor: isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  Widget _urgencyChip(String label, Color color, bool isTablet) {
    return Container(
      width: isTablet ? 140 : 100,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Center(child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: isTablet ? 15 : 13))),
    );
  }
}