import 'package:flutter/material.dart';

class AppIcon extends StatelessWidget {
  final double size;
  final bool showShadow;
  final String? heroTag;
  final bool isCircle;
  final IconData? icon;
  final double? borderRadius;
  final bool responsive; // New: Automatically scales for Tablets

  const AppIcon({
    super.key,
    this.size = 100,
    this.showShadow = true,
    this.heroTag = 'app_logo',
    this.isCircle = false,
    this.icon,
    this.borderRadius,
    this.responsive = true, // Default to true
  });

  @override
  Widget build(BuildContext context) {
    // 1. Detect Screen Type
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 600;

    // 2. Calculate Responsive Size
    // If responsive is true and it's a tablet, we scale up by 20%
    final double effectiveSize = (responsive && isTablet) ? size * 1.2 : size;

    final boxShape = isCircle ? BoxShape.circle : BoxShape.rectangle;

    // 3. Proportional Internal Scaling
    final double mainIconSize = effectiveSize * 0.45;
    final double bgIconSize = effectiveSize * 0.65;
    final double effectiveRadius = borderRadius ?? (effectiveSize * 0.25);

    Widget iconContent = Material( // Added Material to ensure correct icon rendering
      color: Colors.transparent,
      child: Container(
        width: effectiveSize,
        height: effectiveSize,
        decoration: BoxDecoration(
          shape: boxShape,
          borderRadius: isCircle ? null : BorderRadius.circular(effectiveRadius),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2563EB), // Modern Royal Blue
              Color(0xFF7C3AED), // Premium Purple
            ],
          ),
          boxShadow: showShadow
              ? [
            BoxShadow(
              color: const Color(0xFF2563EB).withOpacity(0.25),
              // Shadow depth scales with device type
              blurRadius: isTablet ? effectiveSize * 0.25 : effectiveSize * 0.2,
              offset: Offset(0, effectiveSize * 0.1),
              spreadRadius: isTablet ? 2 : 0,
            ),
          ]
              : null,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Subtle background decoration
            Icon(
              Icons.location_on_rounded,
              size: bgIconSize,
              color: Colors.white.withOpacity(0.15),
            ),
            // Main Branding Icon
            Icon(
              icon ?? Icons.link_rounded,
              size: mainIconSize,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );

    // Semantics for accessibility
    iconContent = Semantics(
      label: "LocaLink App Logo",
      child: iconContent,
    );

    if (heroTag != null) {
      return Hero(
        tag: heroTag!,
        transitionOnUserGestures: true, // Smoother back-swipes
        child: iconContent,
      );
    }

    return iconContent;
  }
}