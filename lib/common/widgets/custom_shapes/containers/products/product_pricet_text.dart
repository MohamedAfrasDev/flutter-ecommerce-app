import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class TProductPriceText extends StatelessWidget {
  const TProductPriceText({super.key, this.currencySign = 'LKR', required this.price, this.maxLines = 1, this.isLarge = false, this.lineThrough = false, this.color});

final String currencySign, price;
final int maxLines;
final bool isLarge;
final bool lineThrough;
final Color? color;

  @override
  Widget build(BuildContext context) {
    final storage = GetStorage();
    return Text(
      "${storage.read('currency_symbol')}  $price",
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: isLarge
            ? Theme.of(context).textTheme.titleLarge!.apply(decoration: lineThrough ? TextDecoration.lineThrough : null, color: color, )
            : Theme.of(context).textTheme.labelMedium!.apply(decoration: lineThrough ? TextDecoration.lineThrough : null, color: color),
    );
  }
}