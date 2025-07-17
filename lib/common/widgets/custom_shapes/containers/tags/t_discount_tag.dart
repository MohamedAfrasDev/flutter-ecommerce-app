import 'package:flutter/material.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/constants/sizes.dart';
class TDiscountTag extends StatelessWidget {
  const TDiscountTag({
    super.key, required this.discount,
  });

  final String discount;

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      width: 40,
      height: 40,
      radius: TSizes.sm,
      backgroundColor: TColors.secondary.withOpacity(
        0.8,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: TSizes.sm,
        vertical: TSizes.sm,
      ),
      child: Text(
        discount,
    
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.labelLarge!
            .apply(color: Colors.black),
      ),
    );
  }
}