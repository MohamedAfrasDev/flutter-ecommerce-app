import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/products/product_pricet_text.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/t_circular_image.dart';
import 'package:online_shop/features/authentication/screens/product_review_screen/product_review_screen.dart';
import 'package:online_shop/features/shop/products/widgets/product_reviews/product_reviews.dart';
import 'package:online_shop/features/shop/products/widgets/product_reviews/t_rating_and_share.dart';
import 'package:online_shop/features/shop/screens/cart/controller/cart_controller.dart';
import 'package:online_shop/features/shop/screens/cart/controller/cart_item_model.dart';
import 'package:online_shop/features/shop/screens/home/controllers/home_controllers.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/constants/image_strings.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:online_shop/utils/helpers/helper_function.dart';
import 'package:online_shop/utils/repository/product_model/product_model.dart';
import 'package:online_shop/features/shop/products/controller/time_get_controller.dart';

class TProductMetaData extends StatefulWidget {
  const TProductMetaData({
    super.key,
    required this.productName,
    required this.productPrice,
    this.isNewArrival = false,
    this.isDiscount = false,
    this.brandName = '',
    this.stock,
    this.isFreeDelivery = false,
    this.discountPrice = '',
    this.isVariation = false,
    this.productDescription = '',
    this.brandImage = '',
    required this.productModel,
    required this.rating,
  });

  final String productName,
      productPrice,
      brandName,
      discountPrice,
      productDescription,
      brandImage,
      rating;
  final bool isNewArrival, isDiscount, isFreeDelivery, isVariation;
  final int? stock;
  final ProductModel productModel;

  @override
  State<TProductMetaData> createState() => _TProductMetaDataState();
}

class _TProductMetaDataState extends State<TProductMetaData> {
  final timeGetController = Get.put(TimeGetController());
  final homeController = Get.put(HomeControllers());

  int? dDay;
  String? dMonth;
  int? shippingCost;
  bool _isReview = true;
  bool _isApprovedReviewed = true;

  String getMonthName(int month) {
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month];
  }

  String getDaySuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  final storage = GetStorage();

  @override
  void initState() {
    super.initState();

    homeController.getAppReviewEnabled().then((enable) {
      _isReview = enable;
    });

    homeController.getApprovedReviewed().then((enable) {
      _isApprovedReviewed = enable;
    });

    timeGetController.getShippingCost().then((cost) {
      setState(() {
        shippingCost = cost;
      });
    });



    timeGetController.getDeliveryTime().then((value) {
      if (value != null) {
        DateTime now = DateTime.now();
        DateTime deliveryDate = now.add(Duration(days: value));
        setState(() {
          dDay = deliveryDate.day;
          dMonth = getMonthName(deliveryDate.month);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    
    final dark = THelperFunction.isDarkMode(context);
    DateTime now = DateTime.now();
    String startDayText = '${now.day}${getDaySuffix(now.day)}';
    String startMonthText = getMonthName(now.month);
    String endDayText = dDay != null ? '$dDay${getDaySuffix(dDay!)}' : '';
    String endMonthText = dMonth ?? '';

    final double original = double.tryParse(widget.productPrice) ?? 0.0;
    final double discount = double.tryParse(widget.discountPrice) ?? 0.0;
    final bool showDiscount = widget.isDiscount && discount < original;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Title + Badges
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                widget.productName,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            Row(
              children: [
                if (widget.isNewArrival)
                  Image.asset(TImages.new_arrival_icon, width: 50, height: 50),
                if (widget.isFreeDelivery)
                  Column(
                    children: [
                      Image.asset(
                        TImages.freeDeliveryIcon,
                        width: 30,
                        height: 30,
                      ),
                      Text(
                        'Delivery',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),

        /// Brand + Rating
        Row(
          children: [
            Column(
              children: [
                Image.network(
                  widget.brandImage,
                  width: 40,
                  height: 40,
                  fit: BoxFit.contain,
                ),
                Text(widget.brandName),
              ],
            ),
            const SizedBox(width: TSizes.defaultSpace),
            if (_isReview)
              GestureDetector(
                onTap:
                    () => Get.to(
                      () => ProductReviewsScreen(
                        productID: widget.productModel.id!,
                        isApprovedReview: _isApprovedReviewed,
                      ),
                    ),
                child: TRatingAndShare(
                  productModel: widget.productModel,
                  rating: widget.rating,
                ),
              ),
          ],
        ),
        if (showDiscount) const SizedBox(height: TSizes.sm),

        /// Prices & Discounts
        /// 
        if(!widget.isVariation)
        Row(
          children: [
            if (showDiscount)
              TRoundedContainer(
                radius: TSizes.sm,
                backgroundColor: TColors.secondary.withOpacity(0.8),
                padding: const EdgeInsets.symmetric(
                  horizontal: TSizes.sm,
                  vertical: TSizes.xs,
                ),
                child: Text(
                  '${(((original - discount) / original) * 100).ceil()} %',
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge!.apply(color: Colors.black),
                ),
              ),
            if (showDiscount) const SizedBox(width: TSizes.spaceBetwwenItems),
            if (showDiscount)
              Text(
                widget.productPrice,
                style: Theme.of(context).textTheme.titleSmall!.apply(
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            const SizedBox(width: TSizes.md),
            TProductPriceText(
              price: showDiscount ? widget.discountPrice : widget.productPrice,
              isLarge: true,
            ),
          ],
        ),

        const SizedBox(height: TSizes.spaceBetwwenItems / 1.5),

        /// Stock Info
        ///
        ///
        if (!widget.isVariation)
          Row(
            children: [
              Text(
                (widget.stock != null && widget.stock! > 0)
                    ? '🟢 In Stock'
                    : '🔴 Out Of Stock',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),

        const SizedBox(height: TSizes.sm),

        /// Delivery Estimate
        Text(
          (dDay != null && dMonth != null)
              ? 'Estimated Delivery: $startDayText $startMonthText - $endDayText $endMonthText'
              : 'Loading delivery estimate...',
          style: Theme.of(context).textTheme.bodyMedium,
        ),

        const SizedBox(height: TSizes.sm),

        /// Shipping Cost
        Text('Shipping cost: ${storage.read('currency_symbol')} ${shippingCost ?? 'Loading...'}'),

        const SizedBox(height: TSizes.spaceBetwwenItems / 1.5),
      ],
    );
  }
  

}
