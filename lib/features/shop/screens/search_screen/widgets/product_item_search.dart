import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/tags/t_discount_tag.dart';
import 'package:online_shop/common/widgets/icons/circular_icons.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/products/product_pricet_text.dart';
import 'package:online_shop/common/widgets/texts/product_title_text.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/t_rounded_image.dart';
import 'package:online_shop/features/shop/products/product_detail.dart';
import 'package:online_shop/features/shop/screens/cart/controller/cart_controller.dart';
import 'package:online_shop/features/shop/screens/cart/controller/cart_item_model.dart';
import 'package:online_shop/features/shop/screens/wishlists/controller/whishlist_controller.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/constants/image_strings.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:online_shop/utils/helpers/helper_function.dart';
import 'package:online_shop/utils/repository/product_model/attributes_model.dart';
import 'package:online_shop/utils/repository/product_model/product_model.dart';
import 'package:online_shop/utils/repository/product_model/variation_model.dart';
import 'package:online_shop/utils/theme/custom_themes/shadows.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:get/get.dart';

class TProductItemSearch extends StatefulWidget {
  const TProductItemSearch({
    super.key,
   
    required this.productModel
  });


 
  final ProductModel productModel;

  @override
  State<TProductItemSearch> createState() => _TProductItemSearchState();
}

class _TProductItemSearchState extends State<TProductItemSearch> {
  ProductVariantionsModel? variantionsModel;

