import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:online_shop/common/styles/layouts/grid_view_layout.dart';
import 'package:online_shop/common/widgets/custom_shapes/appbar/appbar.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/section_heading.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/t_promo_slider.dart';
import 'package:online_shop/common/widgets/icons/circular_icons.dart';
import 'package:online_shop/features/personailization/controllers/address_add_controller.dart';
import 'package:online_shop/features/shop/controllers/home_controller.dart';
import 'package:online_shop/features/shop/products/controller/product_controller.dart';
import 'package:online_shop/features/shop/products/controller/time_get_controller.dart';
import 'package:online_shop/features/shop/products/widgets/bottom_add_card.dart';
import 'package:online_shop/features/shop/products/widgets/product_attributes.dart';
import 'package:online_shop/features/shop/products/widgets/product_reviews/controller/review_controller.dart';
import 'package:online_shop/features/shop/products/widgets/product_reviews/product_reviews.dart';
import 'package:online_shop/features/shop/products/widgets/t_product_meta_data.dart';
import 'package:online_shop/features/shop/products/widgets/t_product_slider.dart';
import 'package:online_shop/features/shop/screens/cart/cart.dart';
import 'package:online_shop/features/shop/screens/cart/controller/cart_controller.dart';
import 'package:online_shop/features/shop/screens/cart/controller/cart_item_model.dart';
import 'package:online_shop/features/shop/screens/checkout/checkout.dart';
import 'package:online_shop/features/shop/screens/checkout/controller/payment_controller.dart';
import 'package:online_shop/features/shop/screens/checkout/widgets/billing_address_section.dart';
import 'package:online_shop/features/shop/screens/checkout/widgets/billing_amount_section.dart';
import 'package:online_shop/features/shop/screens/home/controllers/home_controllers.dart';
import 'package:online_shop/features/shop/screens/home/widgets/product_slider_category_horizontal.dart';
import 'package:online_shop/features/shop/screens/order_successful_screen/order_successful.dart';
import 'package:online_shop/features/shop/screens/store/controller/store_controller.dart';
import 'package:online_shop/features/shop/screens/store/widgets/product_grid_item.dart';
import 'package:online_shop/features/shop/screens/wishlists/controller/whishlist_controller.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/constants/image_strings.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:online_shop/utils/constants/text_strings.dart';
import 'package:online_shop/utils/helpers/helper_function.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:online_shop/utils/helpers/models/address_model.dart';
import 'package:online_shop/utils/helpers/models/order_model.dart';
import 'package:online_shop/utils/http/payments/payhere/config.dart';
import 'package:online_shop/utils/repository/product_model/attributes_model.dart';
import 'package:online_shop/utils/repository/product_model/brand_model.dart';
import 'package:online_shop/utils/repository/product_model/product_model.dart';
import 'package:online_shop/utils/repository/product_model/variation_model.dart';
import 'package:readmore/readmore.dart';
import 'package:get/get.dart';

class ProductDetailScreen extends StatefulWidget {
  ProductDetailScreen({super.key, this.productModel});

  final ProductModel? productModel;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
  bool _isAvailable = false;
  bool _isReviewEnabled = true;

  String _reviewsLength = '';
  Map<String, String> parseAttributes(dynamic jsonAttrs) {
    if (jsonAttrs == null) return {};
    // if jsonAttrs is Map<dynamic,dynamic>, convert keys and values to String
    return Map<String, String>.from(jsonAttrs);
  }

  // When adding to cart:
  late Map<String, String> savedAttrs;
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  ProductVariantionsModel? selectedVariation;
  final reviewController = Get.put(ReviewController());
  final storeController = Get.put(StoreController());

  final homeController = Get.put(HomeControllers());
  List<AddressModel> addresses = [];
  AddressModel? selectedAddress;

  final paymentController = Get.put(PaymentController());

  var feeStructure = ''.obs;

  Future<void> loadAddresses() async {
    final loadedAddresses = await AddressAddController.instance.getAddresses();
    setState(() {
      addresses = loadedAddresses;
      if (addresses.isNotEmpty) {
        selectedAddress ??= addresses.first;
      }
    });
  }

