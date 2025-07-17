import 'package:flutter/material.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/t_rounded_image.dart';
import 'package:online_shop/features/shop/screens/cart/controller/cart_item_model.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:online_shop/utils/helpers/helper_function.dart';
import 'package:online_shop/utils/helpers/models/order_model.dart';
import 'package:online_shop/utils/repository/product_model/product_model.dart';

class RevviewProductItem extends StatelessWidget {
  const RevviewProductItem({super.key, required this.cartItem});

  final CartItem cartItem;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: dark ? Colors.white.withOpacity(0.05) : Colors.grey.withOpacity(0.1),
          border: Border.all(color: dark ? Colors.grey.withOpacity(0.05) : TColors.dark.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  TRoundedImage(
                imageUrl: cartItem.image ?? '',
                width: 60,
                height: 60,
                isNetworkImage: true,
              ),
              const SizedBox(width: TSizes.spaceBetwwenItems,),
      
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cartItem.title!, style: Theme.of(context).textTheme.titleMedium,),
                  const SizedBox(height: TSizes.sm,),
                  Text('Product, var', style: Theme.of(context).textTheme.labelLarge,),
                ],
              )
                ],
              ),

              Text(cartItem.quantity.toString(), style: Theme.of(context).textTheme.titleLarge,),
            ],
          ),
        ),
      ),
    );
  }
}