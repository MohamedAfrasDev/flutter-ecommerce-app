import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:online_shop/features/shop/screens/cart/controller/cart_controller.dart';
import 'package:online_shop/features/shop/screens/cart/controller/cart_item_model.dart';
import 'package:online_shop/features/shop/screens/cart/widgets/cart_item_view.dart';
import 'package:online_shop/features/shop/screens/home/home.dart';
import 'package:online_shop/features/shop/screens/order_successful_screen/widgets/ordered_items.dart';
import 'package:online_shop/features/shop_2/screens/home/home_2.dart';
import 'package:online_shop/navigation_menu.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/constants/image_strings.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:online_shop/utils/formatters/formatters.dart';
import 'package:online_shop/utils/formatters/pdf_format.dart';
import 'package:online_shop/utils/helpers/helper_function.dart';
import 'package:online_shop/utils/helpers/models/address_model.dart';
import 'package:online_shop/utils/http/app/app_config.dart';

class OrderSuccessfulScreen extends StatefulWidget {
  const OrderSuccessfulScreen({
    super.key,
    this.products,
    this.productID,
    this.paymentID,
    this.addressModel,
    this.totalPayment, this.orderID,
  });
  final List<CartItem>? products;

  final String? productID;

  final String? paymentID;

  final AddressModel? addressModel;

  final String? totalPayment;

  final String? orderID;

  @override
  State<OrderSuccessfulScreen> createState() => _OrderSuccessfulScreenState();
}

class _OrderSuccessfulScreenState extends State<OrderSuccessfulScreen> {
  final controller = Get.put(CartController());
  @override
void initState() {
  super.initState();

  // Call loadAddresses after the first frame is rendered
  WidgetsBinding.instance.addPostFrameCallback((_) {

    controller.clearCart(); // this can now safely call setState()
  });
}
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);

     print("Received products count: ${widget.products?.length ?? 0}");

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Order Placed Successfully',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Lottie.asset(
                  TImages.payment_successful_animation,
                  fit: BoxFit.cover,
                  repeat: false,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                     
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          const SizedBox(height: TSizes.spaceBetwwenItems),
                          Text(
                            'Thank you for your order!',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: TSizes.spaceBetwwenItems),
                          Text(
                            'You will receive an email confirmation shortly.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: TSizes.spaceBetwwenItems),
                          Text(
                            'If you have any questions, please contact our support team.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: TSizes.spaceBetwwenItems),
                          Text(
                            'Order ID: ${widget.orderID}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: TSizes.spaceBetwwenItems),
                          Text(
                            'Payment ID: ${widget.paymentID}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: TSizes.spaceBetwwenItems),
                          Text(
                            'Date: ${TFormatters.formatDate(DateTime.now())}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: TSizes.spaceBetwwenItems),
                          Text(
                            'Total Amount: ${widget.totalPayment}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: TSizes.spaceBetwwenItems),
                          Text(
                            'Payment Method: PayHere',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                      
                          const SizedBox(height: TSizes.spaceBetwwenItems),
                        ],
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              dark
                                  ? Colors.white.withOpacity(0.05)
                                  : TColors.primary.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color:
                                dark
                                    ? Colors.grey.withOpacity(0.5)
                                    : TColors.primary,
                            width: 0.5,
                          ),
                        ),
                        width: double.infinity,
                        child: TOrderedItems(
                          showAddRemoveButton: false,
                          products: widget.products ?? [],
                        ),
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color:
                          dark
                              ? Colors.white.withOpacity(0.05)
                              : TColors.grey.withOpacity(0.05),
                      border: Border.all(
                        color:
                            dark
                                ? Colors.grey.withOpacity(0.05)
                                : Colors.grey.withOpacity(0.25),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Shipping Address',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: TSizes.md),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 10,
                            children: [
                              Text('Name: ${widget.addressModel!.name}'),
                              Text('Phone: ${widget.addressModel!.phone}'),
                              Text(
                                'Address: ${widget.addressModel!.street} ${widget.addressModel!.state} ${widget.addressModel!.city} ${widget.addressModel!.country}',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () async {
                    print(generateOrderID());// ✅ Debug print
                  },
                  child: Container(
                    width: TSizes.buttonWidth + 30,
                    decoration: BoxDecoration(
                      color:
                          dark
                              ? Colors.white.withOpacity(0.55)
                              : TColors.primary,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        spacing: 10,
                        children: [
                          Image.asset(TImages.bill_icon, width: 20, height: 20),
                          Text(
                            'Download Bill',
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(color: TColors.textWhite),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: TSizes.spaceBetwwenItems),
                GestureDetector(
                  onTap: () => Get.offAll(() => NavigationMenu()),
                  child: Container(
                    decoration: BoxDecoration(
                      color: dark ? Colors.white.withOpacity(0.55) : TColors.primary,
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('Return to Home',
                        style: Theme.of(context).textTheme.bodyMedium!
                            .copyWith(color: TColors.textWhite),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: TSizes.spaceBetwwenItems),

               
              ],
            ),
          ),
        ),
      ),
    );
  }
String generateOrderID() {
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  return 'ORDER-$timestamp'; // e.g., ORDER-1724834101234
}

}
