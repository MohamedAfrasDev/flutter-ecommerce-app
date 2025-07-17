import 'package:flutter/material.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/primary_header_widget.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/products/t_brand_title.dart';
import 'package:online_shop/common/widgets/icons/circular_icons.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:online_shop/utils/device/device_utility.dart';
import 'package:online_shop/utils/helpers/enums.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class TBrandShopHeader extends StatelessWidget {
  const TBrandShopHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: TDeviceUtils.getScreenWidth(context),
      child: TPrimaryHeader(
        child: Padding(
          padding: const EdgeInsets.only(top: 40, bottom: 20),
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: TCircularIcon(icon: Iconsax.user_copy, width: 100, height: 100,)),
              const SizedBox(height: TSizes.spaceBetwwenItems,),
              TBrandTitleVerifiedIcon(title: 'Shop Name', textColor: Colors.white, brandTextSizes: TextSizes.large,iconColor: Colors.white,)
                ],
              ),
              Text('data'),
              const SizedBox(height: TSizes.spaceBetwwenSections,),
            ],
          ),
        ),
      ),
    );
  }
}