import 'package:flutter/material.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/circular_container.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:online_shop/features/shop/controllers/home_controller.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/t_rounded_image.dart';
import 'package:online_shop/features/shop/products/product_detail.dart';
import 'package:online_shop/features/shop/screens/search_screen/search_screen.dart';
import 'package:online_shop/navigation_menu.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:online_shop/utils/helpers/helper_function.dart';
import 'package:online_shop/utils/helpers/models/banner_model.dart';
import 'package:online_shop/utils/repository/product_model/product_model.dart';
import 'package:uuid/uuid.dart';

class TPromoSlider extends StatelessWidget {
  const TPromoSlider({super.key, this.isPadding = true});
  final bool? isPadding;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    final dark = THelperFunction.isDarkMode(context);

    // Filter banners that have a non-null, non-empty redirectScreen
    final filteredBanners =
        controller.banners
            .where(
              (banner) =>
                  banner.redirectScreen != null &&
                  banner.redirectScreen!.trim().isNotEmpty,
            )
            .toList();

    if (filteredBanners.isEmpty) {
      return Center(child: Text('No banners with redirect screen'));
    }

    final navController = Get.put(NaviagtionController());
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TRoundedContainer(
            showBorder: true,
            padding: isPadding == true ? EdgeInsets.all(TSizes.sm) : null,
            backgroundColor:
                dark
                    ? Colors.white.withOpacity(0.05)
                    : Colors.white.withOpacity(0.05),
            borderColor:
                dark
                    ? Colors.grey.withOpacity(0.5)
                    : TColors.grey.withOpacity(0.5),
            child: CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                viewportFraction: 1,
                onPageChanged:
                    (index, _) => controller.updatePageIndiciator(index),
              ),
              items:
                  filteredBanners.map((banner) {
                    return GestureDetector(
                      onTap: () async {
                        print('Redirect to: ${banner.redirectScreen}🎫🎫');
                       if (banner.redirectScreen == 'store') {
  // Example 1: Using GetX navigation to go to Home Screen (replace with your actual route)

  // Or Example 2: If you have a NavController managing screens (like BottomNavigationBar index)
  navController.selectedIndex.value = 1; // Switch to first tab or screen

  // Or Example 3: Using Navigator directly
  // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
}

                        if (banner.value == 'products' &&
                            banner.redirectScreen != null) {
                          final product = await controller.fetchProductById(
                            banner.redirectScreen!,
                          );

                          if (product != null) {
                            Get.to(
                              () => ProductDetailScreen(productModel: product),
                            );
                          } else {
                            Get.snackbar('Error', 'Product not found');
                          }
                        }

                        // Add other redirectScreen cases here if needed
                      },

                      child: TRoundedImage(
                        imageUrl: banner.imageUrl ?? '',
                        borderRadius: 15,
                        width: isPadding == true ? null : double.infinity,
                        fit: BoxFit.cover,
                        isNetworkImage: true,
                        backgroundColor: Colors.transparent,
                        applyImageRadius: false,
                      ),
                    );
                  }).toList(),
            ),
          ),
          const SizedBox(height: TSizes.spaceBetwwenItems),
          Obx(
            () => Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                filteredBanners.length,
                (i) => TCircularContainer(
                  width: 20,
                  height: 4,
                  margin: const EdgeInsets.only(right: 10),
                  backgroundColor:
                      controller.carouselCurrentIndex.value == i
                          ? TColors.primary
                          : Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
