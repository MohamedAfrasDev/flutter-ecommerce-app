// lib/features/shop/controllers/slider_product_controller.dart
import 'package:get/get.dart';
import 'package:online_shop/utils/repository/product_model/product_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SliderProductController extends GetxController {
  final RxList<ProductModel> sliderProducts = <ProductModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSliderProducts(); // Automatically fetch on init
  }

  Future<void> fetchSliderProducts() async {
    try {
      isLoading.value = true;

      final response = await Supabase.instance.client
          .from('products')
          .select()
          .eq('offer_value', 'bundleOffer')
          .order('created_at', ascending: false)
          .limit(6);

      final data = response as List;
      final List<ProductModel> fetchedProducts =
          data.map((json) => ProductModel.fromJson(json)).toList();

      sliderProducts.assignAll(fetchedProducts);
    } catch (e) {
      print('Slider product fetch error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
