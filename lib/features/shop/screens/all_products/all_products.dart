import 'package:flutter/material.dart';
import 'package:online_shop/common/styles/layouts/grid_view_layout.dart';
import 'package:online_shop/common/widgets/custom_shapes/appbar/appbar.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/products/product_card_vertical.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class AllProducts extends StatelessWidget {
  const AllProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(
        title: Text('Popular Products'),
        showBackArrrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              DropdownButtonFormField(
                onChanged: (value) => {},
                decoration: const InputDecoration(prefixIcon: Icon(Iconsax.sort_copy)),
                items: ['Name', 'Higer Price', 'Lower Price', 'Sale', 'Popularity']
                    .map((options) => DropdownMenuItem(value: options, child: Text(options)))
                    .toList(),
              ),
              const SizedBox(height: TSizes.spaceBetwwenSections,),

              GridViewLayout(itemCount: 8, itemBuilder: (_, index) => const TProductCardVertical(productModel: null,), shrinkWrap: true,),
            ],
          ),
        ),
      ),
    );
  }
}
