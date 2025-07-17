import 'package:flutter/material.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:online_shop/utils/helpers/helper_function.dart';

class TCircularIcon extends StatelessWidget {
  const TCircularIcon({
    super.key, this.width, this.height, this.size = TSizes.lg, required this.icon, this.color, this.backgroundColor, this.onPressed, this.showBorder = true,
    
  });

  final double? width, height, size;
  final IconData icon;
  final Color? color;
  final Color? backgroundColor;
  final VoidCallback? onPressed;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: showBorder ? Border.all(color: TColors.dark) : null,
        color: backgroundColor != null
        ? backgroundColor!
        : THelperFunction.isDarkMode(context)
          ? Colors.black.withOpacity(0.9)
          : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(100)
      ),
      child: IconButton(onPressed: onPressed, icon: Icon(icon, color: color, size: size, ),),
      
    );
  }
}