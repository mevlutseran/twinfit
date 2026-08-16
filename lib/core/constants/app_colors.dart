import 'package:flutter/material.dart';

class AppColors {
  // Brand & Accent Colors (Linear & Cyber Aesthetic)
  static const Color primary = Color(0xFF00F59B);       // Cyber / Neon Green (Growth & Peak)
  static const Color primaryGlow = Color(0x3300F59B);
  static const Color secondary = Color(0xFF00D2FF);     // Electric Cyan (AI & Realtime)
  static const Color secondaryGlow = Color(0x3300D2FF);
  static const Color accent = Color(0xFF8A2BE2);        // Cyber Purple (AI Highlights)
  static const Color accentGlow = Color(0x338A2BE2);

  // Vitality & Biomechanical Colors (Apple Health Aesthetic)
  static const Color energyOrange = Color(0xFFFF6B4A);  // Calories & CNS High Load
  static const Color heartRed = Color(0xFFFF2D55);      // Cardiovascular & Max Strain
  static const Color recoveryBlue = Color(0xFF0A84FF);  // Hydration & Sleep
  static const Color hypertrophyGold = Color(0xFFFFD60A);// SFR Elite & Milestones
  static const Color alertYellow = Color(0xFFFF9F0A);   // Warning / Deload Needed

  // Dark Theme Backgrounds & Surfaces (Linear.app Dark)
  static const Color darkBackground = Color(0xFF0A0C0E); // Deep Obsidian
  static const Color darkSurface = Color(0xFF14171C);    // Card Surface
  static const Color darkSurfaceElevated = Color(0xFF1D222A); // Hover / Modal Surface
  static const Color darkBorder = Color(0xFF262C36);     // Subdued Border
  static const Color darkBorderHighlight = Color(0xFF3B4454);

  // Light Theme Backgrounds & Surfaces (Apple Health Clean)
  static const Color lightBackground = Color(0xFFF7F8FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceElevated = Color(0xFFF0F2F5);
  static const Color lightBorder = Color(0xFFE2E6EC);
  static const Color lightBorderHighlight = Color(0xFFCCD2DC);

  // Neutral Text Colors
  static const Color textPrimaryDark = Color(0xFFF0F4F8);
  static const Color textSecondaryDark = Color(0xFF8E9BAE);
  static const Color textTertiaryDark = Color(0xFF5A6678);

  static const Color textPrimaryLight = Color(0xFF111418);
  static const Color textSecondaryLight = Color(0xFF637184);
  static const Color textTertiaryLight = Color(0xFF9AA4B2);

  // Status & Utility
  static const Color success = Color(0xFF30D158);
  static const Color warning = Color(0xFFFF9F0A);
  static const Color error = Color(0xFFFF453A);
  static const Color info = Color(0xFF64D2FF);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF00F59B), Color(0xFF00D2FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient aiBadgeGradient = LinearGradient(
    colors: [Color(0xFF8A2BE2), Color(0xFF00D2FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cnsHighGradient = LinearGradient(
    colors: [Color(0xFFFF2D55), Color(0xFFFF6B4A)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient cardDarkGradient = LinearGradient(
    colors: [Color(0xFF161A20), Color(0xFF111418)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
