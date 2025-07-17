import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:online_shop/common/styles/layouts/grid_view_layout.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/section_heading.dart';
import 'package:online_shop/features/shop/screens/store/controller/store_controller.dart';
import 'package:online_shop/features/shop/screens/store/widgets/category_tab.dart';
import 'package:online_shop/features/shop/screens/store/widgets/product_grid_item.dart';
import 'package:online_shop/features/shop_2/screens/home/widgets/t_tab_bar_view_cat.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/constants/image_strings.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:online_shop/utils/constants/text_strings.dart';
import 'package:online_shop/utils/device/device_utility.dart';
import 'package:online_shop/utils/helpers/helper_function.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class StoreScreen extends StatelessWidget {
  StoreScreen({super.key});

  final StoreController storeController = Get.put(StoreController());

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);

    return Scaffold(
      body: Container(
        height: TDeviceUtils.getScreenHeight(),
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0.5, 0.5),
            radius: 1.8,
            colors: [
              dark ? TColors.primary.withOpacity(0.7) : TColors.primary.withOpacity(0.7),
              dark ? TColors.accent.withOpacity(0.7) : TColors.accent.withOpacity(0.7),
              dark ? TColors.accent.withOpacity(0.4) : TColors.accent.withOpacity(0.4),
              dark ? TColors.primary.withOpacity(0.2) : TColors.primary.withOpacity(0.2),
              dark ? Colors.black.withOpacity(0.05) : Colors.white.withOpacity(0.05),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: TSizes.spaceBetwwenSections),
              Padding(
                padding: const EdgeInsets.only(left: TSizes.lg),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      TText.second_screen_text,
                      style: Theme.of(context).textTheme.headlineMedium!.apply(
                            color: dark ? TColors.primary : null,
                          ),
                    ),
                    const Icon(Iconsax.shopping_cart_copy),
                  ],
                ),
              ),

              const SizedBox(height: TSizes.md),

              /// Categories
              const Padding(
                padding: EdgeInsets.only(left: TSizes.defaultSpace, right: 10),
                child: TSectionHeading(title: 'Categories', showActionButton: false),
              ),

              const SizedBox(height: TSizes.md),
              const SizedBox(height: TSizes.spaceBetwwenItems),
              const TTabViewICategory(isTab1: false),
              const SizedBox(height: TSizes.spaceBetwwenItems),

              /// Featured Section
              const Padding(
                padding: EdgeInsets.only(left: TSizes.defaultSpace, right: 10),
                child: TSectionHeading(title: 'Featured for you', showActionButton: false),
              ),

              Obx(() {
                if (storeController.isLoading.value && storeController.page == 0) {
                  return Lottie.asset(TImages.loading_animation, width: 100, height: 100);
                } else if (storeController.products.isEmpty) {
                  return Column(
                    children: [
                      Lottie.asset(TImages.no_data_animtation, width: 100, height: 100),
                      Text('No Products Found...',
                          style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  );
                } else {
                  return GridViewLayout(
                    itemCount: storeController.products.length,
                    itemBuilder: (_, index) {
                      final product = storeController.products[index];
                      return TProductGridItem(
                        productModel: product,
                      );
                    },
                    shrinkWrap: true,
                  );
                }
              }),

              const SizedBox(height: TSizes.spaceBetwwenItems),

              Obx(() {
                return Column(
                  children: [
                    if (storeController.hasMore.value && !storeController.isLoading.value)
                         GestureDetector(
                        onTap: () => storeController.fetchProducts(loadMore: true),
                        child: Container(
                          decoration: BoxDecoration(
                            color: TColors.primary,
                            border: Border.all(color: dark ? Colors.grey.withOpacity(0.5) : TColors.dark.withOpacity(0.2)),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text('Load More', style: TextStyle(color: Colors.white),),
                          ),
                        ),
                      ),
                    if (!storeController.hasMore.value)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text('No more products',
                            style: Theme.of(context).textTheme.labelLarge),
                      ),
                    if (storeController.isLoading.value && storeController.page > 0)
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                  ],
                );
              }),

              const SizedBox(height: TSizes.spaceBetwwenItems),
            ],
          ),
        ),
      ),
    );
  }
}
