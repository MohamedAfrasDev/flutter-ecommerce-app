import 'package:flutter/material.dart';
import 'package:online_shop/features/shop/products/widgets/product_reviews/t_rating_bar.dart';
import 'package:online_shop/features/shop/products/widgets/product_reviews/model/review_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
Future<void> updateProduct(String productId, String newRating) async {
  final supabase = Supabase.instance.client;

  final response = await supabase
      .from('products')
      .update({
        'rating': newRating, // <-- update map
      })
      .eq('id', productId)
      .single(); // optional: only fetch single row after update

  if (response == null) {
    throw Exception("Failed to update rating");
  }
}

class TOverallProductRating extends StatelessWidget {
  final List<ReviewModel> reviews;

  const TOverallProductRating({super.key, required this.reviews, required this.productId});
  final String productId;

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) {
      return const Text("No reviews yet.");
    }

    // Count rating distribution
    final ratingCounts = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    double totalRating = 0;

    for (var review in reviews) {
      final rating = (review.ratingPoint ?? 0).round();
      if (rating >= 1 && rating <= 5) {
        ratingCounts[rating] = ratingCounts[rating]! + 1;
        totalRating += review.ratingPoint ?? 0;
      }
    }

    final totalReviews = reviews.length;
    final averageRating = (totalRating / totalReviews).toStringAsFixed(1);
    
   // updateProduct(productId, averageRating!);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Text(
            averageRating,
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
        Expanded(
          flex: 7,
          child: Column(
            children: List.generate(5, (index) {
              final star = 5 - index; // 5, 4, 3, 2, 1
              final count = ratingCounts[star]!;
              final value = totalReviews > 0 ? count / totalReviews : 0.0;
              return TRatingProgressBar(
                text: '$star',
                value: value,
              );
            }),
          ),
        ),
      ],
    );
  }
}
