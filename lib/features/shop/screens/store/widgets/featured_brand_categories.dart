import 'package:flutter/material.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/constants/image_strings.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:online_shop/utils/helpers/helper_function.dart';

class TFeaturedBrandCategories extends StatelessWidget {
  const TFeaturedBrandCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    return Flexible(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: dark ? TColors.light.withOpacity(0.3) : TColors.dark.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(10)
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Image(image: AssetImage(TImages.homeCategory1), width: 50, height: 50,),
              const SizedBox(width: TSizes.sm,),
              Text('Nike'),
            ],
          ),
        ),
      ),
    );
  }
}