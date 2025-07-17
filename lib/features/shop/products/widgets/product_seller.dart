import 'package:flutter/material.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/products/t_brand_title.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/t_circular_image.dart';
import 'package:online_shop/features/shop/screens/brand_shop/brand_shop.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/constants/image_strings.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:online_shop/utils/helpers/enums.dart';
import 'package:get/get.dart';

class ProductSellerInformation extends StatelessWidget {
  const ProductSellerInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => Get.to(() => const BrandShopScreen()),
          child: Row(
            children: [
              TCircularImage(image: TImages.appLightLogo, width: 70, height: 70),
              Column(
                children: [
                  TBrandTitleVerifiedIcon(
                    title: 'Afras',
                    brandTextSizes: TextSizes.large,
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(TSizes.md),
              backgroundColor: TColors.grey,
            ),
            child: Text('Chat with Seller', style: TextStyle(color: Colors.black),)),
        ),
      ],
    );
  }
}
