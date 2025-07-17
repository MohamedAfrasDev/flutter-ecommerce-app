import 'package:flutter/material.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:online_shop/utils/device/device_utility.dart';
class GridViewLayout extends StatelessWidget {
  const GridViewLayout({
    super.key, required this.itemCount, this.mainAxisExtent = 288, required this.itemBuilder, required bool shrinkWrap,
  });

  final int itemCount;
  final double? mainAxisExtent;
  final Widget? Function(BuildContext, int) itemBuilder;

  @override
  Widget build(BuildContext context) {
    final ratio = TDeviceUtils.getScreenHeight() * 0.0007;
    return GridView.builder(
      itemCount: itemCount,
      shrinkWrap: true,
      physics:  NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 1,
    mainAxisSpacing: 16,
    childAspectRatio: ratio, // 🔥 VERY IMPORTANT
  ),
      itemBuilder: itemBuilder,
    );
  }
}

