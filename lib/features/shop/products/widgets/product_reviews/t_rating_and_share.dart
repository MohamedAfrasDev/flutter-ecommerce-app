import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:online_shop/features/shop/products/widgets/product_reviews/controller/review_controller.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:online_shop/utils/repository/product_model/product_model.dart';


class TRatingAndShare extends StatelessWidget {
  const TRatingAndShare({
    super.key, required this.productModel, required this.rating,
  });

  final ProductModel productModel;
  final String rating;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReviewController());
        final displayRating = productModel.rating ?? 0.0;

        print("🟢🟢🟢 ${productModel.rating.toString()}");

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //Rating
        Row(
          children: [
            Icon(Iconsax.star, color: Colors.amber, size: 24,),
            SizedBox(width: TSizes.spaceBetwwenItems / 4,),
            Text('${rating}'),
            Icon(Iconsax.arrow_right_3_copy, color: Colors.amber, size: 20,),
            Text('${controller.reviews.length.toString()} Reviews')
          ],
        ),
        //Share Button
      ]
      );
  }
}