  final cartCont = Get.put(CartController());
  @override
  void initState() {
    super.initState();
    cartCont.getProcessingFeeStructure().then((value) {
      feeStructure.value = value.toString().toLowerCase();
    });

    ever(paymentController.isPay, (value) {
      print('🔄 isPay changed to: $value');
      paymentController.isPay.value = value;
    });
    loadAddresses();
    homeController.getAppReviewEnabled().then((enable) {
      widget._isReviewEnabled = enable;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      reviewController.fetchReviews(widget.productModel!.id!);
      storeController.fetchProducts(); // safe to call here
    });

    widget._reviewsLength = reviewController.reviews.length.toString();

    var paymentMethod = 'Cash on delivery'.obs;

    final storage = GetStorage();

    var processingFee = 0.0.obs;
    var processingAmount = 0.0.obs;

    var orderAmount = 0.0.obs;
    var amountIncluded = 0.0.obs;

    final cartCon = Get.put(CartController());

    Future<void> _initPaymentDetails(String paymentMethods) async {
      paymentMethod.value = paymentMethods; // 🟩 or get from widget/args
      paymentController.paymentMethod.value = paymentMethods;

      final fee = await paymentController.getProcessingFee(paymentMethod.value);
      final controller = Get.put(CartController());

      orderAmount = controller.totalPrice.obs;

      amountIncluded = controller.totalPrice.obs;
      paymentController.isPay.value = paymentMethod.value != 'Cash on delivery';

      setState(() {
        processingFee.value = fee.toDouble();
        double totalAmount = controller.totalPriceFast;
        double processingFeeAmount =
            ((totalAmount * processingFee.value) / 100);
        double finalAmount = (totalAmount + processingFeeAmount);

        amountIncluded.value = totalAmount;
        orderAmount.value = finalAmount;
        processingAmount.value = processingFeeAmount.toDouble();

        print("saas ${storage.read('shippingCost')}");
      });
    }

    setState(() {
      if (widget.productModel!.variation!.isNotEmpty &&
          widget.productModel!.variation != null &&
          widget.productModel!.variation!.isNotEmpty) {
        selectedVariation = widget.productModel!.variation!.first;
        widget._isAvailable = (selectedVariation!.stock > 0) ? true : false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    print(widget.productModel!.variation!.isNotEmpty);
    print(widget.productModel!.stock);

    final controllerWhishlist = Get.put(WishlistController());

    final defaultVariation = widget.productModel!.variation?.firstWhereOrNull(
      (v) => v.isDefault == true,
    );

    print('${widget._isAvailable} 🔴🔴');
    double originalPrice;
    double salePrice;
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
      originalPrice = widget.productModel!.price?.toDouble() ?? 0.0;
      salePrice =
          (widget.productModel!.salesPrice != null &&
                  widget.productModel!.salesPrice! > 0)
              ? widget.productModel!.salesPrice!.toDouble()
              : originalPrice;
    }

    final bool hasDiscount =
        widget.productModel!.salesPrice != null &&
        widget.productModel!.salesPrice! > 0 &&
        widget.productModel!.salesPrice! < widget.productModel!.price!;

    final String discountPercent =
        hasDiscount
            ? '${(((originalPrice - salePrice) / originalPrice) * 100).round()}%'
            : '';

    final bool variationDiscount =
        (selectedVariation != null)
            ? selectedVariation!.salePrice < selectedVariation!.price
            : false;

    print('🎫🎫🎫 ${widget.productModel!.rating.toString()}');
    final BrandModel brand = BrandModel(
      title: widget.productModel!.brand!.title,
      category: 'category',
      isFeatured: false,
      imageUrl: widget.productModel!.brand!.imageUrl,
    );
    final ProductModel productModel = ProductModel(
      id: widget.productModel!.id,
      sku: '',
      isFeatured: false,
      title: widget.productModel!.title,
      variation: widget.productModel!.variation,
      description: widget.productModel!.description,
      stock: widget.productModel!.stock ?? 0,
      images:
          widget.productModel!.images!, // or widget.productImage inside a list
      brand: brand,
      date: DateTime.now(),
      offerValue: '',
      price: double.tryParse(widget.productModel!.price.toString()) ?? 0.0,
      productAttributes: widget.productModel!.productAttributes ?? [],
      productType: '',
      rating: 0,
      salesPrice:
          double.tryParse(widget.productModel!.salesPrice.toString()) ?? 0.0,
      thumbnail: widget.productModel!.thumbnail,
    );
    return Scaffold(
      bottomNavigationBar:
          widget.productModel!.variation!.isNotEmpty
              ? (selectedVariation != null
                  ? TBottomAddCart(
                    isVariation: true,
                    productModel: productModel,
                    productID: selectedVariation!.id,
                    stock: selectedVariation!.stock,
                    productName: widget.productModel!.title!,
                    variationAttributes: selectedVariation!.attributesValues,
                    productImage: selectedVariation!.image.value,
                    isAvailable:
                        selectedVariation!.stock > 0, // 👈 Updated condition
                    productPrice:
                        (selectedVariation!.salePrice != null &&
                                selectedVariation!.salePrice > 0)
                            ? selectedVariation!.salePrice.toString()
                            : selectedVariation!.price.toString(),
                  )
                  : const SizedBox.shrink())
              : TBottomAddCart(
                productModel: productModel,
                isVariation: false,
                stock: widget.productModel!.stock,
                productID: widget.productModel!.id!,
                productName: widget.productModel!.title!,
                productImage: widget.productModel!.thumbnail!,
                isAvailable:
                    (widget.productModel!.stock ?? 0) > 0, // 👈 Updated
                productPrice:
                    hasDiscount
                        ? widget.productModel!.salesPrice.toString()
                        : widget.productModel!.price!.toString(),
              ),

      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0.8, 0.7),
            radius: 1.8,
            colors: [
              dark
                  ? TColors.primary.withOpacity(0.7)
                  : TColors.primary.withOpacity(0.7),
              dark
                  ? TColors.accent.withOpacity(0.7)
                  : TColors.accent.withOpacity(0.7),
              dark
                  ? TColors.accent.withOpacity(0.4)
                  : TColors.accent.withOpacity(0.4),
              dark
                  ? TColors.primary.withOpacity(0.2)
                  : TColors.primary.withOpacity(0.2),
              dark
                  ? Colors.black.withOpacity(0.05)
                  : Colors.white.withOpacity(0.05),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TAppBar(
                showBackArrrow: true,
                actions: [
                  Obx(() {
                    return TCircularIcon(
                      icon: Iconsax.heart,
                      color:
                          (!controllerWhishlist.isInWishlist(
                                widget.productModel!.id!,
                              )
                              ? Colors.grey
                              : Colors.red),
                      onPressed: () {
                        if (!controllerWhishlist.isInWishlist(
                          widget.productModel!.id!,
                        )) {
                          controllerWhishlist.addToWishlist(
                            widget.productModel!,
                          );
                          Get.snackbar(
                            'Product Added To Wishlist',
                            '${widget.productModel!.title!} was added',
                            backgroundColor: TColors.primary,
                            colorText: Colors.white,
                          );
                        } else {
                          controllerWhishlist.removeFromWishlist(
                            widget.productModel!.id!,
                          );
                          Get.snackbar(
                            'Product Removed From Wishlist',
                            '${widget.productModel!.title!} was removed',
                            backgroundColor: TColors.primary,
                            colorText: Colors.white,
                          );
                        }
                      },
                    );
                  }),
                ],
              ),
              const SizedBox(height: TSizes.spaceBetwwenItems),
              Column(
                children: [
                  FutureBuilder<List<String>>(
                    future: ProductController.instance
                        .fetchPromoImagesFromSupabase(widget.productModel!.id!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text('No images found');
                      }

                      final combinedImages = <String>[];

                      if (productModel.thumbnail != null &&
                          productModel.thumbnail!.isNotEmpty) {
                        combinedImages.add(productModel.thumbnail!);
                      }
                      combinedImages.addAll(productModel.images!);

                      return TProductSlider(images: combinedImages);
                    },
                  ),
                ],
              ),

              Padding(
                padding: EdgeInsets.only(
                  right: TSizes.defaultSpace,
                  left: TSizes.defaultSpace,
                  bottom: TSizes.defaultSpace,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Rating & Sharing Button
                    TProductMetaData(
                      productModel: productModel,
                      rating: widget.productModel!.rating.toString()!,
                      productName: widget.productModel!.title!,
                      productPrice:
                          widget.productModel!.variation!.isNotEmpty
                              ? (selectedVariation != null
                                  ? selectedVariation!.price.toString()
                                  : widget.productModel!.price.toString())
                              : widget.productModel!.price.toString(),
                      isNewArrival:
                          widget.productModel!.offerValue == 'newArrival',
                      isDiscount: hasDiscount,
                      brandName: widget.productModel!.brand!.title,
                      stock: widget.productModel!.stock,
                      isFreeDelivery:
                          widget.productModel!.offerValue == 'freeDelivery',
                      discountPrice:
                          hasDiscount
                              ? widget.productModel!.salesPrice!.toString()
                              : '',

                      isVariation: widget.productModel!.variation!.isNotEmpty,
                      productDescription: widget.productModel!.description!,
                      brandImage: widget.productModel!.brand!.imageUrl,
                    ),

                    if (widget.productModel!.variation!.isNotEmpty)
                      Container(
                        decoration: BoxDecoration(
                          color:
                              dark
                                  ? Colors.white.withOpacity(0.2)
                                  : Colors.white.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color:
                                dark
                                    ? Colors.white.withOpacity(0.2)
                                    : Colors.white.withOpacity(0.55),
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ProductVariationSelector(
                            variations: widget.productModel!.variation! ?? [],
                            productAttributes:
                                widget.productModel!.productAttributes ?? [],
                            onVariationSelected: (variation) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                setState(() {
                                  selectedVariation = variation;
                                  print('${selectedVariation!.stock} 🟢🟢');

                                  if (selectedVariation!.stock > 0) {
                                    widget._isAvailable = true;
                                  } else {
                                    widget._isAvailable = false;
                                  }
                                });
                              });
                            },
                          ),
                        ),
                      ),
                    const SizedBox(height: TSizes.spaceBetwwenSections),

                    //Product Seller

                    //Checkout Button
                    GestureDetector(
                      onTap: () {
                        final cart = Get.put(CartController());

                        if (selectedVariation == null) {
                          final cartController = Get.put(CartController());
                          final cart = CartItem(
                            id: widget.productModel!.id!,
                            title: widget.productModel!.title!,
                            image: widget.productModel!.thumbnail!,
                            quantity: 1,
                            price:
                                salePrice < originalPrice
                                    ? widget.productModel!.salesPrice
                                            ?.toDouble() ??
                                        0.0
                                    : widget.productModel!.price?.toDouble() ??
                                        0.0,
                            variationAttributes: {},
                          );
                          cartController.addToCartTemp(cart);
                          _showBottomSheet(context);
                        } else {
                          final cartController = Get.put(CartController());
                          final cart = CartItem(
                            id: widget.productModel!.id!,
                            title: widget.productModel!.title!,
                            image: selectedVariation!.image.toString()!,
                            quantity: 1,
                            price:
                                (selectedVariation!.salePrice != null &&
                                        selectedVariation!.salePrice > 0)
                                    ? selectedVariation!.salePrice.toDouble()
                                    : selectedVariation!.price.toDouble(),
                            variationAttributes:
                                selectedVariation!
                                    .attributesValues, // Or map selected variation attributes if needed
                          );
                          cartController.addToCartTemp(cart);
                          _showBottomSheet(context);
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: TColors.primary,
                          border: Border.all(
                            color:
                                dark
                                    ? TColors.primary.withOpacity(0.5)
                                    : TColors.primary.withOpacity(0.5),
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Text(
                            'Checkout',
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium!.apply(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: TSizes.spaceBetwwenItems),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Desctiption',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: TSizes.spaceBetwwenItems),
                        ReadMoreText(
                          widget.productModel!.description!,
                          textAlign: TextAlign.start,

                          trimLines: 2,
                          trimLength: 100,
                          trimMode: TrimMode.Length,
                          trimCollapsedText: 'Show More',
                          trimExpandedText: '   Less',
                          moreStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                          lessStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),

                    const Divider(),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: TSizes.lg),
                child: TSectionHeading(title: 'Similar Products'),
              ),

              Obx(() {
                if (storeController.isLoading.value &&
                    storeController.page == 0) {
                  return Lottie.asset(
                    TImages.loading_animation,
                    width: 100,
                    height: 100,
                  );
                } else if (storeController.products.isEmpty) {
                  return Column(
                    children: [
                      Lottie.asset(
                        TImages.no_data_animtation,
                        width: 100,
                        height: 100,
                      ),
                      Text(
                        'No Products Found...',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  );
                } else {
                  return GridViewLayout(
                    itemCount: storeController.products.length,
                    itemBuilder: (_, index) {
                      final product = storeController.products[index];
                      return TProductGridItem(productModel: product);
                    },
                    shrinkWrap: true,
                  );
                }
              }),

              const SizedBox(height: TSizes.spaceBetwwenItems),
              Obx(() {
                return Column(
                  children: [
                    if (storeController.hasMore.value &&
                        !storeController.isLoading.value)
                      GestureDetector(
                        onTap:
                            () => storeController.fetchProducts(loadMore: true),
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
                              'Load More',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    if (!storeController.hasMore.value)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          'No more products',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                    if (storeController.isLoading.value &&
                        storeController.page > 0)
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                  ],
                );
              }),
              const SizedBox(height: TSizes.spaceBetwwenSections),
            ],
          ),
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) async {
    final cartController = Get.put(CartController());
    final dark = THelperFunction.isDarkMode(context);
    final storage = GetStorage();

    final result = await showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(() {
                if (cartController.cartFastItems.isEmpty) {
                  return const Center(child: Text('Cart is empty'));
                }
                return SizedBox(
                  height: 100,
                  child: ListView.builder(
                    itemCount: cartController.cartFastItems.length,
                    itemBuilder: (context, index) {
                      final item = cartController.cartFastItems[index];
                      return ListTile(
                        leading: Image.network(item.image, width: 50),
                        title: Text(
                          item.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                        subtitle: Text('Qty: ${item.quantity}'),

                        trailing: Column(
                          children: [
                            Text(
                              'Qty 1: ${storage.read('currency_symbol')} ${item.price}',
                            ),
                            Text(
                              '${storage.read('currency_symbol')} ${(item.price * item.quantity).toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ],
                        ),

                        onLongPress:
                            () => cartController.removeFromCartFast(item.id),
                      );
                    },
                  ),
                );
              }),

              TBillingAmountSections(
                products: cartController.cartFastItems,
                isFastCheckout: true,
                shippingCost: storage.read('shippingCost'),
              ),
              if (selectedAddress != null)
                TBillingAddress(
                  name: selectedAddress!.name,
                  address: selectedAddress!.street,
                  email: selectedAddress!.phone,
                  phoneNumer: selectedAddress!.phone,
                  onPressed: () => showAddressSelector(context),
                )
              else
                TextButton.icon(
                  icon: const Icon(Icons.location_on),
                  label: const Text("Select Shipping Address"),
                  onPressed: () => showAddressSelector(context),
                ),
              const SizedBox(height: TSizes.spaceBetwwenSections),
              Obx(() {
                if (paymentController.isPay.value == true) {
                  return Padding(
                    padding: const EdgeInsets.all(TSizes.defaultSpace),
                    child: GestureDetector(
                      onTap: () {
                        if (selectedAddress != null) {
                          final payCont = Get.put(PaymentController());

                          double totalPrice =
                              payCont.finalAmountt.value.toDouble();

                          final config = Config(
                            paymentAmount: totalPrice.toString(),
                          );
                          config.startPayment(
                            cartController.cartFastItems,
                            selectedAddress,
                            totalPrice.toString(),
                          );
                        } else {
                          Get.snackbar(
                            'Address Required',
                            'Please select a shipping address before checkout.',
                          );
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: TColors.primary,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            'Pay & Place Order',
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium!.apply(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(TSizes.defaultSpace),
                    child: GestureDetector(
                      onTap: () {
                        if (selectedAddress != null) {
                          final storage = GetStorage();

                          final payCont = Get.put(PaymentController());
                          final orderID = generateOrderID();
                          double totalPrice =
                              payCont.finalAmountt.value.toDouble();
                          final order = OrderModel(
                            orderID: orderID,
                            userID: storage.read('UID'),
                            orderStatus: 'placed',
                            paymentMethod: 'PayHere',
                            paymentStatus: 'Paid',
                            shippingAddress: [selectedAddress!],
                            billingAddress: [selectedAddress!],
                            totalPrice: totalPrice,

                           shippingCost: (storage.read('shippingCost') as num?)?.toDouble(),

                            subTotal: cartController.subTotalFast,
                            taxFee: 0,
                            currencySymbol: storage.read('currency_symbol'),
                            orderDate: DateTime.now(),
                            products:
                                cartController.cartFastItems
                                    .map((item) => item.toJson())
                                    .toList(),
                            couponCode: null,
                            note: null,
                          );

                          final paymentController = Get.put(
                            PaymentController(),
                          );
                          paymentController.placeOrder(order);
                          Get.offAll(
                            () => OrderSuccessfulScreen(
                              products: cartController.cartFastItems,
                              paymentID: 'No Payment ID',
                              addressModel: selectedAddress,
                              totalPayment: totalPrice.toString(),
                              orderID: orderID,
                            ),
                          );
                        } else {
                          Get.snackbar(
                            'Address Required',
                            'Please select a shipping address before checkout.',
                          );
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: TColors.primary,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            'Place Order',
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium!.apply(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  );
                }
              }),

              const SizedBox(height: TSizes.spaceBetwwenSections),
            ],
          ),
        );
      },
    );
    print('👍👍 sas $result');

    if (result == null) {
      cartController.removeFromCartFast(widget.productModel!.id!);
    }
  }

  String generateOrderID() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'ORDER-$timestamp';
  }

  void showAddressSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (_) => SafeArea(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              shrinkWrap: true,
              itemCount: addresses.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (_, index) {
                final address = addresses[index];
                final isSelected = selectedAddress?.id == address.id;

                return ListTile(
                  title: Text(address.name),
                  subtitle: Text('${address.street}, ${address.city}'),
                  trailing:
                      isSelected
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : null,
                  onTap: () {
                    setState(() => selectedAddress = address);
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
    );
  }
}
