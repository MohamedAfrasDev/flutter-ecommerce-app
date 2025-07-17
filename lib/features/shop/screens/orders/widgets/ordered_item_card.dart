import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/t_rounded_image.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/constants/image_strings.dart';
import 'package:online_shop/utils/constants/sizes.dart';

class TOrderedItemCard extends StatelessWidget {
  const TOrderedItemCard({
    super.key,
    required this.productName,
    required this.productPrice,
    required this.quantitiy, required this.productImage,
  });

  final String productName;
  final String productPrice;
  final String quantitiy;

  final String productImage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: TColors.dark.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(20),
          color: Colors.white.withOpacity(0.15)
        ),
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                TRoundedImage(padding: EdgeInsets.all(4),imageUrl: productImage,isNetworkImage: true, backgroundColor: Colors.transparent, width: 50, height: 50,),
          
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(height: TSizes.sm,),
                      Text(productName, style: Theme.of(context).textTheme.labelMedium, overflow: TextOverflow.ellipsis, softWrap: true,),
                     const SizedBox(height: TSizes.sm,),
                  
                      Image(image: AssetImage(TImages.apple_logo_icon), width: 15, height: 15,),
                        const SizedBox(height: TSizes.sm,),
                  
                      Text(productPrice, style: Theme.of(context).textTheme.labelMedium,),
                    ],
                  ),
                ],
              ),
          
              Padding(
                padding: const EdgeInsets.only(right: TSizes.defaultSpace),
                child: Text("Qty "+quantitiy, style: Theme.of(context).textTheme.titleMedium,),
              )
          
            ],
          ),
        ),
      ),
    );
  }
}