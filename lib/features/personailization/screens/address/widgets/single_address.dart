import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:online_shop/utils/helpers/helper_function.dart';
import 'package:online_shop/utils/helpers/models/address_model.dart';


class TSingleAddress extends StatelessWidget {
  final AddressModel address;
  final bool selectedAddress;

  const TSingleAddress({
    Key? key,
    required this.address,
    this.selectedAddress = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    return Container(
      padding: const EdgeInsets.all(TSizes.md),
      margin: const EdgeInsets.only(bottom: TSizes.spaceBetwwenItems),
      width: double.infinity,
      decoration: BoxDecoration(
        color: selectedAddress ? TColors.primary.withOpacity(0.5) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: selectedAddress
              ? Colors.transparent
              : dark
                  ? TColors.dark
                  : TColors.grey,
        ),
      ),
      child: Stack(
        children: [
          if (selectedAddress)
            Positioned(
              right: 5,
              top: 0,
              child: Icon(
                Iconsax.tick_circle,
                color: dark ? TColors.light : TColors.dark.withOpacity(0.6),
              ),
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                address.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: TSizes.sm / 2),
              Text(
                address.phone,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: TSizes.sm / 2),
              Text(
                '${address.street}, ${address.city}, ${address.state}, ${address.country}',
                softWrap: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
