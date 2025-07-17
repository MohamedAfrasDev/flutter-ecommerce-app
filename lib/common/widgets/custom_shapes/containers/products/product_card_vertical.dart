import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/products/product_pricet_text.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/tags/t_discount_tag.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/t_rounded_image.dart';
import 'package:online_shop/common/widgets/texts/product_title_text.dart';
import 'package:online_shop/features/shop/products/product_detail.dart';
import 'package:online_shop/features/shop/screens/cart/controller/cart_controller.dart';
import 'package:online_shop/features/shop/screens/cart/controller/cart_item_model.dart';
import 'package:online_shop/features/shop/screens/home/controllers/home_controllers.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/constants/image_strings.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:online_shop/utils/helpers/helper_function.dart';
import 'package:online_shop/utils/repository/product_model/product_model.dart';
import 'package:online_shop/utils/theme/custom_themes/shadows.dart';

class TProductCardVertical extends StatefulWidget {
  const TProductCardVertical({
    super.key,
    required this.productModel,
    this.discount,
  });

  final ProductModel? productModel;
  final bool? discount;

  @override
  State<TProductCardVertical> createState() => _TProductCardVerticalState();
}

class _TProductCardVerticalState extends State<TProductCardVertical> {
  String formatPrice(dynamic price) {
    if (price == null) return '0';
    final value =
        double.tryParse(price.toString().replaceAll(RegExp(r'[^\d.]'), '')) ??
        0.0;
    return value % 1 == 0 ? value.toInt().toString() : value.toStringAsFixed(2);
  }

  final storage = GetStorage();

  final homeController = Get.put(HomeControllers());
  bool _isReview = true;

  @override
  void initState() {
    super.initState();
    homeController.getAppReviewEnabled().then((enable) {
      setState(() {
        _isReview = enable;
      });
      print('🟢🟢 $enable');
    });
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    final product = widget.productModel;
    if (product == null) return SizedBox();

    final defaultVariation = product.variation?.firstWhereOrNull(
      (v) => v.isDefault == true,
    );

    double originalPrice;
    double salePrice;

    // Use variation prices only if valid (>0), else product prices
    if (defaultVariation != null &&
        (defaultVariation.price != null && defaultVariation.price! > 0)) {
      originalPrice = defaultVariation.price!.toDouble();
      if (defaultVariation.salePrice != null &&
          defaultVariation.salePrice! > 0) {
        salePrice = defaultVariation.salePrice!.toDouble();
      } else {
        salePrice = originalPrice;
      }
    } else {
      originalPrice = product.price?.toDouble() ?? 0.0;
      salePrice =
          (product.salesPrice != null && product.salesPrice! > 0)
              ? product.salesPrice!.toDouble()
              : originalPrice;
    }

    final bool hasDiscount = salePrice < originalPrice;

    final String discountPercent =
        hasDiscount
            ? '${(((originalPrice - salePrice) / originalPrice) * 100).round()}%'
            : '';

    final displayRating = product.rating ?? 0.0;

    return GestureDetector(
      onTap: () => Get.to(() => ProductDetailScreen(productModel: product)),
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Container(
          width: 200,
          padding: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            color:
                dark
                    ? Colors.white.withOpacity(0.25)
                    : Colors.white.withOpacity(0.35),
            borderRadius: BorderRadius.circular(TSizes.productImageRadius),
            border: Border.all(
              color:
                  dark
                      ? Colors.white.withOpacity(0.35)
                      : Colors.white.withOpacity(0.35),
            ),
            boxShadow: [TShadowStyle.verticalProductShadow],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TRoundedContainer(
                borderColor: Colors.transparent,
                height: 150,
                padding: const EdgeInsets.all(TSizes.sm),
                backgroundColor: Colors.transparent,
                child: Stack(
                  children: [
                    TRoundedImage(
                      imageUrl: product.thumbnail ?? '',
                      width: double.infinity,
                      height: TSizes.productItemHeight,
                      isNetworkImage: true,
                      fit: BoxFit.contain,
                      padding: const EdgeInsets.all(TSizes.sm),
                      backgroundColor:
                          dark
                              ? Colors.white.withOpacity(0.05)
                              : Colors.white.withOpacity(0.15),
                      border: Border.all(
                        color:
                            dark
                                ? Colors.white.withOpacity(0.15)
                                : Colors.grey.withOpacity(0.1),
                        width: 1,
                      ),
                      applyImageRadius: true,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (hasDiscount)
                          TDiscountTag(discount: discountPercent),
                        if (displayRating >= 4.0)
                          Image.asset(
                            TImages.top_rated_icon,
                            width: 40,
                            height: 40,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: TSizes.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TProductTitleText(
                      textAlign: TextAlign.start,
                      title: product.title ?? '',
                      maxLines: 2,
                      smallSize: false,
                    ),
                    const SizedBox(height: TSizes.spaceBetwwenItems / 2),
                    Row(
                      children: [
                        Image.network(
                          product.brand?.imageUrl ?? '',
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(width: TSizes.sm),
                        Expanded(
                          child: Text(
                            product.brand?.title ?? '',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(width: TSizes.spaceBetwwenItems),

                        if (product.variation!.isNotEmpty)
                          Column(
                            children: [
                              Image.asset(
                                TImages.productVariationIcon,
                                width: 20,
                                color: dark ? Colors.white : TColors.primary,
                                height: 20,
                              ),
                              Text(
                                'Variation',
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: TSizes.sm),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (hasDiscount)
                          TProductPriceText(
                            price: formatPrice(originalPrice),
                            lineThrough: true,
                            isLarge: false,
                          ),
                        TProductPriceText(
                          price: formatPrice(salePrice),
                          isLarge: true,
                          color: hasDiscount ? Colors.amber : null,
                        ),
                        Column(
                          children: [
                            if (_isReview == true)
                              Row(
                                children: [
                                  const Icon(Iconsax.star, color: Colors.amber),
                                  Text(displayRating.toString()),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                    if ((product.variation?.isNotEmpty ?? false))
                      GestureDetector(
                        onTap:
                            () => Get.to(
                              () => ProductDetailScreen(productModel: product),
                            ),
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                dark
                                    ? Colors.white.withOpacity(0.20)
                                    : TColors.primary,
                            border: Border.all(
                              color:
                                  dark
                                      ? Colors.white.withOpacity(0.5)
                                      : TColors.dark.withOpacity(0.2),
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              'View',
                              style: Theme.of(context).textTheme.titleSmall!
                                  .apply(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      )
                    else
                      GestureDetector(
                        onTap: () {
                          final controller = Get.put(CartController());
                          controller.addToCart(
                            CartItem(
                              id: product.id ?? '',
                              title: product.title ?? '',
                              image: product.thumbnail ?? '',
                              quantity: 1,
                              price: salePrice,
                              variationAttributes: {},
                            ),
                          );
                          Get.snackbar(
                            "Added",
                            "Product added to cart",
                            backgroundColor: TColors.primary,
                            colorText: Colors.white,
                          );
                        },
                        child: Image.asset(
                          TImages.shopping_cart_icon,
                          width: 30,
                          height: 30,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
