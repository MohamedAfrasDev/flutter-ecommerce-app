import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TColors {
  TColors._();

  // Default primary color
  static Color primary = const Color.fromARGB(255, 49, 163, 255);
  static const Color secondary = Color(0xFFFFE24B);
  static const Color accent = Color(0xFFb0c7ff);

  // Text Color
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color textWhite = Colors.white;

  // Background Color
  static const Color light = Color(0xFFF6F6F6);
  static const Color dark = Color(0xFF272727);
  static const Color primaryBackground = Color(0xFFF3F5FF);
  static const Color grey = Color.fromARGB(255, 230, 230, 230);

  // Background Container Colors
  static const Color lightContainer = Color(0xFFF6F6F6);
  static Color darkContainer = textWhite.withOpacity(0.1);

  // Button Color
  static const Color buttonPrimary = Color(0xFF4b68ff);
  static const Color buttonSecondary = Color(0xFF6C757D);
  static const Color buttonDisabled = Color(0xFFC4C4C4);

  // Border Color
  static const Color borderPrimary = Color(0xffd9d9d9);
  static const Color borderSecondary = Color(0xFFE6E6E6);

  // Product Card
  static const productCardLight = Colors.white;
  static const productCardDark = Color.fromARGB(255, 22, 25, 26);

  /// Loads primary color from Supabase `app_settings` table
  static Future<void> loadPrimaryColorFromSupabase() async {
    final supabase = Supabase.instance.client;
    final response = await supabase.from('app_config').select('value').eq('title', 'app_color').maybeSingle();

    if (response != null && response['value'] != null) {
      final hexColor = response['value'];
      primary = _hexToColor(hexColor);
      print('Primary color updated to: $primary');
    } else {
      print('Primary color not found in Supabase.');
    }
  }

  /// Converts hex string to [Color]
  static Color _hexToColor(String hex) {
    hex = hex.replaceFirst('#', '');
    if (hex.length == 6) hex = 'FF$hex'; // add opacity if missing
    return Color(int.parse(hex, radix: 16));
  }
}
