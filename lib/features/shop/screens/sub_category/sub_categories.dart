import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:online_shop/common/widgets/custom_shapes/appbar/appbar.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/section_heading.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/t_rounded_image.dart';
import 'package:online_shop/features/shop/screens/all_products/all_products.dart';
import 'package:online_shop/features/shop/screens/home/widgets/product_slider_category.dart';
import 'package:online_shop/features/shop/screens/home/widgets/product_slider_category_horizontal.dart';
import 'package:online_shop/features/shop/screens/sub_category/widgets/brand_slider.dart';
import 'package:online_shop/features/shop/screens/sub_category/widgets/product_slider_sub_category.dart';
import 'package:online_shop/features/shop/screens/sub_category/widgets/related_category.dart';
import 'package:online_shop/features/shop/screens/sub_category/widgets/sub_banner.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/constants/image_strings.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:online_shop/utils/device/device_utility.dart';
import 'package:online_shop/utils/helpers/helper_function.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SubCategoriesScreen extends StatelessWidget {
  const SubCategoriesScreen({
    super.key,
    required this.text,
    required this.image,
    this.categoryID,
    this.tabID,
  });

  final String text, image;
  final String? categoryID, tabID;
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

              TSubBannerSlider(location: categoryID!),
              SizedBox(height: TSizes.spaceBetwwenSections),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: TSizes.lg),
                    child: Text(
                      'Suggested Brands',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBetwwenItems),
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: Supabase.instance.client
                        .from('brands')
                        .select()
                        .eq('category', categoryID!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text("No Brands found"));
                      }

                      final categories = snapshot.data!;
                      return TBrandSlider(dataList: categories);
                    },
                  ),
                ],
              ),

              const SizedBox(height: TSizes.spaceBetwwenSections),

              TProductSliderSubCategory(categoryID: categoryID!),

              const SizedBox(height: TSizes.spaceBetwwenSections),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: TSizes.lg),
                    child: Text(
                      'Related Categories',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBetwwenItems),
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: Supabase.instance.client
                        .from('tab_categories')
                        .select()
                        .eq('tab_id', tabID!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text("No Categories found"));
                      }

                      final filteredCategories =
                          snapshot.data!.where((category) {
                            return category['id'].toString() != categoryID;
                          }).toList();

                      if (filteredCategories.isEmpty) {
                        return const Center(child: Text("No Categories found"));
                      }

                      return TRelatedCategory(dataList: filteredCategories);
                    },
                  ),
                ],
              ),
            
              const SizedBox(height: TSizes.spaceBetwwenSections),
            ],
          ),
        ),
      ),
    );
  }
}
