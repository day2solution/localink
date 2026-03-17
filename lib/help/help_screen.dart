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
    // 1. Detect Screen Type
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: isTablet,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: const Color(0xFF0F172A), size: isTablet ? 24 : 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Community Help",
          style: GoogleFonts.plusJakartaSans(
            color: const Color(0xFF0F172A),
            fontWeight: FontWeight.w800,
            fontSize: isTablet ? 24 : 20,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list_rounded, color: const Color(0xFF0F172A), size: isTablet ? 28 : 24),
            onPressed: () {},
          ),
          if (isTablet) const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          // --- TAB SWITCHER ---
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: primaryBlue,
              unselectedLabelColor: Colors.grey,
              indicatorColor: primaryBlue,
              indicatorWeight: 3,
              labelStyle: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                fontSize: isTablet ? 16 : 14, // Scaled Tab Font
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
                _buildResponsiveHelpFeed(isTablet, screenWidth),
                Center(child: Text("No active requests by you", style: TextStyle(fontSize: isTablet ? 18 : 14))),
              ],
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showRequestHelpBottomSheet(context, isTablet),
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

  // 2. Responsive Help Feed using Slivers
  Widget _buildResponsiveHelpFeed(bool isTablet, double screenWidth) {
    int crossAxisCount = screenWidth > 900 ? 3 : (isTablet ? 2 : 1);

    return CustomScrollView(
      slivers: [
        // Categories Section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: _buildCategoryIcons(isTablet),
          ),
        ),

        // Urgent Requests Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Urgent Requests",
              style: GoogleFonts.plusJakartaSans(
                  fontSize: isTablet ? 22 : 18,
                  fontWeight: FontWeight.w800
              ),
            ),
          ),
        ),

        // Help Cards Grid/List
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              mainAxisExtent: isTablet ? 210 : 190, // Fixed height to prevent stretching
            ),
            delegate: SliverChildListDelegate([
              _buildHelpCard("Need a Jump Start", "Car battery died near the park. Have cables, just need a car!", "High", "0.2 km away", "https://i.pravatar.cc/150?u=1", isTablet),
              _buildHelpCard("Tool Borrow: Power Drill", "Need to hang some shelves this afternoon. Will return by 6PM.", "Low", "0.8 km away", "https://i.pravatar.cc/150?u=2", isTablet),
              _buildHelpCard("Help Moving Sofa", "Just need 10 mins of help to carry a sofa to the 2nd floor.", "Medium", "1.2 km away", "https://i.pravatar.cc/150?u=3", isTablet),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryIcons(bool isTablet) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _categoryItem("Elderly Care", Icons.elderly, Colors.blue, isTablet),
        _categoryItem("Tools", Icons.build_rounded, Colors.blueGrey, isTablet),
        _categoryItem("Pet Care", Icons.pets_rounded, Colors.orange, isTablet),
        _categoryItem("Moving", Icons.local_shipping_rounded, Colors.purple, isTablet),
      ],
    );
  }

  Widget _categoryItem(String label, IconData icon, Color color, bool isTablet) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(isTablet ? 16 : 12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(icon, color: color, size: isTablet ? 32 : 26),
        ),
        const SizedBox(height: 8),
        Text(label, style: GoogleFonts.plusJakartaSans(fontSize: isTablet ? 13 : 11, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildHelpCard(String title, String desc, String urgency, String dist, String img, bool isTablet) {
    Color urgencyColor = urgency == "High" ? Colors.red : (urgency == "Medium" ? Colors.orange : Colors.green);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))],
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
                    Text(title, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: isTablet ? 17 : 15)),
                    Text(dist, style: GoogleFonts.plusJakartaSans(fontSize: isTablet ? 13 : 11, color: Colors.grey)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: urgencyColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Text(urgency, style: TextStyle(color: urgencyColor, fontSize: isTablet ? 12 : 10, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Text(
              desc,
              style: GoogleFonts.plusJakartaSans(fontSize: isTablet ? 14 : 13, color: const Color(0xFF475569), height: 1.4),
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

  void _showRequestHelpBottomSheet(BuildContext context, bool isTablet) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Align( // CHANGED: Use Align instead of Center
        alignment: Alignment.bottomCenter, // CHANGED: Force to bottom
        child: Container(
          constraints: BoxConstraints(
            maxWidth: isTablet ? 500 : double.infinity,
          ),
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          padding: EdgeInsets.all(isTablet ? 35 : 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
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
                ),
              ),
              const SizedBox(height: 20),
              _buildSheetField("Short Title", "e.g. Need help with groceries", isTablet),
              const SizedBox(height: 15),
              _buildSheetField("Description", "Describe what you need in detail...", isTablet, maxLines: 4),
              const SizedBox(height: 25),
              Text(
                "Urgency Level",
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700,
                  fontSize: isTablet ? 16 : 14,
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

  Widget _buildSheetField(String label, String hint, bool isTablet, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: isTablet ? 15 : 14)),
        const SizedBox(height: 8),
        TextField(
          maxLines: maxLines,
          style: TextStyle(fontSize: isTablet ? 16 : 14),
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  Widget _urgencyChip(String label, Color color, bool isTablet) {
    return Container(
      width: isTablet ? 140 : 100, // Wider for tablets
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Center(child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: isTablet ? 15 : 13))),
    );
  }
}