import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseBannerService {
  static Future<List<String>> getActiveBannerUrls() async {
    try {
      final response = await Supabase.instance.client
    .from('images')
    .select('banners')
    .select('url');

print("Supabase response: $response");


    

      // Extract and clean URLs
      final List<String> urls = response
          .map<String>((item) => (item['url'] as String).trim())
          .where((url) => url.isNotEmpty && url.startsWith('http'))
          .toList();

      return urls;
    } catch (e, stack) {
      print("Error loading banners: $e");
      print(stack);
      return [];
    }
  }
}
