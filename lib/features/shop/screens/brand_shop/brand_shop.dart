import 'package:flutter/material.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/section_heading.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/t_promo_slider.dart';
import 'package:online_shop/features/shop/screens/brand_shop/widgets/t_brand_shop_header.dart';
import 'package:online_shop/utils/constants/image_strings.dart';

class BrandShopScreen extends StatelessWidget {
  const BrandShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
        children: [
          TBrandShopHeader(),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TPromoSlider(
                  
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TSectionHeading(title: 'Popular Products From'),
                      Text('Afras', style: Theme.of(context).textTheme.headlineSmall,)
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
      ),
    );
  }
}

