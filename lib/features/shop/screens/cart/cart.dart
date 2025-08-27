import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:online_shop/features/shop/screens/cart/controller/cart_controller.dart';
import 'package:online_shop/features/shop/screens/checkout/checkout.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/helpers/helper_function.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    final dark = THelperFunction.isDarkMode(context);
    final storage = GetStorage();

    return Scaffold(
      appBar: AppBar(title: const Text('My Cart')),
      body: Obx(() {
        if (cartController.cartItems.isEmpty) {
          return const Center(child: Text('Cart is empty'));
        }
        return ListView.builder(
          itemCount: cartController.cartItems.length,
          itemBuilder: (context, index) {
            final item = cartController.cartItems[index];
            return ListTile(
              leading: Image.network(item.image, width: 50),
              title: Text(item.title, maxLines: 2, overflow: TextOverflow.ellipsis, softWrap: true,),
              subtitle: Text('Qty: ${item.quantity}'),
              
              trailing: Column(
                children: [
                  Text('Qty 1: ${storage.read('currency_symbol')} ${item.price}'),
                  Text('${storage.read('currency_symbol')} ${(item.price * item.quantity).toStringAsFixed(2)}',style: Theme.of(context).textTheme.titleSmall,),
                  GestureDetector(
                    onTap: () => cartController.removeFromCart(item.id),
                    child: Text('Remove', style: TextStyle(color: Colors.red),))
                ],
              ),
              
              onLongPress: () => cartController.removeFromCart(item.id),
            );
          },
        );
      }),
      bottomNavigationBar: Obx(() => Container(
            padding: const EdgeInsets.all(16),
            color: dark ? Colors.white.withOpacity(0.05) : Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total: ${storage.read('currency_symbol')} ${cartController.totalPrice.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headlineSmall),


                    GestureDetector(
                      onTap: () => Get.to(() => CheckoutScreen(products: cartController.cartItems,)),
                      child: Container(
                        decoration: BoxDecoration(
                          color: dark ? Colors.white.withOpacity(0.05) : TColors.primary,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: dark ? Colors.grey.withOpacity(0.5) : TColors.dark.withOpacity(0.2))
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Confirm Order',
                            style: Theme.of(context).textTheme.titleMedium!.apply(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
             
              ],
            ),
          )),
    );
  }
}
