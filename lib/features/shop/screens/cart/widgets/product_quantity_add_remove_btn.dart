import 'package:flutter/material.dart';
import 'package:online_shop/common/widgets/icons/circular_icons.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:online_shop/utils/helpers/helper_function.dart';

class TProductQuantityWithAddRemoveButton extends StatelessWidget {
  const TProductQuantityWithAddRemoveButton({
    super.key,
  });



  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TCircularIcon(
          icon: Iconsax.minus_copy,
          width: 32,
          height: 32,
          size: TSizes.md,
          color: dark ? TColors.light : TColors.dark,
          backgroundColor: dark ? TColors.dark : TColors.light,
        ),
        const SizedBox(width: TSizes.spaceBetwwenItems,),
    Text('2', style: Theme.of(context).textTheme.titleSmall,),
    const SizedBox(width: TSizes.spaceBetwwenItems,),
    
    TCircularIcon(
      icon: Iconsax.add_copy,
      width: 32,
      height: 32,
      size: TSizes.md,
      color: TColors.light,
      backgroundColor: TColors.primary,
    ),
      ],
    );
  }
}

