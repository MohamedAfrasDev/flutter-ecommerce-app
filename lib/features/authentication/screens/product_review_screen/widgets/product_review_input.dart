import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:get/utils.dart';
import 'package:online_shop/features/shop/products/widgets/product_reviews/controller/review_controller.dart';
import 'package:online_shop/features/shop/products/widgets/product_reviews/model/review_model.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:online_shop/utils/helpers/helper_function.dart';
import 'package:online_shop/utils/repository/product_model/product_model.dart';
import 'package:uuid/uuid.dart';

class ProductReviewInput extends StatefulWidget {
  const ProductReviewInput({super.key, required this.productID, required this.products, required this.orderID});

  final String productID;
  final ProductModel products;
  final String orderID;

  @override
  State<ProductReviewInput> createState() => _ProductReviewInputState();
}

class _ProductReviewInputState extends State<ProductReviewInput> {
    late final ReviewController controller;

  @override
  void initState() {
    super.initState();
    controller = ReviewController();  // new instance per product input
  }
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    print("👉👉👉 ${widget.productID}");
    return Container(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                 Text("Your Review for ${widget.products.title}", style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: TSizes.spaceBetwwenItems),
          
                Obx(() => RatingBar.builder(
                      initialRating: controller.userRating.value,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                      onRatingUpdate: (rating) {
                        controller.userRating.value = rating;
                      },
                    )),
                const SizedBox(height: TSizes.spaceBetwwenItems),
          
                TextField(
                  controller: controller.reviewController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: "Write your review here...",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: TSizes.spaceBetwwenItems,),

                GestureDetector(
                  onTap: () {
                     controller.addReviewToProduct(widget.productID, 'userId', controller.reviewController.text, controller.userRating.value, controller.reviews, widget.orderID);
                  controller.updateProduct(widget.productID);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: TColors.primary,
                      border: Border.all(color: dark ? Colors.grey.withOpacity(0.5) : TColors.dark.withOpacity(0.2)),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text('Submit Review', style: Theme.of(context).textTheme.titleMedium!.apply(color: Colors.white),),
                    ),
                  ),
                ),
                
            ],
            
          ),
        ),
      ),
    );
  }
}