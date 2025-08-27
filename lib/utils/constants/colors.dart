import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Global flag to track Supabase initialization
bool isSupabaseInitialized = false;

class TColors {
  TColors._();

  static Color primary = const Color.fromARGB(255, 49, 163, 255);
  static const Color secondary = Color(0xFFFFE24B);
  static const Color accent = Color(0xFFb0c7ff);

  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color textWhite = Colors.white;

  static const Color light = Color(0xFFF6F6F6);
  static const Color dark = Color(0xFF272727);
  static const Color primaryBackground = Color(0xFFF3F5FF);
  static const Color grey = Color.fromARGB(255, 230, 230, 230);

  static const Color lightContainer = Color(0xFFF6F6F6);
  static Color darkContainer = textWhite.withOpacity(0.1);

  static const Color buttonPrimary = Color(0xFF4b68ff);
  static const Color buttonSecondary = Color(0xFF6C757D);
  static const Color buttonDisabled = Color(0xFFC4C4C4);

  static const Color borderPrimary = Color(0xffd9d9d9);
  static const Color borderSecondary = Color(0xFFE6E6E6);

  static const productCardLight = Colors.white;
  static const productCardDark = Color.fromARGB(255, 22, 25, 26);

  /// Loads primary color from Supabase `app_config` table
  static Future<void> loadPrimaryColorFromSupabase() async {
    try {
      if (!isSupabaseInitialized) {
        print('❌ Supabase not initialized yet.');
        return;
      }

      final supabase = Supabase.instance.client;
      final response = await supabase
          .from('app_config')
          .select('value')
          .eq('title', 'app_color')
          .maybeSingle();

      if (response != null && response['value'] != null) {
        final hexColor = response['value'];
        primary = _hexToColor(hexColor);
        print('✅ Primary color updated to: $primary');
      } else {
        print('⚠️ Primary color not found in Supabase.');
      }
    } catch (e) {
      print('❌ Error loading primary color: $e');
    }
  }

  static Color _hexToColor(String hex) {
    hex = hex.replaceFirst('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }
}
