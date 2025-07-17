import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:online_shop/common/widgets/icons/circular_icons.dart';
import 'package:online_shop/features/shop/screens/cart/controller/cart_controller.dart';
import 'package:online_shop/features/shop/screens/cart/controller/cart_item_model.dart';
import 'package:online_shop/features/shop/screens/wishlists/controller/whishlist_controller.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/constants/image_strings.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:online_shop/utils/helpers/helper_function.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:online_shop/utils/repository/product_model/product_model.dart';
import 'package:uuid/uuid.dart';

class TBottomAddCart extends StatefulWidget {
  final String productID;
  final String productName;
  final String productImage;
  final String productPrice;
  final bool isAvailable;
  final ProductModel productModel;
  final Map<String, String>? variationAttributes;
  final int? stock;

  const TBottomAddCart({
    super.key,
    required this.productID,
    required this.productName,
    required this.productImage,
    required this.productPrice,
    required this.isAvailable,
    this.variationAttributes,
    required this.productModel,
    required this.stock,
  });

  @override
  State<TBottomAddCart> createState() => _TBottomAddCartState();
}

class _TBottomAddCartState extends State<TBottomAddCart> {
  bool? _isAvailable;
  int qty = 1;

  @override
  void initState() {
    super.initState();
    _isAvailable = widget.isAvailable;
    qty = 1;

    
  }
  @override
void didUpdateWidget(covariant TBottomAddCart oldWidget) {
  super.didUpdateWidget(oldWidget);
  qty  = 1;
  if (oldWidget.isAvailable != widget.isAvailable) {
    setState(() {
      _isAvailable = widget.isAvailable;
    });
  }
}


  void incrementQty() {
    if(qty < widget.stock!){
      setState(() {
      qty++;
    });
    }
  }

  void decrementQty() {
    if (qty > 1) {
      setState(() {
        qty--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    print('${_isAvailable} 📞📞');
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TSizes.defaultSpace,
        vertical: TSizes.defaultSpace / 2,
      ),
      decoration: BoxDecoration(
        color: dark ? TColors.dark : TColors.primary.withOpacity(0.15),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(TSizes.cardRadiusLg),
          topRight: Radius.circular(TSizes.cardRadiusLg),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              TCircularIcon(
                icon: Iconsax.minus_cirlce,
                backgroundColor: TColors.dark,
                width: 40,
                height: 40,
                color: TColors.light,
                onPressed: decrementQty,
              ),
              const SizedBox(width: TSizes.spaceBetwwenItems),
              Text(qty.toString(), style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(width: TSizes.spaceBetwwenItems),
              TCircularIcon(
                icon: Iconsax.add_circle,
                backgroundColor: TColors.primary,
                width: 40,
                height: 40,
                onPressed: incrementQty,
                color: TColors.light,
              ),
            ],
          ),
          
         if (_isAvailable!)
  TAddToCart(widget: widget, dark: dark, qty: qty)
else
  TAddToWishlist(widget: widget, dark: dark),

        ],
      ),
    );
  }
}

class TAddToWishlist extends StatelessWidget {
  const TAddToWishlist({super.key, required this.widget, required this.dark});

  final TBottomAddCart widget;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WishlistController());

    return GestureDetector(
      onTap: () {
        if (!controller.isInWishlist(widget.productID)) {
          controller.addToWishlist(widget.productModel);
          Get.snackbar('Product Added To Wishlist', '${widget.productName} was added', backgroundColor: TColors.primary, colorText: Colors.white);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: dark ? Colors.white.withOpacity(0.05) : TColors.primary,
          border: Border.all(
            color: dark ? Colors.grey.withOpacity(0.5) : TColors.dark.withOpacity(0.2),
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Image.asset(TImages.shopping_cart_icon, width: 30, height: 30),
            const SizedBox(width: 10),
            const Text('Add to Wishlist', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

class TAddToCart extends StatelessWidget {
  const TAddToCart({super.key, required this.widget, required this.dark, required this.qty});

  final TBottomAddCart widget;
  final bool dark;
  final int qty;

  @override
  Widget build(BuildContext context) {
    final cart = Get.put(CartController());

    return GestureDetector(
      onTap: () {
        cart.addToCart(
          CartItem(
            id: widget.productID,
            title: widget.productName,
            image: widget.productImage,
            quantity: qty,
            price: double.tryParse(widget.productPrice) ?? 0.0,
            variationAttributes: widget.variationAttributes ?? {},
          ),
        );

        Get.snackbar("Added", "Product added to cart");
        print('Added to cart: ${cart.cartItems.last.variationAttributes}');
      },
      child: Container(
        decoration: BoxDecoration(
          color: dark ? Colors.white.withOpacity(0.05) : TColors.primary,
          border: Border.all(
            color: dark ? Colors.grey.withOpacity(0.5) : TColors.dark.withOpacity(0.2),
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Image.asset(TImages.shopping_cart_icon, width: 30, height: 30),
            const SizedBox(width: 10),
            const Text('Add to Cart', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
