import 'dart:async';
import 'package:flutter/material.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/products/product_card_image_slider.dart';
import 'package:online_shop/utils/constants/image_strings.dart';
import 'package:online_shop/utils/constants/sizes.dart';

class TProductMoreImageSlider extends StatefulWidget {
  const TProductMoreImageSlider({
    super.key,
    this.discount = false,
    this.topRated = false,
    this.freeDelivery = false,
    this.newArrival = false,
    this.rated = false,
    this.variation = false,
    this.varText = '1',
    this.reverse = false,
  });

  final bool discount, topRated, freeDelivery, newArrival, rated, variation;
  final bool reverse;
  final String varText;

  @override
  State<TProductMoreImageSlider> createState() => _TProductMoreImageSliderState();
}

class _TProductMoreImageSliderState extends State<TProductMoreImageSlider> {
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;

  final List<Map<String, String>> categories = const [
    {
      'image': TImages.productImage3,
      'varText': '256 GB',
      'price': '310,000',
      'brandImage': TImages.apple_logo_icon,
      'brand': 'Apple',
      'title': 'Apple iPhone 13',
    },
    {
      'image': TImages.productImage2,
      'varText': '50 M',
      'price': '200',
      'brandImage': TImages.moose_logo_icon,
      'brand': 'Moose',
      'title': 'Moose T-Shirts',
    },
    {
      'image': TImages.productImage1,
      'varText': '13',
      'price': '400',
      'brandImage': TImages.nike_logo_icon,
      'brand': 'Nike',
      'title': 'Nike Special Edition Shoes',
    },
    {
      'image': TImages.productImage4,
      'varText': '1TB NVME',
      'price': '1500',
      'brandImage': TImages.asus_logo_icon,
      'brand': 'Asus',
      'title': 'Asus Zenbook Duo',
    },
  ];

  @override
  void initState() {
    super.initState();
    _currentPage = categories.length * 100;
    _pageController = PageController(
      initialPage: _currentPage,
      viewportFraction: 0.9,
    );

    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_pageController.hasClients) {
        _currentPage++;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
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
      height: MediaQuery.of(context).size.height * 0.58, // responsive
      child: PageView.builder(
        controller: _pageController,
        reverse: widget.reverse,
        itemBuilder: (context, index) {
          final actualIndex = index % categories.length;
          final category = categories[actualIndex];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace / 2),
            child: TProductCardMoreImage(
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
          );
        },
      ),
    );
  }
}