  /// Removes any non-numeric characters except for dots
  String sanitizeToNumeric(String value) {
    return value.replaceAll(RegExp(r'[^\d.]'), '');
  }


  

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);

    if (widget.productModel.variation!.isNotEmpty) {
      variantionsModel = widget.productModel.variation!.first;
    }

    final bool discount =
        widget.productModel!.salesPrice != null &&
        widget.productModel!.salesPrice! > 0 &&
        widget.productModel!.salesPrice! < widget.productModel!.price!;
    String formatPrice(dynamic price) {
      if (price == null) return '0';

      double? value;
      if (price is String) {
        final sanitized = price.replaceAll(RegExp(r'[^\d.]'), '');
        value = double.tryParse(sanitized);
      } else if (price is num) {
        value = price.toDouble();
      }

      if (value == null) return '0';

      // Remove .00 for whole numbers
      if (value % 1 == 0) {
        return value.toInt().toString();
      } else {
        return value.toStringAsFixed(2); // keep 2 decimal places for fractional
      }
    }

    // Get default variation if available
    ProductVariantionsModel? defaultVariation;
    if (widget.productModel.variation != null && widget.productModel.variation!.isNotEmpty) {
      defaultVariation = widget.productModel.variation!.firstWhereOrNull(
        (v) => v.isDefault == true,
      );
    }

    // Use helper to get price strings safely
    final String originalPriceStr =
        defaultVariation != null
            ? formatPrice(defaultVariation.price)
            : widget.productModel.price.toString();
                            final controller = Get.put(WishlistController());

    final String salePriceStr =
        defaultVariation != null
            ? (defaultVariation.salePrice != null &&
                    defaultVariation.salePrice! > 0
                ? formatPrice(defaultVariation.salePrice)
                : originalPriceStr)
            : (discount ? widget.productModel.salesPrice.toString() : widget.productModel.price.toString());

    // Parse to double to calculate discount percent
    final double? originalPriceDouble = double.tryParse(originalPriceStr);
    final double? salePriceDouble = double.tryParse(salePriceStr);

    // Calculate discount percent
    String discountPercent = '';
    if (originalPriceDouble != null &&
        salePriceDouble != null &&
        salePriceDouble < originalPriceDouble) {
      final discountVal =
          (((originalPriceDouble - salePriceDouble) / originalPriceDouble) *
                  100)
              .toInt();
      discountPercent = '$discountVal%';
    }

    // Determine if discount applies
    final bool hasDiscount =
        defaultVariation != null
            ? (defaultVariation.salePrice != null &&
                defaultVariation.salePrice! > 0 &&
                defaultVariation.salePrice! < defaultVariation.price)
            : discount;


    return GestureDetector(
      onTap:
          () => Get.to(
            () => ProductDetailScreen(
              productModel: widget.productModel,
            ),
          ),
      child: Padding(
        padding: const EdgeInsets.only(right: 10, left: 10),
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
                      : TColors.dark.withOpacity(0.35),
              width: 1.0,
            ),
            boxShadow: [TShadowStyle.verticalProductShadow],
          ),
          child: Column(
            children: [
              TRoundedContainer(
                borderColor: Colors.transparent,
                height: 150,
                padding: const EdgeInsets.all(TSizes.sm),
                backgroundColor: Colors.transparent,
                child: Stack(
                  children: [
                    TRoundedImage(
                      imageUrl: widget.productModel.thumbnail!,
                      width: double.infinity,
                      height: TSizes.productItemHeight,
                      isNetworkImage: true,
                      fit: BoxFit.contain,
                      padding: EdgeInsets.all(TSizes.sm),
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

                        if (widget.productModel.rating! > 4.0)
                          Image(
                            image: AssetImage(TImages.top_rated_icon),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: TProductTitleText(
                            textAlign: TextAlign.start,
                            title: widget.productModel.title!,
                            maxLines: 2,
                            smallSize: false,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Column(
                            children: [
                              

                              if (widget.productModel.variation!.isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Image(
                                      image: AssetImage(
                                        TImages.productVariationIcon,
                                      ),
                                      width: 30,
                                      color:
                                          dark ? Colors.white : TColors.primary,
                                      height: 30,
                                    ),
                                    Text(
                                      'Variations',
                                      style:
                                          Theme.of(
                                            context,
                                          ).textTheme.labelSmall,
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: TSizes.spaceBetwwenItems / 2),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image(
                          image: NetworkImage(widget.productModel.brand!.imageUrl),
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(width: TSizes.sm),
                        Expanded(
                          child: Text(
                            widget.productModel.brand!.title,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: TSizes.sm),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (hasDiscount)
                              TProductPriceText(
                                price: originalPriceStr,
                                lineThrough: true,
                                isLarge: false,
                              ),
                            TProductPriceText(
                              price: salePriceStr,
                              isLarge: true,
                              color: hasDiscount ? Colors.amber : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: TSizes.sm,),
                  //BuyNowOption
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (!widget.productModel.variation!.isNotEmpty)
                      if(widget.productModel.stock! > 0)
                        GestureDetector(
                          onTap: () {
                            // Add to cart functionality
                            // You can implement your add to cart logic here
                            print(
                              'Add to cart clicked for product ID: ${widget.productModel.id}',
                            );
                            final controller = Get.put(CartController());
                            final newItem = CartItem(
                              id: widget.productModel.id!,
                              title: widget.productModel.title!,
                              image: widget.productModel.thumbnail!,
                              quantity: 1,
                              price:
                                  discount
                                      ? double.tryParse(widget.productModel.salesPrice.toString()) ??
                                          0.0
                                      : double.tryParse(widget.productModel.price.toString()) ?? 0.0,
                              variationAttributes:
                                  widget.productModel.productAttributes != null
                                      ? {
                                        for (var attr
                                            in widget.productModel.productAttributes!)
                                          (attr.name ?? ''):
                                              (attr.values?.join(', ') ?? ''),
                                      }
                                      : {},
                            );
                            
                            controller.addToCart(newItem);
                            Get.snackbar('Product Added To Cart', 'You have added ${widget.productModel.title} to your cart', backgroundColor: TColors.primary, colorText: Colors.white);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: SizedBox(
                              width: TSizes.iconLg,
                              height: TSizes.iconLg,
                              child: Center(
                                child: Image(
                                  image: AssetImage(TImages.shopping_cart_icon),
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                            ),
                          ),
                        ),

                        if(widget.productModel.stock! < 1 && widget.productModel.variation!.isEmpty)
                        GestureDetector(
                          onTap: () {
                            // Add to cart functionality
                            // You can implement your add to cart logic here
                            print(
                              'Add to cart clicked for product ID: ${widget.productModel.id}',
                            );
                            

                            controller.isInWishlist(widget.productModel.id!) ? controller.removeFromWishlist(widget.productModel.id!) : controller.addToWishlist(widget.productModel);
                            
                        controller.isInWishlist(widget.productModel.id!) ? Get.snackbar( 'Product Added To Whishlist', 'You have added ${widget.productModel.title} to whishlist', backgroundColor: TColors.primary, colorText: Colors.white) : Get.snackbar( 'Product Removed From Whishlist', 'You have removed ${widget.productModel.title} from whishlist', backgroundColor: TColors.primary, colorText: Colors.white);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: SizedBox(
                              width: TSizes.iconLg,
                              height: TSizes.iconLg,
                              child: Center(
                                child: Obx(() {
                                  return Icon(
                                  Iconsax.heart,
                                  color: controller.isInWishlist(widget.productModel.id!) ? Colors.red : Colors.grey ,
                                );
                              
                                })
                              ),
                            ),
                          ),
                        ),

                      if (!widget.productModel.variation!.isNotEmpty)
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                              color: TColors.primary,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                "Buy Now",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),

                      if (widget.productModel.variation!.isNotEmpty)
                        Expanded(
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              decoration: BoxDecoration(
                                color: TColors.primary,
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  'View',
                                  style: TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
