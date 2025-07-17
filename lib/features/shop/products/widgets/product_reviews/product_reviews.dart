import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:online_shop/common/widgets/custom_shapes/appbar/appbar.dart';
import 'package:online_shop/features/shop/products/widgets/product_reviews/controller/review_controller.dart';
import 'package:online_shop/features/shop/products/widgets/product_reviews/overall_product_rating.dart';
import 'package:online_shop/features/shop/products/widgets/product_reviews/t_rating_bar_indicator.dart';
import 'package:online_shop/features/shop/products/widgets/product_reviews/user_review_card.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:online_shop/utils/formatters/formatters.dart';
import 'package:online_shop/utils/helpers/helper_function.dart';
import 'package:uuid/uuid.dart';

class ProductReviewsScreen extends StatelessWidget {
  ProductReviewsScreen({
    super.key,
    this.productID,
    required this.isApprovedReview,
  });
  final controller = Get.put(ReviewController());

  final String? productID;
  final bool isApprovedReview;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);

    if (productID != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.fetchReviews(productID!);
      });
    }
    return Scaffold(
      appBar: const TAppBar(
        title: Text('Reviews & Ratings'),
        showBackArrrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ratings and reviews are verified and from people who use the same type of item that you see.',
              ),
              const SizedBox(height: TSizes.spaceBetwwenItems),

              Obx(
                () => TOverallProductRating(
                  reviews: controller.reviews.toList(),
                  productId: productID!,
                ),
              ),

              const TRatingBarIndicator(rating: 4.5),
              Text("12,611", style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: TSizes.spaceBetwwenSections),

              // --- User Input Section ---
              Text(
                isApprovedReview ==true ?"Buy this product to review" : 'Your Review',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: TSizes.spaceBetwwenItems),

              if(isApprovedReview != true)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => RatingBar.builder(
                      initialRating: controller.userRating.value,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemBuilder:
                          (context, _) =>
                              const Icon(Icons.star, color: Colors.amber),
                      onRatingUpdate: (rating) {
                        controller.userRating.value = rating;
                      },
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBetwwenItems),

                  TextField(
                    controller: controller.reviewController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: "Write your review here...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                   const SizedBox(height: TSizes.spaceBetwwenItems),

              GestureDetector(
                onTap: () {
                  controller.addReviewToProduct(
                    productID!,
                    'userId',
                    controller.reviewController.text,
                    controller.userRating.value,
                    controller.reviews,
                    Uuid().v4(),
                  );
                  //  controller.updateProduct(productID!);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: TColors.primary,
                    border: Border.all(
                      color:
                          dark
                              ? Colors.grey.withOpacity(0.5)
                              : TColors.dark.withOpacity(0.2),
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),

                    child: Text(
                      'Submit Review',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
                ],
              ),
             
              const SizedBox(height: TSizes.spaceBetwwenSections),

              // --- List of Submitted Reviews ---
              Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      controller.reviews
                          .sorted(
                            (a, b) => b.timestamp!.compareTo(a.timestamp!),
                          ) // 🔁 Sort by latest timestamp
                          .map((review) {
                            return Card(
                              margin: const EdgeInsets.only(bottom: 16),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RatingBarIndicator(
                                      rating: review.ratingPoint ?? 0,
                                      itemBuilder:
                                          (context, _) => const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                      itemCount: 5,
                                      itemSize: 20.0,
                                      direction: Axis.horizontal,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(review.reviewText ?? ''),
                                    if (review.timestamp != null)
                                      Text(
                                        '${TFormatters.formatDate(review.timestamp!)}',
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.bodySmall,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          })
                          .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
