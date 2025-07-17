import 'package:flutter/material.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/constants/sizes.dart';

class TRoundedContainer extends StatelessWidget {
  const TRoundedContainer({super.key, this.width, this.height, this.radius = TSizes.cardRadiusLg, this.child, this.showBorder = false, this.borderColor = TColors.borderPrimary,  this.backgroundColor = Colors.white, this.padding, this.margin, this.isShadow});


final double? width;
final double? height;
final double radius;
final Widget? child;
final bool showBorder;
final Color borderColor;
final Color backgroundColor;
final EdgeInsetsGeometry? padding;
final EdgeInsetsGeometry? margin;

final bool? isShadow;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      
     decoration: BoxDecoration(
  color: backgroundColor,
  borderRadius: BorderRadius.circular(radius),
  border: showBorder ? Border.all(color: borderColor) : null,
  boxShadow: isShadow == true
      ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // shadow color with opacity
            blurRadius: 6, // blur effect
            offset: Offset(0, 3), // position of the shadow (x,y)
          ),
        ]
      : null,
),

      child: child,
    );
  }
}