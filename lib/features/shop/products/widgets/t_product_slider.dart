import 'package:flutter/material.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/circular_container.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:online_shop/features/shop/controllers/home_controller.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/t_rounded_image.dart';
import 'package:online_shop/features/shop/products/product_detail.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:online_shop/utils/helpers/helper_function.dart';
import 'package:online_shop/utils/helpers/models/banner_model.dart';
import 'package:online_shop/utils/repository/product_model/product_model.dart';

class TProductSlider extends StatelessWidget {
  const TProductSlider({
    super.key,
    this.isPadding = true,
    required this.images,
  });

  final bool? isPadding;
  final List<String> images;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    final dark = THelperFunction.isDarkMode(context);

  

    if (images.isEmpty) {
      return Center(child: Text('No images available'));
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TRoundedContainer(
            showBorder: true,
            padding: isPadding == true ? EdgeInsets.all(TSizes.sm) : null,
            backgroundColor: dark
                ? Colors.white.withOpacity(0.05)
                : Colors.white.withOpacity(0.05),
            borderColor: dark
                ? Colors.grey.withOpacity(0.5)
                : TColors.grey.withOpacity(0.5),
            child: CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                viewportFraction: 1,
                onPageChanged: (index, _) =>
                    controller.updatePageIndiciator(index),
              ),
              items: images.map((imageItem) {
                return TRoundedImage(
                  imageUrl: imageItem ?? '',
                  borderRadius: 15,
                  width: isPadding == true ? null : double.infinity,
                  fit: BoxFit.cover,
                  isNetworkImage: true,
                  backgroundColor: Colors.transparent,
                  applyImageRadius: false,
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: TSizes.spaceBetwwenItems),
          Obx(
            () => Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                images.length,
                (i) => TCircularContainer(
                  width: 20,
                  height: 4,
                  margin: const EdgeInsets.only(right: 10),
                  backgroundColor: controller.carouselCurrentIndex.value == i
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
