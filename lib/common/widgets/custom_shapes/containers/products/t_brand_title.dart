import 'package:flutter/material.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/products/t_brand_title_text.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:online_shop/utils/helpers/enums.dart';

class TBrandTitleVerifiedIcon extends StatelessWidget {
  const TBrandTitleVerifiedIcon({
    super.key, required this.title, this.maxLines = 1, this.textColor, this.iconColor = Colors.blue, this.textAlign = TextAlign.center, this.brandTextSizes = TextSizes.small,
  });
 
  final String title;
  final int maxLines;
  final Color? textColor, iconColor;
  final TextAlign? textAlign;
  final TextSizes brandTextSizes;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: TBrandTitleText(
            title: title,
            color: textColor,
            maxLines: maxLines,
            textAlign: textAlign,
            brandTextSize: brandTextSizes,
          ),
        ),
    const SizedBox(width: TSizes.xs,),
    Icon(Iconsax.verify, color: iconColor, size: TSizes.iconXs,),
      ],
    );
  }
}

