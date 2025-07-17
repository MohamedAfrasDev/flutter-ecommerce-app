import 'package:flutter/material.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/circular_container.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/products/product_card_top_sale.dart';
import 'package:online_shop/features/shop/controllers/home_controller.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';

class TTopSale extends StatelessWidget {
  const TTopSale( {
    super.key, required this.banners,
  });

final List<String> banners;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            autoPlay: true,
            reverse: true,
            autoPlayInterval: Duration(seconds: 4),
            viewportFraction: 2,
            onPageChanged: (index, _) => controller.updatePageIndiciator(index)
          ),
          items: banners.map((url) => TProductCardTopSale()).toList(),
        ),
        const SizedBox(height: TSizes.spaceBetwwenItems),
        Obx(
          () => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < banners.length; i++)
               TCircularContainer(
                width: 20,
                height: 4,
                margin: EdgeInsets.only(right: 10),
                backgroundColor: controller.carouselCurrentIndex.value == i ? Colors.blue : Colors.grey,
              ), 
            ],
          ),
        )
      ],
    );
  }
}