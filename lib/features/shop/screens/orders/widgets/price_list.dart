import 'package:flutter/material.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:online_shop/utils/helpers/models/order_model.dart';


class TPriceList extends StatelessWidget {
  const TPriceList({super.key, this.orderModel});

  final OrderModel? orderModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(5)
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Item Total', style: Theme.of(context).textTheme.titleSmall,),
                  Text('${orderModel!.currencySymbol} ${orderModel!.subTotal}', style: Theme.of(context).textTheme.titleMedium,)
                ],
              ),
              const Divider(thickness: 0.1,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Discount', style: Theme.of(context).textTheme.titleSmall,),
                  Text('${orderModel!.subTotal}', style: Theme.of(context).textTheme.titleMedium,)
                ],
              ),
              const Divider(thickness: 0.1,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Shipping Charge', style: Theme.of(context).textTheme.titleSmall,),
                  Text('${orderModel!.shippingCost}', style: Theme.of(context).textTheme.titleMedium,)
                ],
              ),
              const Divider(thickness: 0.1,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Payment Method', style: Theme.of(context).textTheme.titleSmall,),
                  Text('${orderModel!.paymentMethod}', style: Theme.of(context).textTheme.titleMedium,)
                ],
              ),
              const Divider(thickness: 0.1,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Amount', style: Theme.of(context).textTheme.titleLarge,),
                  Text('${orderModel!.currencySymbol} ${orderModel!.totalPrice}', style: Theme.of(context).textTheme.titleLarge,),
                  

                ],
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}