import 'package:flutter/material.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/products/product_card_horizontal.dart';
import 'package:online_shop/features/shop/screens/store/widgets/featured_brand.dart';
import 'package:online_shop/utils/constants/image_strings.dart';
import 'package:online_shop/utils/constants/sizes.dart';

class TFeatureBrandSlider extends StatelessWidget {
  const TFeatureBrandSlider({
    super.key, this.discount = false, this.topRated = false, this.freeDelivery = false, this.newArrival = false, this.rated = false, this.variation = false, this.varText = '1',
  });

  final bool discount, topRated, freeDelivery, newArrival, rated, variation;
  final String varText;
    // Step 1: Define a list of category data
  final List<Map<String, String>> categories = const [
    {'image': TImages.productImage3, 'varText': '256 GB','price': '310,000','brandImage': TImages.apple_logo_icon ,'brand': 'Apple' ,'title': 'Apple iPhone 13'},
    {'image': TImages.productImage2, 'varText': '50 M','price': '200','brandImage': TImages.moose_logo_icon ,'brand': 'Moose' ,'title': 'Moose T-Shirts'},
    {'image': TImages.productImage1, 'varText': '13','price': '400','brandImage': TImages.nike_logo_icon ,'brand': 'Nike' ,'title': 'hjags,khags,kashgkkhasg,hgsaags,'},
    {'image': TImages.productImage4, 'varText': '1TB NVME','price': '1500','brandImage': TImages.asus_logo_icon ,'brand': 'Asus' ,'title': 'Asus Zenbook Duo'},
  ];


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: discount ? 300 : 200,
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
              child: TFeaturedBrand()
            ),
          );
        }
      ),
    );
  }
}