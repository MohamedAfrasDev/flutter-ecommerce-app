import 'package:get/get.dart';
import 'package:online_shop/utils/repository/product_model/product_model.dart';
import 'package:online_shop/utils/repository/product_repository.dart';

class ProductController extends GetxController {
  final ProductRepository repo = ProductRepository();
  var products = <ProductModel>[].obs;
  var isLoading = false.obs;

  Future<void> loadProducts() async {
    try {
      isLoading.value = true;
      final fetchedProducts = await repo.fetchProducts();
      products.assignAll(fetchedProducts);
    } catch (e) {
      print('Error loading products: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
