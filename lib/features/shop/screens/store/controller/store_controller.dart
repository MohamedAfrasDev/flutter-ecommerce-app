// lib/features/shop/controllers/store_controller.dart
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:online_shop/utils/repository/product_model/product_model.dart';

class StoreController extends GetxController {
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool hasMore = true.obs;
  int page = 0;
  final int pageSize = 2;

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  Future<void> fetchProducts({bool loadMore = false}) async {
    if (!loadMore) {
      isLoading.value = true;
      products.clear();
      page = 0;
      hasMore.value = true;
    }

    try {
      final start = page * pageSize;
      final end = start + pageSize - 1;

      final response = await Supabase.instance.client
          .from('products')
          .select()
          .order('created_at', ascending: false)
          .range(start, end);

          print('🔴🔴 ${response.length}');

      if (response == null || (response as List).isEmpty) {
        hasMore.value = false;
        isLoading.value = false;
        return;
      }

      final newProducts =
          response.map((json) => ProductModel.fromJson(json)).toList();

      if (loadMore) {
        products.addAll(newProducts);
      } else {
        products.assignAll(newProducts);
      }

      if (newProducts.length < pageSize) {
        hasMore.value = false;
      }

      page += 1;
      isLoading.value = false;
    } catch (e, st) {
      print('🔴🔴Error: $e');
      print('🔴🔴Stacktrace: $st');
      isLoading.value = false;
    }
  }
}
