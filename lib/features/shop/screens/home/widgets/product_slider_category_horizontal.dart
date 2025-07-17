import 'dart:async';

import 'package:flutter/material.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/products/product_card_horizontal.dart';
import 'package:online_shop/utils/constants/image_strings.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:online_shop/utils/repository/product_model/variation_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TProductSliderHorizontal extends StatefulWidget {
  const TProductSliderHorizontal({
    super.key, this.discount = false, this.topRated = false, this.freeDelivery = false, this.newArrival = false, this.rated = false, this.variation = false, this.varText = '1',
  });

  final bool discount, topRated, freeDelivery, newArrival, rated, variation;
  final String varText;

  @override
  State<TProductSliderHorizontal> createState() => _TProductSliderHorizontalState();
}

class _TProductSliderHorizontalState extends State<TProductSliderHorizontal> {
    // Step 1: Define a list of category data
  final List<Map<String, String>> categories = const [
    {'image': TImages.productImage5, 'varText': '256 GB','price': '20,000','brandImage': TImages.asus_logo_icon ,'brand': 'ROG' ,'title': 'Apple iPhone 13'},
    {'image': TImages.productImage6, 'varText': '50 M','price': '90,000','brandImage': TImages.samsung_logo ,'brand': 'Samsung' ,'title': 'Samsung Galaxy Watch 5 Pro'},
    {'image': TImages.productImage1, 'varText': '13','price': '599,000','brandImage': TImages.apple_logo_icon ,'brand': 'Apple' ,'title': 'Apple Macbook Air M3'},
    {'image': TImages.productImage4, 'varText': '1TB NVME','price': '550,000','brandImage': TImages.asus_logo_icon ,'brand': 'Asus' ,'title': 'Asus Zenbook Duo'},
  ];

   late PageController _pageController;
  late Timer _timer;
  int _currentPage = 5000;

  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.7, initialPage: _currentPage);
    _startAutoScroll();
   fetchAllProducts();
    
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_pageController.hasClients && products.isNotEmpty) {
        _currentPage++;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }
Future<void> fetchAllProducts() async {
    try {
      final response = await supabase
          .from('products')
          .select();
          

      setState(() {
        products = List<Map<String, dynamic>>.from(response);
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
  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.discount ? 160 : 140,
       child: ListView.builder(
        shrinkWrap: true,
        itemCount: categories.length,
        physics: AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, index) {
          final category = categories[index];
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: TSizes.defaultSpace),
              child: TProductCardHorizontal(
                image: category['image']!,
                productName: category['title']!,
                brand: category['brand']!,
                discount: widget.discount,
                topRated: widget.topRated,
                newArrival: widget.newArrival,
                brandImage: category['brandImage']!,
                price: category['price']!,
                rated: widget.rated,
                variation: widget.variation,
                varText: category['varText']!,
              
              ),
            ),
          );
        }
      ),
    );
  }
}