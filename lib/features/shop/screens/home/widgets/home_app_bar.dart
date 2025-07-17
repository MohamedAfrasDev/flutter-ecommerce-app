import 'package:flutter/material.dart';
import 'package:online_shop/common/widgets/custom_shapes/appbar/appbar.dart';
import 'package:online_shop/features/shop/screens/home/widgets/cart_menu.dart';

class THomeAppBar extends StatelessWidget {
  const THomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TAppBar(title: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Good day for shopping', style: Theme.of(context).textTheme.labelMedium!.apply(color: Colors.grey),),
        Text('Afras', style: Theme.of(context).textTheme.headlineSmall!.apply(color: Colors.white),)
      ],
    ),
    actions: [
      TCartCounterIcon(
        onPressed: () {},
        iconColor: Colors.white,
      )
    ],
    );
  }
}
