import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:online_shop/common/widgets/custom_shapes/appbar/appbar.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/primary_header_widget.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/section_heading.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/t_rounded_image.dart';
import 'package:online_shop/features/shop/screens/checkout/widgets/billing_address_section.dart';
import 'package:online_shop/features/shop/screens/order_successful_screen/controllers/order_controller.dart';
import 'package:online_shop/features/shop/screens/orders/widgets/address_section.dart';
import 'package:online_shop/features/shop/screens/orders/widgets/order_tracker.dart';
import 'package:online_shop/features/shop/screens/orders/widgets/ordered_item_card.dart';
import 'package:online_shop/features/shop/screens/orders/widgets/price_list.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/constants/image_strings.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:online_shop/utils/device/device_utility.dart';
import 'package:online_shop/utils/helpers/helper_function.dart';
import 'package:online_shop/utils/helpers/models/order_model.dart';
import 'package:online_shop/utils/repository/product_model/product_model.dart';

class OrderItemDetailScreen extends StatefulWidget {
  const OrderItemDetailScreen({
    super.key,
    this.orderNumber = 'afras',
    this.productImage = TImages.productImage2,
    this.productName = 'Sample',
    this.productPrice = '123',
    this.quantitiy = '2',
    this.isShippingBilling = false,
    required this.orderModel,
  });

  final String productImage, productName, productPrice, quantitiy;
  final String orderNumber;
  final bool isShippingBilling;
  final OrderModel orderModel;

  @override
  State<OrderItemDetailScreen> createState() => _OrderItemDetailScreenState();
}

class _OrderItemDetailScreenState extends State<OrderItemDetailScreen> {
  @override
  Widget build(BuildContext context) {
    print('Shipping addresses count: ${widget.orderModel.shippingAddress.length}');
    final dark = THelperFunction.isDarkMode(context);
    final controller = Get.put(OrderController());

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: TDeviceUtils.getScreenHeight() * 0.5,
              child: TPrimaryHeader(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: TSizes.lg),
                      SafeArea(
                        child: Row(
                          children: [
                            const SizedBox(width: TSizes.defaultSpace),
                            GestureDetector(
                              onTap: () => Get.back(),
                              child: Icon(Iconsax.arrow_left_2_copy),
                            ),
                            const SizedBox(width: TSizes.sm),
                            Text(
                              "Your Order is " + widget.orderModel.orderID!,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ],
                        ),
                      ),
                      ...widget.orderModel.products.map((productMap) {
                        return TOrderedItemCard(
                          productName: productMap['title'] ?? 'N/A',
                          productPrice: productMap['price'].toString(),
                          quantitiy: productMap['quantity'].toString(),
                          productImage: productMap['image'] ?? TImages.productImage2,
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ),

            if (widget.isShippingBilling)
              TShippingAddressSection(
                title: 'Shipping Address & Billing Address',  addressModel: widget.orderModel.shippingAddress, orderID: widget.orderModel.orderID!,
              )
            else
              Column(
                spacing: 15,
                children: [
                  
                  TShippingAddressSection(title: 'Shipping Address', addressModel: widget.orderModel.shippingAddress, orderID: widget.orderModel.orderID!,),
                  TBillingAddress(title: 'Billing Address'),
                ],
              ),

            TPriceList(orderModel: widget.orderModel,),

            Padding(
              padding: const EdgeInsets.only(left: TSizes.defaultSpace),
              child: TSectionHeading(
                title: 'Track your Order',
                showActionButton: false,
              ),
            ),
            const SizedBox(height: TSizes.spaceBetwwenItems),
            if(widget.orderModel!.orderStatus=='cancelled') Text('Ordered has been cancelled', style: Theme.of(context).textTheme.bodyLarge!.apply(color: Colors.red),)
            else
              TOrderTracker(orderModel: widget.orderModel,),


 const SizedBox(height: TSizes.spaceBetwwenItems),
         
            GestureDetector(
              onTap: () {
                if(widget.orderModel.orderStatus == 'placed') {
                  Get.back();
                  controller.cancelOrder(widget.orderModel);
                  Get.snackbar('Order Cancelled', 'Your order has been cancelled successfully.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red.withOpacity(0.8),
                    colorText: Colors.white,
                    duration: const Duration(seconds: 2),
                  );
                  
                } else if(widget.orderModel.orderStatus == 'cancelled') {
                  Get.back();
                controller.reOrder(widget.orderModel);
                  Get.snackbar('Re Ordered', 'Your order has been placed successfully.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: TColors.primary.withOpacity(0.8),
                    colorText: Colors.white,
                    duration: const Duration(seconds: 2),
                  );
                } else {
                  Get.snackbar('Action Not Allowed', 'You can only cancel orders that are placed.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.grey.withOpacity(0.8),
                    colorText: Colors.white,
                    duration: const Duration(seconds: 2),
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: (widget.orderModel!.orderStatus=='placed') ? Colors.red : Colors.grey,
                  borderRadius: BorderRadius.circular(5)
                ),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text((widget.orderModel!.orderStatus=='cancelled') ? 'Re-order' : 'Cancel Order', style: Theme.of(context).textTheme.titleSmall!.apply(color: Colors.white),),
                ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBetwwenSections * 2),
          ],
        ),
      ),
    );
  }
}
