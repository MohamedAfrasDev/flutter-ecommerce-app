import 'package:flutter/material.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/t_rounded_image.dart';
import 'package:online_shop/common/widgets/icons/circular_icons.dart';
import 'package:online_shop/common/widgets/texts/product_title_text.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/constants/image_strings.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:online_shop/utils/device/device_utility.dart';
import 'package:online_shop/utils/helpers/helper_function.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class TProductCardTopSale extends StatelessWidget {
  const TProductCardTopSale({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    return Container(
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(TSizes.productImageRadius),
        color: dark ? TColors.dark : TColors.light,
      ),
      child: Column(
        children: [
          Flexible(
            child: TRoundedContainer(
              width: TDeviceUtils.getScreenWidth(context) * 0.9,
              height: 400,
              padding: const EdgeInsets.all(TSizes.sm),
              backgroundColor: dark ? TColors.dark : TColors.light,
              child:  Stack(
                children: [
                  SizedBox(
                    width: TDeviceUtils.getScreenWidth(context) * 0.9,
                    height: 400,
                    child: TRoundedImage(imageUrl: TImages.productImage1, applyImageRadius: true,fit: BoxFit.cover,)
                    ),
                    
                    Positioned(
                      top: 12,
                      child: TRoundedContainer(
                        radius: TSizes.sm,
                        backgroundColor: TColors.secondary.withOpacity(0.8),
                        padding: const EdgeInsets.symmetric(horizontal: TSizes.sm, vertical: TSizes.xs),
                        child: Text('25%', style: Theme.of(context).textTheme.labelLarge!.apply(color: Colors.black),),
                      ),
                    ),
                  
                    const Positioned(
                      top: 0,
                      right: 0,
                      child: TCircularIcon(icon: Iconsax.heart, color: Colors.red,))
                ],
              ),
            ),

          
          ),
          Column(
            children: [
              TProductTitleText(title: 'Green Shoes')
            ],
          )

        ],
      ),
    );
  }
}