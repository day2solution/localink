import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SellItemScreen extends StatefulWidget {
  const SellItemScreen({super.key});

  @override
  State<SellItemScreen> createState() => _SellItemScreenState();
}

class _SellItemScreenState extends State<SellItemScreen> {
  final Color primaryBlue = const Color(0xFF2563EB);
  final Color textDark = const Color(0xFF0F172A);

  String _selectedCondition = "Used"; // Default

  @override
  Widget build(BuildContext context) {
    // 1. Detect Screen Type
    final bool isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: isTablet,
        leading: IconButton(
          icon: Icon(Icons.close, color: textDark, size: isTablet ? 28 : 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "List an Item",
          style: GoogleFonts.plusJakartaSans(
            color: textDark,
            fontWeight: FontWeight.w800,
            fontSize: isTablet ? 22 : 18,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text("Save Draft",
                style: TextStyle(
                    color: primaryBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: isTablet ? 16 : 14
                )
            ),
          ),
          if (isTablet) const SizedBox(width: 10),
        ],
      ),
      body: Center( // Center content on tablets
        child: Container(
          // LIMIT WIDTH ON TABLETS for better readability
          constraints: BoxConstraints(maxWidth: isTablet ? 600 : double.infinity),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: isTablet ? 40 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                // 1. IMAGE PICKER SECTION
                Text(
                  "Add Photos",
                  style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w700,
                      fontSize: isTablet ? 16 : 14
                  ),
                ),
                const SizedBox(height: 12),
                _buildImageUploadRow(isTablet),
                const SizedBox(height: 8),
                Text(
                  "Add up to 5 photos. High quality photos sell faster.",
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: isTablet ? 13 : 11,
                      color: Colors.grey
                  ),
                ),

                const SizedBox(height: 32),

                // 2. ITEM DETAILS
                _buildLabel("Item Title", isTablet),
                _buildInputField("e.g. MacBook Pro 2021", Icons.title, isTablet),

                const SizedBox(height: 20),

                _buildLabel("Price", isTablet),
                _buildInputField("₹ 0.00", Icons.currency_rupee, isTablet, keyboardType: TextInputType.number),

                const SizedBox(height: 20),

                _buildLabel("Category", isTablet),
                _buildDropdownField("Select Category", Icons.category_outlined, isTablet),

                const SizedBox(height: 20),

                // 3. CONDITION CHIPS
                _buildLabel("Condition", isTablet),
                Wrap( // Use wrap instead of Row to handle small tablets
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _conditionChip("New", isTablet),
                    _conditionChip("Used", isTablet),
                    _conditionChip("Refurbished", isTablet),
                  ],
                ),

                const SizedBox(height: 24),

                _buildLabel("Description", isTablet),
                _buildInputField("Describe features, defects, age...", Icons.description_outlined, isTablet, maxLines: 4),

                const SizedBox(height: 24),

                // 4. LOCATION PREVIEW
                Container(
                  padding: EdgeInsets.all(isTablet ? 20 : 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.location_on, color: primaryBlue, size: isTablet ? 24 : 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Pickup Location", style: GoogleFonts.plusJakartaSans(fontSize: isTablet ? 14 : 12, color: Colors.grey[600])),
                            Text("Greenwood Heights, Brooklyn", style: GoogleFonts.plusJakartaSans(fontSize: isTablet ? 16 : 14, fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                      Text("Change", style: TextStyle(color: primaryBlue, fontSize: isTablet ? 14 : 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // 5. PUBLISH BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    onPressed: () {},
                    child: Text(
                      "Post My Listing",
                      style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: Colors.white, fontSize: isTablet ? 18 : 16),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildLabel(String label, bool isTablet) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            fontSize: isTablet ? 16 : 14,
            color: textDark
        ),
      ),
    );
  }

  Widget _buildImageUploadRow(bool isTablet) {
    double size = isTablet ? 100 : 80;
    return Row(
      children: [
        Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFCBD5E1)),
          ),
          child: Icon(Icons.add_a_photo_outlined, color: primaryBlue, size: isTablet ? 28 : 24),
        ),
        const SizedBox(width: 12),
        Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(16),
            image: const DecorationImage(
              image: NetworkImage("https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=200"),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField(String hint, IconData icon, bool isTablet, {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: TextStyle(fontSize: isTablet ? 16 : 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.plusJakartaSans(color: Colors.grey[400], fontSize: isTablet ? 15 : 14),
        prefixIcon: Icon(icon, color: Colors.grey[400], size: isTablet ? 24 : 20),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryBlue, width: 2),
        ),
      ),
    );
  }

  Widget _buildDropdownField(String hint, IconData icon, bool isTablet) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Row(
            children: [
              Icon(icon, color: Colors.grey[400], size: isTablet ? 24 : 20),
              const SizedBox(width: 12),
              Text(hint, style: GoogleFonts.plusJakartaSans(color: Colors.grey[400], fontSize: isTablet ? 15 : 14)),
            ],
          ),
          isExpanded: true,
          items: ["Electronics", "Furniture", "Vehicles", "Hobby"].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: TextStyle(fontSize: isTablet ? 16 : 14)),
            );
          }).toList(),
          onChanged: (_) {},
        ),
      ),
    );
  }

  Widget _conditionChip(String label, bool isTablet) {
    bool isSelected = _selectedCondition == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedCondition = label),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 24 : 16,
            vertical: isTablet ? 14 : 10
        ),
        decoration: BoxDecoration(
          color: isSelected ? primaryBlue : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? primaryBlue : const Color(0xFFE2E8F0)),
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: isTablet ? 14 : 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }
}