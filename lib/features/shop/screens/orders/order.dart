import 'package:flutter/material.dart';
import 'package:online_shop/common/widgets/custom_shapes/appbar/appbar.dart';
import 'package:online_shop/features/shop/screens/orders/widgets/order_list.dart';
import 'package:online_shop/utils/constants/sizes.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(title: Text('My Orders', style: Theme.of(context).textTheme.headlineSmall,), showBackArrrow: true,),
      body: const Padding(
        padding: EdgeInsets.all(TSizes.defaultSpace),

        child: TOrderListItems(),
      ),
    );
  }
}