import 'package:online_shop/utils/repository/product_model/product_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductRepository {
  final supabase = Supabase.instance.client;

  Future<List<ProductModel>> fetchProducts() async {
    final response = await supabase
        .from('products')
        .select()
        .order('created_at', ascending: false);

  
    // response.data is a List<Map<String, dynamic>>
    return (response as List)
        .map((json) => ProductModel.fromJson(json))
        .toList();
  }
}
