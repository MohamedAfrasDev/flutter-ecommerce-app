import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/constants/image_strings.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:online_shop/utils/helpers/models/order_model.dart';

import 'package:flutter/material.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/constants/image_strings.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:online_shop/utils/helpers/models/order_model.dart';

class TOrderTracker extends StatefulWidget {
  const TOrderTracker({super.key, this.orderModel});

  final OrderModel? orderModel;

  // Define the possible order statuses and corresponding titles/images
  static const List<_OrderStep> orderSteps = [
    _OrderStep('Order Placed', TImages.order_placed_icon),
    _OrderStep('Processing', TImages.order_packed_icon),
    _OrderStep('Shipped', TImages.order_shipped_icon),
    _OrderStep('Delivered', TImages.order_deliveried),
  ];

  @override
  State<TOrderTracker> createState() => _TOrderTrackerState();
}

class _TOrderTrackerState extends State<TOrderTracker> {
  int _getCurrentStepIndex() {
    if (widget.orderModel == null || widget.orderModel!.orderStatus == null) return 0;
    final status = widget.orderModel!.orderStatus!.toLowerCase();
    switch (status) {
      case 'placed':
        return 0;
      case 'processing':
        return 1;
      case 'shipped':
        return 2;
      case 'delivered':
        return 3;
      default:
        return 0;
    }
  }

  @override
  void initState(){
    super.initState();
    _getCurrentStepIndex();
  }

  @override
  Widget build(BuildContext context) {
    final currentStep = _getCurrentStepIndex();

    return Column(
      children: [
      SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(TOrderTracker.orderSteps.length * 2 - 1, (index) {
      if (index.isEven) {
        final stepIndex = index ~/ 2;
        final step = TOrderTracker.orderSteps[stepIndex];
        final isActive = stepIndex <= currentStep;
        return _OrderStepWidget(
          title: step.title,
          image: step.iconPath,
          isActive: isActive,
        );
      } else {
        final isActive = (index ~/ 2) < currentStep;
        return Container(
          width: 30, // slightly reduced width
          height: 2,
          color: isActive ? TColors.primary : Colors.grey[300],
          margin: const EdgeInsets.symmetric(horizontal: 4),
        );
      }
    }),
  ),
),

        const SizedBox(height: TSizes.md),
        // Optional: Display current status text below the tracker
         Text(
          'Current Status: ${widget.orderModel?.orderStatus ?? 'Unknown'}',
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: TColors.primary),
        ),
      ],
    );
  }
}

class _OrderStep {
  final String title;
  final String iconPath;
  const _OrderStep(this.title, this.iconPath);
}

class _OrderStepWidget extends StatelessWidget {
  const _OrderStepWidget({
    required this.title,
    required this.image,
    this.isActive = false,
  });

  final String title;
  final String image;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          image,
          width: 40,
          height: 40,
          color: isActive ? null : Colors.grey,
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: Theme.of(context).textTheme.labelSmall!.copyWith(
                color: isActive ? TColors.primary : Colors.grey,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
        ),
      ],
    );
  }
}
