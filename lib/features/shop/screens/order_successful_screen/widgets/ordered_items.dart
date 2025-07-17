import 'package:flutter/material.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/products/product_pricet_text.dart';
import 'package:online_shop/features/shop/screens/cart/controller/cart_item_model.dart';
import 'package:online_shop/features/shop/screens/cart/widgets/cart_item.dart';
import 'package:online_shop/features/shop/screens/cart/widgets/product_quantity_add_remove_btn.dart';
import 'package:online_shop/features/shop/screens/order_successful_screen/widgets/orderitem.dart';
import 'package:online_shop/utils/constants/sizes.dart';

class TOrderedItems extends StatelessWidget {
  const TOrderedItems({
    super.key,
    this.showAddRemoveButton = true,
    required this.products,
  });

  final List<CartItem> products;
  final bool showAddRemoveButton;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (_, __) => const SizedBox(height: TSizes.spaceBetwwenSections),
      itemCount: products.length,
      itemBuilder: (_, index) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Pass a single CartItem to TCartItem
          TOrderitem(product: products[index]),

          
        ],
      ),
    );
  }
}
