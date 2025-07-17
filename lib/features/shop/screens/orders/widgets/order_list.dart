import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:online_shop/features/shop/screens/order_successful_screen/controllers/order_controller.dart';
import 'package:online_shop/features/shop/screens/orders/ordered_item_detail.dart/ordered_item_detail.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:online_shop/utils/helpers/helper_function.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
class TOrderListItems extends StatelessWidget {
  const TOrderListItems({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    final controller = Get.put(OrderController());

    return Obx(() => ListView.separated(
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: controller.orders.length,
          separatorBuilder: (_, index) => const SizedBox(height: TSizes.spaceBetwwenItems),
          itemBuilder: (_, index) {
            final order = controller.orders[index];

            return TRoundedContainer(
              showBorder: true,
              padding: const EdgeInsets.all(TSizes.md),
              backgroundColor: dark ? TColors.dark : TColors.light,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Order Status + Date
                  Row(
                    children: [
                      const Icon(Iconsax.ship),
                      const SizedBox(width: TSizes.spaceBetwwenItems / 2),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.orderStatus!.toUpperCase() ?? 'Processing'.toUpperCase(),
                              style: Theme.of(context).textTheme.bodyLarge!.apply(
                                    color: TColors.primary,
                                    fontWeightDelta: 1,
                                  ),
                            ),
                            Text(order.orderDate?.toLocal().toString().split(' ')[0] ?? ''),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Get.to(() => OrderItemDetailScreen(
                                orderNumber: order.orderID ?? '',
                                isShippingBilling: true,
                                orderModel: order,
                              ));
                        },
                        icon: const Icon(Iconsax.arrow_right_1_copy, size: TSizes.iconSm),
                      ),
                    ],
                  ),

                  const SizedBox(height: TSizes.spaceBetwwenItems),

                  /// Order Info + Shipping Date
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(Iconsax.box),
                            const SizedBox(width: TSizes.spaceBetwwenItems / 2),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Order', style: Theme.of(context).textTheme.labelMedium),
                                  Text(order.orderID ?? ''),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(Iconsax.calendar),
                            const SizedBox(width: TSizes.spaceBetwwenItems / 2),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Shipping Date', style: Theme.of(context).textTheme.labelMedium),
                                  Text(order.orderDate?.add(const Duration(days: 3)).toLocal().toString().split(' ')[0] ?? ''),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ));
  }
}
