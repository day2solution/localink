import 'package:flutter/material.dart';

class Promo {
  final String title;
  final String subtitle;
  final String tag;
  final IconData icon;
  final List<Color> colors;

  Promo({
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.icon,
    required this.colors,
  });

  // Factory method to create a Promo object from a Map
  factory Promo.fromJson(Map<String, dynamic> json, IconData iconData, List<Color> gradientColors) {
    return Promo(
      title: json['title']?.toString() ?? "No Title",
      subtitle: json['subtitle']?.toString() ?? "",
      tag: json['tag']?.toString() ?? "OFFER",
      icon: iconData, // Passed from the helper in ApiService
      colors: gradientColors, // Passed from the randomizer in ApiService
    );
  }

  // Method to convert a Promo object to a Map (if needed for POST requests)
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'tag': tag,
      // Note: IconData and Color are not standard JSON types,
      // so you'd typically store their string names or hex codes in a real DB.
    };
  }
}