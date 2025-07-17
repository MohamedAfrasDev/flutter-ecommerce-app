import 'package:get/get.dart';
import 'package:online_shop/utils/repository/product_model/product_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:online_shop/utils/helpers/models/banner_model.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find();

  var banners = <BannerModel>[].obs;
  var carouselCurrentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
      print('HomeController initialized🟢🟢🟢');

    fetchBanners();
  }

  Future<void> fetchBanners() async {
    try {
      final supabase = Supabase.instance.client;

      final data = await supabase
          .from('banners')
          .select()
          .eq('is_active', true);

      if (data != null) {
        final list = data as List<dynamic>;
        final loadedBanners = list
            .map((json) => BannerModel.fromJson(json as Map<String, dynamic>))
            .toList();

            print('🟢🟢🟢');

        banners.assignAll(loadedBanners);
      }
    } catch (e) {
      print('Error fetching banners: 🔴🔴🔴🔴$e');
    }
  }
  Future<void> fetchSubBanner(String location) async {
    try {
      final supabase = Supabase.instance.client;

      final data = await supabase
          .from('banners')
          .select()
          .eq('location', location)
          .eq('is_active', true);

      if (data != null) {
        final list = data as List<dynamic>;
        final loadedBanners = list
            .map((json) => BannerModel.fromJson(json as Map<String, dynamic>))
            .toList();

            print('🟢🟢🟢');

        banners.assignAll(loadedBanners);
      }
    } catch (e) {
      print('Error fetching banners: 🔴🔴🔴🔴$e');
    }
  }
  void updatePageIndiciator(int index) {
    carouselCurrentIndex.value = index;
  }



Future<ProductModel?> fetchProductById(String productId) async {
  try {
    final supabase = Supabase.instance.client;

    final response = await supabase
        .from('products')
        .select()
        .eq('id', productId)
        .maybeSingle();

    if (response == null) return null;

    return ProductModel.fromJson(response as Map<String, dynamic>);
  } catch (e) {
    print('Error fetching product by ID: $e');
    return null;
  }
}

}
