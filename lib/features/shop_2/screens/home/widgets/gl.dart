import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:online_shop/utils/helpers/helper_function.dart';

class WhiteGlassCard extends StatelessWidget {
  final Widget child;
  final double blur;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  const WhiteGlassCard({
    super.key,
    required this.child,
    this.blur = 5,
    this.borderRadius = 100,
    this.padding = const EdgeInsets.all(2),
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15), // frosted white
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: dark ? Colors.white.withOpacity(0.2) : Colors.grey.withOpacity(0.1),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
