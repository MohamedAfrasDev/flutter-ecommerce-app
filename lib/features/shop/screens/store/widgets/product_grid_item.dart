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
import 'package:online_shop/features/shop/screens/home/controllers/home_controllers.dart';
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

class TProductGridItem extends StatefulWidget {
  const TProductGridItem({
    super.key,
  
    this.productModel,
  });


  final ProductModel? productModel;

  @override
  State<TProductGridItem> createState() => _TProductGridItemState();
}

class _TProductGridItemState extends State<TProductGridItem> {
  String formatPrice(dynamic price) {
    if (price == null) return '0';
    final value =
        double.tryParse(price.toString().replaceAll(RegExp(r'[^\d.]'), '')) ??
        0.0;
    return value % 1 == 0 ? value.toInt().toString() : value.toStringAsFixed(2);
  }

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
     onTap: () {
  print("Tapped on product: ${widget.productModel!.id!}");  // Confirm ID is valid here

  if (widget.productModel!.id==null) {
    print('❌ Product ID is empty, navigation blocked.');
    return;
  }

  Navigator.of(context).push(MaterialPageRoute(
  builder: (_) => ProductDetailScreen(
    productModel: widget.productModel!,
  ),
));

},

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
                      : Colors.white.withOpacity(0.35),
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
                      imageUrl: widget.productModel!.thumbnail!,
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

                        if (widget.productModel!.rating! > 4.0)
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
                            title: widget.productModel!.title!,
                            maxLines: 2,
                            smallSize: false,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Column(
                            children: [
                            
                              if (widget.productModel!.variation!.isNotEmpty)
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
                          image: NetworkImage(widget.productModel!.brand!.imageUrl),
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(width: TSizes.sm),
                        Expanded(
                          child: Text(
                            widget.productModel!.brand!.title,
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
                                price: formatPrice(originalPrice),
                                lineThrough: true,
                                isLarge: false,
                              ),
                            TProductPriceText(
                              price: formatPrice(salePrice),
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
                      if (!widget.productModel!.variation!.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            // Add to cart functionality
                            // You can implement your add to cart logic here
                            print(
                              'Add to cart clicked for product ID: ${widget.productModel!.id}',
                            );
                            final controller = Get.put(CartController());
                            final newItem = CartItem(
                              id: widget.productModel!.id!,
                              title: widget.productModel!.title!,
                              image: widget.productModel!.thumbnail!,
                              quantity: 1,
                              price:
                                  hasDiscount
                                      ? double.tryParse(widget.productModel!.salesPrice.toString()) ??
                                          0.0
                                      : double.tryParse(widget.productModel!.price.toString()) ?? 0.0,
                              variationAttributes:
                                  widget.productModel!.productAttributes != null
                                      ? {
                                        for (var attr
                                            in widget.productModel!.productAttributes!)
                                          (attr.name ?? ''):
                                              (attr.values?.join(', ') ?? ''),
                                      }
                                      : {},
                            );
                            controller.addToCart(newItem);
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
                      if (!widget.productModel!.variation!.isNotEmpty)
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

                      if (widget.productModel!.variation!.isNotEmpty)
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
