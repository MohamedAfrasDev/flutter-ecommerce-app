import 'dart:async';
import 'package:flutter/material.dart';
import 'package:online_shop/utils/repository/product_model/attributes_model.dart';
import 'package:online_shop/utils/repository/product_model/product_model.dart';
import 'package:online_shop/utils/repository/product_model/variation_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/products/product_card_vertical.dart';
import 'package:online_shop/utils/constants/sizes.dart';

class TProductSliderCategory extends StatefulWidget {
  const TProductSliderCategory({
    super.key,
    this.discount = false,
    this.topRated = false,
    this.freeDelivery = false,
    this.newArrival = false,
    this.rated = false,
    this.variation = false,
    this.varText = '1',
    this.reverse = false,
    this.tabId,
  });

  final bool discount, topRated, freeDelivery, newArrival, rated, variation;
  final bool reverse;
  final String? varText, tabId;

  @override
  State<TProductSliderCategory> createState() => _TProductSliderCategoryState();
}

class _TProductSliderCategoryState extends State<TProductSliderCategory> {
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 5000;

  final supabase = Supabase.instance.client;

  List<ProductModel> productModels = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.7, initialPage: _currentPage);
    _startAutoScroll();

    fetchProducts();
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

  Future<void> fetchProducts() async {
    try {
      final response = await supabase
          .from('products')
          .select();

      List<Map<String, dynamic>> rawList = List<Map<String, dynamic>>.from(response);

      if (widget.tabId != null) {
        rawList = rawList.where((p) => p['home_tab_id'] == widget.tabId).toList();
      }

      setState(() {
        productModels = rawList.map((map) => ProductModel.fromJson(map)).toList();
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching products: $e");
      setState(() => isLoading = false);
    }
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
        ? (widget.discount ? 340 : 320)
        : (widget.discount ? 320 : 310);

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
        itemBuilder: (context, index) {
          final actualIndex = index % productModels.length;
          final product = productModels[actualIndex];

          return TProductCardVertical(
            
            productModel: product,
          );
        },
      ),
    );
  }
}
