import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_shop/common/widgets/custom_shapes/appbar/appbar.dart';
import 'package:online_shop/features/authentication/screens/product_review_screen/widgets/product_review_input.dart';
import 'package:online_shop/features/authentication/screens/product_review_screen/widgets/review_product_item.dart';
import 'package:online_shop/features/shop/products/widgets/product_reviews/controller/review_controller.dart';
import 'package:online_shop/features/shop/screens/cart/controller/cart_item_model.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:online_shop/utils/helpers/models/order_model.dart';
import 'package:online_shop/utils/repository/product_model/product_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductReviewScreen extends StatefulWidget {
  const ProductReviewScreen({super.key, required this.orderModel});
  final OrderModel orderModel;

  @override
  State<ProductReviewScreen> createState() => _ProductReviewScreenState();
}

class _ProductReviewScreenState extends State<ProductReviewScreen> {
  final ReviewController controller = Get.put(ReviewController());

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (final item in widget.orderModel.products) {
        final product = item as Map<String, dynamic>;
        final productId = product['id'];

        checkReview(productId, controller, widget.orderModel.orderID!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: TSizes.spaceBetwwenItems),
            TAppBar(
              title: Text(widget.orderModel.orderID ?? ''),
              showBackArrrow: true,
            ),
            const SizedBox(height: TSizes.spaceBetwwenItems),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.orderModel.products.length,
              itemBuilder: (context, index) {
                final product = widget.orderModel.products[index] as Map<String, dynamic>;
                final cartItem = CartItem.fromJson(product);
                final productModel = ProductModel.fromJson(product);

                return Column(
                  children: [
                    RevviewProductItem(cartItem: cartItem),
                    ProductReviewInput(
                      productID: product['id'],
                      products: productModel,
                      orderID: widget.orderModel.orderID ?? '',
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: TSizes.spaceBetwwenItems),
          ],
        ),
      ),
    );
  }

  void checkReview(String productId, ReviewController controller, String orderID) async {
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;
    final userId = await controller.checkWhetherReviewed(productId);
    final orderId = await controller.checkOrderId(productId);

    print('💵 OrderId in DB: $orderId');
    print('📞 Current OrderId: $orderID');
    print('asas🟢🟢 $currentUserId');

    if (userId == 'userId' && orderID == orderId) {
      print('🟢 User already reviewed this product');
      Get.back();
      Get.snackbar(
        'Review Found',
        'You have already reviewed this product.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: TColors.primary,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      );
      
    } else {
      print('🔴 No previous review found');
    }
  }
}
