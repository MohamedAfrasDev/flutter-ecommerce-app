import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/t_rounded_image.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/constants/image_strings.dart';
import 'package:online_shop/utils/device/device_utility.dart';
import 'package:online_shop/utils/helpers/helper_function.dart';

class TProductMoreSubItemHorizontal extends StatelessWidget {
  const TProductMoreSubItemHorizontal({super.key, required this.image, required this.title, required this.price});

  final String image, title, price;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);

    return Container(
      width: TDeviceUtils.getScreenWidth(context) * 0.4,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product row: image + name
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image(
                  image: AssetImage(image),
                  width: 50,
                  height: 50,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                ),
              ],
            ),
          
            const SizedBox(height: 2),
          
            // Price + cart icon row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    price,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                Image(
                  image: AssetImage(TImages.shopping_cart_icon),
                  width: 25,
                  height: 25,
                  gaplessPlayback: true,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
