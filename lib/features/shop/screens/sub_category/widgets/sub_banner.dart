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

class TSubBannerSlider extends StatefulWidget {
  const TSubBannerSlider({super.key, this.isPadding = true, required this.location});
  final bool? isPadding;
  final String location;   // Pass location like 'store', 'home'

  @override
  State<TSubBannerSlider> createState() => _TSubBannerSliderState();
}

class _TSubBannerSliderState extends State<TSubBannerSlider> {
  final controller = Get.put(HomeController());
  final navController = Get.put(NaviagtionController());

  @override
  void initState() {
    super.initState();
    controller.fetchSubBanner(widget.location);
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);

    return Obx(() {
      final filteredBanners = controller.banners
          .where((banner) => banner.redirectScreen != null && banner.redirectScreen!.trim().isNotEmpty)
          .toList();

      if (filteredBanners.isEmpty) {
        return const SizedBox.shrink();
      }

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TRoundedContainer(
              showBorder: true,
              padding: widget.isPadding == true ? const EdgeInsets.all(TSizes.sm) : null,
              backgroundColor: dark ? Colors.white.withOpacity(0.05) : Colors.white.withOpacity(0.05),
              borderColor: dark ? Colors.grey.withOpacity(0.5) : TColors.grey.withOpacity(0.5),
              child: CarouselSlider(
                options: CarouselOptions(
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  viewportFraction: 1,
                  onPageChanged: (index, _) => controller.updatePageIndiciator(index),
                ),
                items: filteredBanners.map((banner) {
                  return GestureDetector(
                    onTap: () async {
                      print('Redirect to: ${banner.redirectScreen}');
                      // handle redirects like you did before
                    },
                    child: TRoundedImage(
                      imageUrl: banner.imageUrl ?? '',
                      borderRadius: 15,
                      width: widget.isPadding == true ? null : double.infinity,
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
            Obx(() => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    filteredBanners.length,
                    (i) => TCircularContainer(
                      width: 20,
                      height: 4,
                      margin: const EdgeInsets.only(right: 10),
                      backgroundColor: controller.carouselCurrentIndex.value == i
                          ? TColors.primary
                          : Colors.grey,
                    ),
                  ),
                )),
          ],
        ),
      );
    });
  }
}
