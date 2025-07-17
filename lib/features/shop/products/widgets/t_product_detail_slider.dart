import 'package:flutter/material.dart';
import 'package:online_shop/common/widgets/custom_shapes/appbar/appbar.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/t_rounded_image.dart';
import 'package:online_shop/common/widgets/custom_shapes/curved_shapes/curved_shape_edge_widget.dart';
import 'package:online_shop/common/widgets/icons/circular_icons.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/constants/image_strings.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:online_shop/utils/helpers/helper_function.dart';

class TProductImageSlider extends StatelessWidget {
  const TProductImageSlider({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    return TCurvedWidget(
      child: Container(
        color: dark ? TColors.textWhite : TColors.textWhite,
        child: Stack(
          children: [
            SizedBox(
              height: 400,
              child: Padding(
                padding: const EdgeInsets.all(
                  TSizes.productImageRadius * 2,
                ),
                child: Image(image: AssetImage(TImages.productImage1),),
              ),
            ),
    
            Positioned(
              right: 10,
              bottom: 230,
              left: TSizes.defaultSpace,
              child: SizedBox(
                height: 80,
                width: 50,
                child: ListView.separated(
                  separatorBuilder: (_, __) => const SizedBox(width: TSizes.spaceBetwwenItems,),
                  itemCount: 4,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (_, index) => TRoundedImage(
                    width: 50,
                    backgroundColor: dark ? TColors.textWhite : TColors.textWhite,
                    border: Border.all(color: TColors.primary),
                    padding: const EdgeInsets.all(TSizes.sm),
                    imageUrl: TImages.productImage1,
                  ),
                ),
              ),
            ),
    
            const TAppBar(
              showBackArrrow: true,
              actions: [TCircularIcon(icon: Iconsax.heart, ),
              SizedBox(width: TSizes.spaceBetwwenItems,),
              TCircularIcon(icon: Icons.share,)],
            )
          ],
        ),
      ),
    );
  }
}
