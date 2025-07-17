import 'package:flutter/material.dart';
import 'package:online_shop/common/styles/layouts/grid_view_layout.dart';
import 'package:online_shop/common/widgets/brands/t_brand_showcase.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/products/product_card_vertical.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/section_heading.dart';
import 'package:online_shop/utils/constants/sizes.dart';

class TCategoryTab extends StatelessWidget {
  const TCategoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Padding(
           padding: const EdgeInsets.all(TSizes.defaultSpace),
     child: Column(
       children: [
       TBrandShowcase(images: ['assets/icons/google.png','assets/icons/facebook.png'],),
              const SizedBox(height: TSizes.spaceBetwwenItems,),

       TSectionHeading(title: 'You might like', showActionButton: true, onPressed: (){},),
       const SizedBox(height: TSizes.spaceBetwwenItems,),

       GridViewLayout(itemCount: 4, itemBuilder: (_, index) => const TProductCardVertical(productModel: null,), shrinkWrap: true,),
       const SizedBox(height: TSizes.spaceBetwwenSections,),
         ],
         ),
         
        )
      ],
    );
               
  }
}