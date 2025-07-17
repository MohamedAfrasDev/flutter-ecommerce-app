import 'package:flutter/material.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/products/t_brand_title.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/t_rounded_image.dart';
import 'package:online_shop/features/shop/screens/cart/controller/cart_item_model.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/constants/image_strings.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:online_shop/utils/helpers/helper_function.dart';
class TOrderitem extends StatelessWidget {
  const TOrderitem({
    super.key,
    required this.product,
  });

  final CartItem product;

  @override
  Widget build(BuildContext context) {

   print('Rendering product with variations: ${product.variationAttributes}');

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TRoundedImage(
          imageUrl: product.image.isNotEmpty ? product.image : TImages.productImage1,
          width: 60,
          height: 60,
          isNetworkImage: true,
          padding: const EdgeInsets.all(TSizes.sm),
          backgroundColor: THelperFunction.isDarkMode(context) ? TColors.dark : TColors.light,
        ),
        const SizedBox(width: TSizes.spaceBetwwenItems),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TBrandTitleVerifiedIcon(title: product.title),
            Text('Qty: ${product.quantity}', style: Theme.of(context).textTheme.bodySmall),
            Text('Price: LKR ${(product.price * product.quantity).toStringAsFixed(2)}', style: Theme.of(context).textTheme.bodySmall),
        
            // Display variation attributes only if they exist and are not empty
            if (product.variationAttributes != null && product.variationAttributes.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: product.variationAttributes.entries.map((entry) =>
                  Text('${entry.key}: ${entry.value}', style: Theme.of(context).textTheme.bodySmall),
                ).toList(),
              ),
        
            // Remove this hardcoded Text.rich or keep for static info:
            // Text.rich(
            //   TextSpan(
            //     children: [
            //       TextSpan(text: 'Color ', style: Theme.of(context).textTheme.bodySmall),
            //       TextSpan(text: 'Green ', style: Theme.of(context).textTheme.bodyLarge),
            //       TextSpan(text: 'Size ', style: Theme.of(context).textTheme.bodySmall),
            //       TextSpan(text: 'UK 08 ', style: Theme.of(context).textTheme.bodyLarge),
            //     ],
            //   ),
            // ),
          ],
        ),
      ],
    );
  }
}
