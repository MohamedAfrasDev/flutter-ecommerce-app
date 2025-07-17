import 'package:flutter/material.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/section_heading.dart';
import 'package:online_shop/utils/constants/sizes.dart';

class TBillingAddressSection extends StatelessWidget {
  const TBillingAddressSection({
    super.key,
    this.name = 'Loading Name...',
    this.address = 'Loading Address..',
    this.email = 'Loading Email...',
    this.phoneNumer = 'Loading Phone Number...',
  });

  final String name, address, email, phoneNumer;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: TSizes.lg),
          child: TSectionHeading(title: 'Billing Address'),
        ),
        const SizedBox(height: TSizes.lg,),

        Padding(
          padding: const EdgeInsets.only(left: TSizes.lg, right: TSizes.lg),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      Text('👤 ' + name),
                      Text('📍 ' + address),
                      Text('📞 ' + phoneNumer),
                      Text('📧 ' + email),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
