import 'package:flutter/material.dart';
import 'package:online_shop/features/shop/screens/store/widgets/featured_brand_categories.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/helpers/helper_function.dart';

class TFeaturedBrand extends StatelessWidget {
  const TFeaturedBrand({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: dark ? TColors.light.withOpacity(0.3) : TColors.dark.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            TFeaturedBrandCategories(),
          ],
        )
      ),
    );
  }
}