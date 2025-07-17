import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:online_shop/features/shop/products/widgets/product_reviews/model/review_model.dart';
import 'package:uuid/uuid.dart';

class ReviewController extends GetxController {
  final RxDouble userRating = 0.0.obs;
  final RxList<ReviewModel> reviews = <ReviewModel>[].obs;
  final reviewController = TextEditingController();

  Future<void> fetchReviews(String productID) async {
    final supabase = Supabase.instance.client;

    final response = await supabase
        .from('products')
        .select('reviews')
        .eq('id', productID)
        .single();

    final List<dynamic> jsonList = response['reviews'] ?? [];

    reviews.assignAll(jsonList.map((e) => ReviewModel.fromJson(e)).toList());
  }
Future<String?> checkWhetherReviewed(String productId) async {
  final supabase = Supabase.instance.client;

  final response = await supabase
      .from('products')
      .select('reviews')
      .eq('id', productId)
      .single();

  final List<dynamic> reviewsJson = response['reviews'] ?? [];

  for (final review in reviewsJson) {
    return review['userID']; // Return the first userID found
  }

  return null; // Return null if no reviews found
}

Future<String?> checkOrderId(String productId) async {
  final supabase = Supabase.instance.client;

  final response = await supabase
      .from('products')
      .select('reviews')
      .eq('id', productId)
      .single();

  final List<dynamic> reviewsJson = response['reviews'] ?? [];

  for (final review in reviewsJson) {
    return review['orderID']; // Return the first userID found
  }

  return null; // Return null if no reviews found
}


Future<void> updateProduct(String productId) async {
  final supabase = Supabase.instance.client;

  try {
    // Step 1: Fetch latest reviews
    final response = await supabase
        .from('products')
        .select('reviews')
        .eq('id', productId)
        .maybeSingle(); // Use maybeSingle to avoid throwing if not found

    if (response == null || response['reviews'] == null) {
      throw Exception('No reviews found for this product');
    }

    final List<dynamic> jsonList = response['reviews'];
    final fetchedReviews = jsonList.map((e) => ReviewModel.fromJson(e)).toList();

    // Step 2: Calculate average
    double totalRating = 0;

    for (var review in fetchedReviews) {
      totalRating += review.ratingPoint ?? 0;
    }

    final totalReviews = fetchedReviews.length;
    final averageRating =
        totalReviews == 0 ? 0.0 : double.parse((totalRating / totalReviews).toStringAsFixed(1));

    // Step 3: Update product
await supabase
    .from('products')
    .update({'rating': averageRating})
    .eq('id', productId);

print('✅ Rating updated successfully.');


  } catch (e) {
    // Catch and print any errors
    debugPrint(e.toString());
    throw Exception("🔴 Failed to update product rating. ${e.toString()}");
  }
}


  Future<void> addReviewToProduct(
      String productId, String userId, String reviewText, double rating, List<ReviewModel> review, String orderID) async {
    final supabase = Supabase.instance.client;

    // Get existing reviews
    final response = await supabase
        .from('products')
        .select('reviews')
        .eq('id', productId)
        .single();

    final List<dynamic> currentReviews = response['reviews'] ?? [];

    final storage = GetStorage();

    final newReview = ReviewModel(
      reviewID: const Uuid().v4(),
      userID: storage.read('UID'),
      ratingPoint: rating,
      productID: productId,
      reviewText: reviewText,
      orderID: orderID,
      timestamp: DateTime.now(),
    );

updateProduct(productId);
    currentReviews.add(newReview.toJson());

   final updateRating =  await supabase
        .from('products')
        .update({'reviews': currentReviews})
        .eq('id', productId);

    
    // Refresh list

    await fetchReviews(productId);
  
    // Clear form
    userRating.value = 0.0;
    reviewController.clear();
    updateProduct(productId);
  }
}
