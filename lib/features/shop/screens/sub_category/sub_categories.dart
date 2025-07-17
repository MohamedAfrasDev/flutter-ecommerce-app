import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:online_shop/common/widgets/custom_shapes/appbar/appbar.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/section_heading.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/t_rounded_image.dart';
import 'package:online_shop/features/shop/screens/all_products/all_products.dart';
import 'package:online_shop/features/shop/screens/home/widgets/product_slider_category.dart';
import 'package:online_shop/features/shop/screens/home/widgets/product_slider_category_horizontal.dart';
import 'package:online_shop/features/shop/screens/sub_category/widgets/product_slider_sub_category.dart';
import 'package:online_shop/features/shop/screens/sub_category/widgets/sub_banner.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/constants/image_strings.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:online_shop/utils/device/device_utility.dart';
import 'package:online_shop/utils/helpers/helper_function.dart';

class SubCategoriesScreen extends StatelessWidget {
  const SubCategoriesScreen({
    super.key,
    required this.text,
    required this.image,
    this.categoryID,
  });

  final String text, image;
  final String? categoryID;
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            focal: const Alignment(0.5, 0.4),
            radius: 2,
            colors: [
              dark
                  ? TColors.primary.withOpacity(0.5)
                  : TColors.primary.withOpacity(0.5),
              dark
                  ? TColors.accent.withOpacity(0.5)
                  : TColors.accent.withOpacity(0.4),

              dark
                  ? TColors.primary.withOpacity(0.1)
                  : TColors.primary.withOpacity(0.01),
              dark
                  ? Colors.black.withOpacity(0.1)
                  : Colors.white.withOpacity(0.1),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: TSizes.spaceBetwwenSections),
              Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Iconsax.arrow_left_2_copy),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBetwwenSections),
              FadeInImage(
                fit: BoxFit.cover,
                image: NetworkImage(image),
                width: TDeviceUtils.getScreenWidth(context) * 0.4,
                placeholder: AssetImage(TImages.placeholder_image),
                imageErrorBuilder:
                    (context, error, stackTrace) => const Icon(Icons.error),
              ),
              const SizedBox(height: TSizes.spaceBetwwenItems),
              Text(text, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: TSizes.spaceBetwwenSections),

              Padding(
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                child: TSubBannerSlider(location: categoryID!),
              ),
              SizedBox(height: TSizes.spaceBetwwenSections),

              TProductSliderSubCategory(categoryID: categoryID!),

              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: TSizes.lg),
                    child: TSectionHeading(
                      title: 'Sports shirts',
                      onPressed: () => Get.to(() => const AllProducts()),
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBetwwenItems / 2),

                  //   TProductSliderCategory(),
                ],
              ),
              const SizedBox(height: TSizes.spaceBetwwenSections),

              Padding(
                padding: const EdgeInsets.only(right: TSizes.md),
                child: TProductSliderHorizontal(),
              ),

              const SizedBox(height: TSizes.spaceBetwwenSections),
            ],
          ),
        ),
      ),
    );
  }
}
