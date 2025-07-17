import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:online_shop/utils/repository/product_model/product_model.dart';

class WishlistController extends GetxController {
  final _storage = GetStorage();
  final wishlist = <ProductModel>[].obs;

  static const _storageKey = 'wishlist';

  @override
  void onInit() {
    super.onInit();
    loadWishlist();
  }

  void loadWishlist() {
    final stored = _storage.read<List>(_storageKey);
    if (stored != null) {
      wishlist.value = stored.map((e) => ProductModel.fromJson(e)).toList();
    }
  }

  void addToWishlist(ProductModel product) {
    if (!wishlist.any((p) => p.id == product.id.toString())) {
      wishlist.add(product);
      _saveWishlist();
    
    }
  }

  void removeFromWishlist(String productId) {
    wishlist.removeWhere((p) => p.id == productId.toString());
    _saveWishlist();
  }

  bool isInWishlist(String productId) {
    return wishlist.any((p) => p.id == productId.toString());
  }

  void _saveWishlist() {
    final data = wishlist.map((e) => e.toJson()).toList();
    _storage.write(_storageKey, data);
  }
}
