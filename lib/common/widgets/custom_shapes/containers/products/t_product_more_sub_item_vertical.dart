import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/t_rounded_image.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/constants/image_strings.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:online_shop/utils/device/device_utility.dart';
import 'package:online_shop/utils/helpers/helper_function.dart';

class TProductMoreSubItemVertical extends StatelessWidget {
  const TProductMoreSubItemVertical({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);

    return Container(
      width: TDeviceUtils.getScreenWidth(context) * 0.5 - TSizes.spaceBetwwenItems * 3,
      padding: const EdgeInsets.only(right: 5, bottom: 5),
      decoration: BoxDecoration(
        color: dark ? Colors.white.withOpacity(0.05) : Colors.white.withOpacity(0.55),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Image(
              image: AssetImage(TImages.productImage7),
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: TSizes.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Silicon Casejmfjmgfj',
                    style: Theme.of(context).textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    maxLines: 2,
                  ),
                ),
                const SizedBox(width: TSizes.sm),
                Image(
                  image: AssetImage(TImages.shopping_cart_icon),
                  width: 25,
                  height: 25,
                  gaplessPlayback: true,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
