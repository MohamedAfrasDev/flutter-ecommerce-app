import 'package:flutter/material.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/t_rounded_image.dart';
import 'package:online_shop/features/shop_2/screens/home/widgets/time_counter.dart';
import 'package:online_shop/utils/constants/image_strings.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:online_shop/utils/helpers/helper_function.dart';
import 'package:online_shop/utils/helpers/models/sales_countdown_model.dart';

class SalesCountWidget extends StatelessWidget {
  const SalesCountWidget({super.key, this.model});

  final SalesCountdownModel? model;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    return Container(
      decoration: BoxDecoration(
        color: dark ? Colors.white.withOpacity(0.05) : Colors.white.withOpacity(0.55),
        border: Border.all(color: dark ? Colors.grey.withOpacity(0.5) : Colors.white.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TSaleCountdown(endTime: model?.endTime ?? DateTime.now().add(const Duration(days: 1))),
            Image.asset(TImages.productImage4, width: 300, height: 300,),

           Container(
            width: double.infinity,
             child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text('Asus Zenbook Duo 2024',style: Theme.of(context).textTheme.titleLarge,),
              const SizedBox(height: TSizes.sm,),
              Text('Storage: 512GB SSD', style: Theme.of(context).textTheme.bodyMedium,),
              const SizedBox(height: TSizes.sm,),
              Text('RAM: 32GB', style: Theme.of(context).textTheme.bodyMedium,),
              const SizedBox(height: TSizes.sm,),
              Text('Display: 120Hz', style: Theme.of(context).textTheme.bodyMedium,),
              const SizedBox(height: TSizes.sm,),
              Text('GPU: 16GB', style: Theme.of(context).textTheme.bodyMedium,),
              ],
             ),
           )

          ],
        ),
      ),
    );
  }
}