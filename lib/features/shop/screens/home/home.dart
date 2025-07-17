import 'package:flutter/material.dart';
import 'package:online_shop/common/widgets/custom_shapes/search_bar/search_container.dart';
import 'package:online_shop/features/shop/controllers/home_controller.dart';
import 'package:online_shop/features/shop/screens/home/widgets/home_app_bar.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/primary_header_widget.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/section_heading.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/t_promo_slider.dart';
import 'package:online_shop/features/shop/screens/home/widgets/top_sale.dart';
import 'package:online_shop/utils/constants/image_strings.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
        final controller = Get.put(HomeController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TPrimaryHeader(
              child: Column(
                children: [
                  const THomeAppBar(),
                  const SizedBox(height: TSizes.spaceBetwwenSections),

             //     const TSearchContainer(text: 'Seach in store'),
                  const SizedBox(height: TSizes.spaceBetwwenSections),

                  Padding(
                    padding: const EdgeInsets.all(TSizes.defaultSpace),
                    child: Column(
                      children: [
                        TPromoSlider(
                    
                  ),
                       
                      ],
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBetwwenSections),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                children: [
                 TSectionHeading(
                          title: "Popular Categories",
                          showActionButton: false,
                          textColor: Colors.black,
                          onPressed: () {},
                        ),
                        const SizedBox(height: TSizes.spaceBetwwenItems),

                   //     THomeCategories(),
                  SizedBox(height: TSizes.spaceBetwwenSections),

                  TSectionHeading(title: 'Top Sale'),

                   TTopSale(banners: ['banners',"aa","aa","aaa","aa"]),
                  
                  TSectionHeading(title: 'Featured Products'),

                 
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
