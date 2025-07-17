import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:online_shop/utils/repository/product_model/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductController extends GetxController {
  static ProductController get instance => Get.find();

  Future<void> savetoWhislist(ProductModel products, String productId) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(products);
    await prefs.setString('productId', jsonString);
  }
  Future<List<ProductModel>> getAddresses(String productId) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('productId');
    if (jsonString == null) return [];
    final List decoded = jsonDecode(jsonString);
    return decoded.map((json) => ProductModel.fromJson(json)).toList();
  }

  Future<List<String>> fetchAllProductImages(String productId) async {
    final response =
        await Supabase.instance.client
            .from('products')
            .select('thumbnail, images')
            .eq('id', productId)
            .single();

    final data = response;

    final String? thumbnail = data['thumbnail'] as String?;
    final String? imagesJson = data['images'] as String?;

    final List<String> allImages = [];

    if (thumbnail != null && thumbnail.isNotEmpty) {
      allImages.add(thumbnail);
    }

    if (imagesJson != null && imagesJson.isNotEmpty) {
      try {
        final decoded = jsonDecode(imagesJson) as List;
        final imagesList = decoded.map((e) => e.toString()).toList();
        allImages.addAll(imagesList);
      } catch (e) {
        print('❌ Error decoding images JSON: $e');
      }
    }

    return allImages;
  }

  Future<List<String>> fetchPromoImagesFromSupabase(String productId) async {
    final response =
        await Supabase.instance.client
            .from('products')
            .select('thumbnail, images')
            .eq('id', productId)
            .single(); // Ensures you get only one row

    final String thumbnail = response['thumbnail'];
    final List<dynamic> images = response['images'] ?? [];

    final List<String> imageUrls = [thumbnail, ...images.cast<String>()];
    return imageUrls;
  }
}
