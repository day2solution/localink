import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SellItemScreen extends StatefulWidget {
  const SellItemScreen({super.key});

  @override
  State<SellItemScreen> createState() => _SellItemScreenState();
}

class _SellItemScreenState extends State<SellItemScreen> {
  final Color primaryBlue = const Color(0xFF2563EB);
  String _selectedCondition = "Used";

  @override
  Widget build(BuildContext context) {
    // 1. Detect Screen Type & Theme
    final bool isTablet = MediaQuery.of(context).size.width > 600;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // 2. Dynamic Colors
    final Color scaffoldBg = isDarkMode ? const Color(0xFF0F172A) : Colors.white;
    final Color cardColor = isDarkMode ? const Color(0xFF1E293B) : Colors.white;
    final Color textColor = isDarkMode ? Colors.white : const Color(0xFF0F172A);
    final Color inputFill = isDarkMode ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC);
    final Color borderColor = isDarkMode ? Colors.white10 : const Color(0xFFE2E8F0);
    final Color subTextColor = isDarkMode ? const Color(0xFF94A3B8) : Colors.grey;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: scaffoldBg,
        elevation: 0,
        centerTitle: isTablet,
        leading: IconButton(
          icon: Icon(Icons.close, color: textColor, size: isTablet ? 28 : 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "List an Item",
          style: GoogleFonts.plusJakartaSans(
            color: textColor,
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
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: isTablet ? 600 : double.infinity),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: isTablet ? 40 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                // 1. IMAGE PICKER
                _buildLabel("Add Photos", isTablet, textColor),
                const SizedBox(height: 12),
                _buildImageUploadRow(isTablet, isDarkMode, primaryBlue, borderColor),
                const SizedBox(height: 8),
                Text(
                  "Add up to 5 photos. High quality photos sell faster.",
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: isTablet ? 13 : 11,
                      color: subTextColor
                  ),
                ),

                const SizedBox(height: 32),

                // 2. ITEM DETAILS
                _buildLabel("Item Title", isTablet, textColor),
                _buildInputField("e.g. MacBook Pro 2021", Icons.title, isTablet, isDarkMode, inputFill, textColor, borderColor),

                const SizedBox(height: 20),

                _buildLabel("Price", isTablet, textColor),
                _buildInputField("₹ 0.00", Icons.currency_rupee, isTablet, isDarkMode, inputFill, textColor, borderColor, keyboardType: TextInputType.number),

                const SizedBox(height: 20),

                _buildLabel("Category", isTablet, textColor),
                _buildDropdownField("Select Category", Icons.category_outlined, isTablet, isDarkMode, inputFill, textColor, borderColor),

                const SizedBox(height: 20),

                // 3. CONDITION
                _buildLabel("Condition", isTablet, textColor),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _conditionChip("New", isTablet, isDarkMode, borderColor),
                    _conditionChip("Used", isTablet, isDarkMode, borderColor),
                    _conditionChip("Refurbished", isTablet, isDarkMode, borderColor),
                  ],
                ),

                const SizedBox(height: 24),

                _buildLabel("Description", isTablet, textColor),
                _buildInputField("Describe features...", Icons.description_outlined, isTablet, isDarkMode, inputFill, textColor, borderColor, maxLines: 4),

                const SizedBox(height: 24),

                // 4. LOCATION PREVIEW
                Container(
                  padding: EdgeInsets.all(isTablet ? 20 : 16),
                  decoration: BoxDecoration(
                    color: inputFill,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.location_on, color: primaryBlue, size: isTablet ? 24 : 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Pickup Location", style: GoogleFonts.plusJakartaSans(fontSize: isTablet ? 14 : 12, color: subTextColor)),
                            Text("Greenwood Heights, Brooklyn", style: GoogleFonts.plusJakartaSans(fontSize: isTablet ? 16 : 14, fontWeight: FontWeight.w700, color: textColor)),
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

  Widget _buildLabel(String label, bool isTablet, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            fontSize: isTablet ? 16 : 14,
            color: textColor
        ),
      ),
    );
  }

  Widget _buildImageUploadRow(bool isTablet, bool isDarkMode, Color primary, Color border) {
    double size = isTablet ? 100 : 80;
    return Row(
      children: [
        Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.white.withOpacity(0.05) : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: border),
          ),
          child: Icon(Icons.add_a_photo_outlined, color: primary, size: isTablet ? 28 : 24),
        ),
        const SizedBox(width: 12),
        Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
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

  Widget _buildInputField(String hint, IconData icon, bool isTablet, bool isDarkMode, Color fill, Color textColor, Color border, {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: TextStyle(fontSize: isTablet ? 16 : 14, color: textColor),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.plusJakartaSans(color: isDarkMode ? Colors.white24 : Colors.grey[400], fontSize: isTablet ? 15 : 14),
        prefixIcon: Icon(icon, color: isDarkMode ? Colors.white38 : Colors.grey[400], size: isTablet ? 24 : 20),
        filled: true,
        fillColor: fill,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryBlue, width: 2),
        ),
      ),
    );
  }

  Widget _buildDropdownField(String hint, IconData icon, bool isTablet, bool isDarkMode, Color fill, Color textColor, Color border) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          dropdownColor: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
          hint: Row(
            children: [
              Icon(icon, color: isDarkMode ? Colors.white38 : Colors.grey[400], size: isTablet ? 24 : 20),
              const SizedBox(width: 12),
              Text(hint, style: GoogleFonts.plusJakartaSans(color: isDarkMode ? Colors.white24 : Colors.grey[400], fontSize: isTablet ? 15 : 14)),
            ],
          ),
          isExpanded: true,
          items: ["Electronics", "Furniture", "Vehicles", "Hobby"].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: TextStyle(fontSize: isTablet ? 16 : 14, color: textColor)),
            );
          }).toList(),
          onChanged: (_) {},
        ),
      ),
    );
  }

  Widget _conditionChip(String label, bool isTablet, bool isDarkMode, Color border) {
    bool isSelected = _selectedCondition == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedCondition = label),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 24 : 16,
            vertical: isTablet ? 14 : 10
        ),
        decoration: BoxDecoration(
          color: isSelected ? primaryBlue : (isDarkMode ? Colors.transparent : Colors.white),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? primaryBlue : border),
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: isTablet ? 14 : 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : (isDarkMode ? Colors.white70 : const Color(0xFF64748B)),
          ),
        ),
      ),
    );
  }
}