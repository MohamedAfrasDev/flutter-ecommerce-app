import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:get/get.dart';
import 'package:online_shop/features/shop/screens/cart/cart.dart';
import 'package:online_shop/features/shop/screens/cart/controller/cart_controller.dart';

class TCartCounterIcon extends StatefulWidget {
  const TCartCounterIcon({
    super.key, required this.iconColor, required this.onPressed,
  });

  final Color iconColor;
  final VoidCallback onPressed;

  @override
  State<TCartCounterIcon> createState() => _TCartCounterIconState();
}

class _TCartCounterIconState extends State<TCartCounterIcon> {
  @override
  Widget build(BuildContext context) {
    final cartController = Get.put(CartController());
    return Stack(
      children: [
        IconButton(onPressed: () => Get.to(() =>  CartScreen()), icon: Icon(Iconsax.shopping_bag_copy, color: widget.iconColor,)),
        Positioned(
          right: 0,
          child: Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Center(
              child: Obx((){ return
                 Text(cartController.cartItems.length.toString(), style: Theme.of(context).textTheme.labelLarge!.apply(color: Colors.white, fontSizeFactor: 0.8),);
              })
            ),
          ),
        )
      ],
    );
  }
}


