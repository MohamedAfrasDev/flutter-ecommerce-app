import 'package:flutter/material.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/products/product_pricet_text.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/t_rounded_image.dart';
import 'package:online_shop/common/widgets/texts/product_title_text.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/constants/image_strings.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:online_shop/utils/helpers/helper_function.dart';

class TProductCardHorizontal extends StatelessWidget {
  const TProductCardHorizontal({
       super.key,
    this.brand = 'Nike',
    this.price = '100',
    this.image = TImages.productImage1,
    required this.productName,
    this.discount = false,
    this.freeDelivery = false,
    this.newArrival = false,
    this.topRated = false,
    this.brandImage = TImages.shopping_cart_icon,
    this.rated = false,
    this.variation = false,
    this.varText = '1',
   
  });

  final String brand, price;
  final String image, productName, brandImage, varText;
  final bool discount, freeDelivery, newArrival, topRated, rated, variation;



  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    return Expanded(
      child: Container(
        width: 330,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(TSizes.productImageRadius),
          color: Colors.white.withOpacity(0.15),
          border: Border.all(color: TColors.grey, width: 0.5),
        ),
        child: Row(
          children: [
            Container(
              height: double.infinity,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(2),
                    child: TRoundedImage(
                      imageUrl: image,
                      backgroundColor: Colors.white.withOpacity(0.15),
                      fit: BoxFit.cover,
                    ),
                  ),
                  if(discount)
                  TRoundedContainer(
                    radius: TSizes.sm,
                    backgroundColor: TColors.secondary.withOpacity(0.8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: TSizes.sm,
                      vertical: TSizes.xs,
                    ),
                    child: Text(
                      '25%',
                      style: Theme.of(
                        context,
                      ).textTheme.labelLarge!.apply(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
      
            const SizedBox(width: TSizes.sm),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: TProductTitleText(
                            title: productName,
                            textAlign: TextAlign.start,
                            maxLines: 2,
                          ),
                        ),
                           Padding(
                            padding: const EdgeInsets.only(right: TSizes.sm),
                            child: Image(image: AssetImage(TImages.shopping_cart_icon), width: 30, height: 30,),
                          ),
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image(
                        image: AssetImage(brandImage),
                        width: 20,
                        height: 20,
                        color: dark ? Colors.white : null,
                      ),
                      const SizedBox(width: TSizes.sm),
                      if(variation)
                      Text(varText),
                    ],
                  ),
                  
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(discount)
                        TProductPriceText(price: '300', lineThrough: true, isLarge: false,),
                  
                        TProductPriceText(price: price, isLarge: true,),
                      ],
                    ),
                  
                  ],
                 )
                ],
              ),
            ),
          ],
        ),
        
      ),
      
    );
  }
}
