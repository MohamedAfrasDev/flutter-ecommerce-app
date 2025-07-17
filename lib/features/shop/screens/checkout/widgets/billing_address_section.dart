import 'package:flutter/material.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/section_heading.dart';
import 'package:online_shop/utils/constants/sizes.dart';
class TBillingAddress extends StatelessWidget {
  const TBillingAddress({
    super.key,
    this.name = 'Loading Name...',
    this.address = 'Loading Address..',
    this.email = 'Loading Email...',
    this.phoneNumer = 'Loading Phone Number...',
    this.title = 'Shipping Address',
    this.onPressed,
  });

  final String name, address, email, phoneNumer, title;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TSectionHeading(title: title, showActionButton: false),
        const SizedBox(height: TSizes.lg),
        InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('👤 $name'),
                Text('📍 $address'),
                Text('📞 $phoneNumer'),
                Text('📧 $email'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
