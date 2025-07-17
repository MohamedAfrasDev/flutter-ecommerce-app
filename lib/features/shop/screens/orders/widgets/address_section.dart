import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/section_heading.dart';
import 'package:online_shop/features/shop/screens/order_successful_screen/controllers/order_controller.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:online_shop/utils/helpers/models/address_model.dart';

class TShippingAddressSection extends StatefulWidget {
  const TShippingAddressSection({
    super.key,
    this.title = 'Shipping Address',
    this.addressModel, required this.orderID,
  });

  final String title;
  final List<AddressModel>? addressModel;
  final String orderID;

  @override
  State<TShippingAddressSection> createState() => _TShippingAddressSectionState();
}




class _TShippingAddressSectionState extends State<TShippingAddressSection> {
    final controller = Get.put(OrderController());

   @override
  void initState() {
    super.initState();
    controller.fetchShippingAddress(widget.orderID);
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: TSizes.lg),
          child: TSectionHeading(title: widget.title, showActionButton: false),
        ),
        const SizedBox(height: TSizes.md),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: TSizes.lg),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child:Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    if (widget.addressModel == null || widget.addressModel!.isEmpty)
      const Text('No address available')
    else
      ...widget.addressModel!.map((address) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Obx(() {
    final address = controller.shippingAddressList.isNotEmpty
        ? controller.shippingAddressList.first
        : {};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Shipping Address', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),

        Text('Street: ${address['street'] ?? '-'}'),
        Text('State: ${address['state'] ?? '-'}'),
        Text('Country: ${address['country'] ?? '-'}'),
      ],
    );
  })
            ],
          ),
        );
      }).toList()
  ],
)



            ),
          ),
        ),
      ],
    );
  }
}
