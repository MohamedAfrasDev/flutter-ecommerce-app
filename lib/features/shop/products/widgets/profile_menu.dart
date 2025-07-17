import 'package:flutter/material.dart';

import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:online_shop/utils/constants/sizes.dart';

class TProfileMenuTitle extends StatelessWidget {
  const TProfileMenuTitle({
    super.key,  this.icon = Iconsax.arrow_right_3_copy, required this.onPressed, required this.title, required this.value,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String title, value;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBetwwenItems / 1.5),
        child: Row(
          children: [
            Expanded(flex: 3, child: Text(title, style: Theme.of(context).textTheme.bodySmall, overflow: TextOverflow.ellipsis,)),
            Expanded(flex: 5, child: Text(value, style: Theme.of(context).textTheme.bodyMedium, overflow: TextOverflow.ellipsis,)),
            Expanded(child:  Icon(icon, size: 18,))
          ],
        ),
      ),
    );
  }
}