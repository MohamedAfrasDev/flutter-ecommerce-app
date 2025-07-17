import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/products/t_product_more_sub_item.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/products/t_product_more_sub_item_vertical.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/constants/image_strings.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:online_shop/utils/device/device_utility.dart';
import 'package:online_shop/utils/helpers/helper_function.dart';
import 'package:online_shop/utils/theme/custom_themes/shadows.dart';

class TProductCardMoreImage extends StatelessWidget {
  const TProductCardMoreImage({
    super.key,
    this.brand = 'Nike',
    this.price = '100',
    this.image = TImages.productImage1,
    required this.productName,
    this.discount = false,
    this.freeDelivery = false,
    this.newArrival = false,
    this.topRated = false,
    this.brandImage = TImages.shopping_cart_icon,
    this.rated = false,
    this.variation = false,
    this.varText = '1',
  });

  final String brand, price;
  final String image, productName, brandImage, varText;
  final bool discount, freeDelivery, newArrival, topRated, rated, variation;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);

    return GestureDetector(
      onTap: () {
        // TODO: Navigate to combo detail
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Container(
          width: TDeviceUtils.getScreenWidth(context) * 0.85,
          decoration: BoxDecoration(
            color: dark ? Colors.white.withOpacity(0.05) : Colors.white.withOpacity(0.55),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: dark ? TColors.grey : TColors.dark.withOpacity(0.2),
              width: 0.5,
            ),
            boxShadow: [TShadowStyle.verticalProductShadow],
          ),
           child: Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    const SizedBox(height: TSizes.sm),

    /// Title
    Center(
      child: Text(
        'Combo Offer',
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: TColors.primary,
              fontWeight: FontWeight.w600,
            ),
      ),
    ),

    const SizedBox(height: TSizes.spaceBetwwenItems),

    /// Product Grid + Items
  Expanded(
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12.0),
    child: Column(
      children: [
        /// Top Row with Left Image & Right Items
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// Left - Main Image takes full height of right side
              Expanded(
                flex: 5,
                child: Container(
                  decoration: BoxDecoration(
                    color: dark
                        ? Colors.white.withOpacity(0.05)
                        : Colors.white.withOpacity(0.55),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: TColors.grey.withOpacity(0.5)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: SizedBox(
                      // Add minHeight or fixed height to prevent collapse
                      height: double.infinity,
                      child: Image.asset(
                        TImages.productImage5,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              /// Right - Two stacked horizontal items, size to content
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Wrap content height
                  children: const [
                    TProductMoreSubItemHorizontal(
                      image: TImages.productSamungEarBuds,
                      title: 'Galaxy EarbudsPro 3',
                      price: 'LKR 200',
                    ),
                    SizedBox(height: TSizes.spaceBetwwenItems),
                    TProductMoreSubItemHorizontal(
                      image: TImages.productImage4,
                      title: 'Lap',
                      price: 'LKR 300',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: TSizes.spaceBetwwenItems / 2),

        /// Bottom horizontal items
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Expanded(child: TProductMoreSubItemVertical()),
            SizedBox(width: TSizes.spaceBetwwenItems),
            Expanded(child: TProductMoreSubItemVertical()),
          ],
        ),
      ],
    ),
  ),
),


    /// No SizedBox here — direct to button

    /// Buy Now Button
    Container(
      decoration: BoxDecoration(
        color: TColors.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(5),
          bottomRight: Radius.circular(5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Text(
          'Buy Now',
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: TColors.light),
        ),
      ),
    ),
  ],
),

        ),
      ),
    );
  }
}
