import 'dart:async';
import 'package:flutter/material.dart';
import 'package:online_shop/utils/repository/product_model/attributes_model.dart';
import 'package:online_shop/utils/repository/product_model/product_model.dart';
import 'package:online_shop/utils/repository/product_model/variation_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/products/product_card_vertical.dart';
import 'package:online_shop/utils/constants/sizes.dart';

class TProductSliderSubCategory extends StatefulWidget {
  const TProductSliderSubCategory({
    super.key,
    this.discount = false,
    this.topRated = false,
    this.freeDelivery = false,
    this.newArrival = false,
    this.rated = false,
    this.variation = false,
    this.varText = '1',
    this.reverse = false,
    required this.categoryID,
  });

  final bool discount, topRated, freeDelivery, newArrival, rated, variation;
  final bool reverse;
  final String varText, categoryID;

  @override
  State<TProductSliderSubCategory> createState() => _TProductSliderSubCategoryState();
}

class _TProductSliderSubCategoryState extends State<TProductSliderSubCategory> {
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 5000;

  final supabase = Supabase.instance.client;
  List<ProductModel> productModels = [];

  List<Map<String, dynamic>> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.7, initialPage: _currentPage);
    _startAutoScroll();
    fetchProductByCateogry(widget.categoryID);
    print('🟢🟢📞🟢 ${widget.categoryID}');
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_pageController.hasClients && productModels.isNotEmpty) {
        _currentPage++;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }
  Future<void> fetchProductByCateogry(String categoryID) async {
    try {
     final response = await supabase
    .from('products')
    .select()
    .filter('categories', 'cs', '[{"id": "$categoryID"}]');

      List<Map<String, dynamic>> rawList = List<Map<String, dynamic>>.from(response);

       setState(() {
        productModels = rawList.map((map) => ProductModel.fromJson(map)).toList();
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching products: $e");
      setState(() => isLoading = false);
    }
  }
List<ProductVariantionsModel> parseVariations(dynamic variationsRaw) {
  if (variationsRaw == null) return [];
  if (variationsRaw is List<dynamic>) {
    return variationsRaw
        .map((v) => ProductVariantionsModel.fromJson(v as Map<String, dynamic>))
        .toList();
  }
  return [];
}

// Helper method to safely parse List<ProductAttributeModel>
List<ProductAttributeModel> parseAttributes(dynamic attributesRaw) {
  if (attributesRaw == null) return [];
  if (attributesRaw is List<dynamic>) {
    return attributesRaw
        .map((a) => ProductAttributeModel.fromJson(a as Map<String, dynamic>))
        .toList();
  }
  return [];
}
  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

@override
Widget build(BuildContext context) {
  double height = widget.rated
      ? (widget.discount ? 360 : 400)
      : (widget.discount ? 350 : 320);

  if (isLoading) {
    return SizedBox(
      height: height,
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  if (productModels.isEmpty) {
    return SizedBox(
      height: height,
      child: const Center(child: Text("No products found.")),
    );
  }

  return SizedBox(
    height: height,
    child: PageView.builder(
      controller: _pageController,
      reverse: widget.reverse,
      // ✅ infinite loop: omit itemCount
 itemBuilder: (context, index) {
     final actualIndex = index % productModels.length;
          final product = productModels[actualIndex];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace / 2),
          child: TProductCardVertical(productModel: product,
  
)

        );
      },

    ),
  );
}

}
