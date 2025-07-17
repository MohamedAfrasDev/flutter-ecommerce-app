import 'package:flutter/material.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:online_shop/utils/device/device_utility.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:online_shop/utils/helpers/helper_function.dart';

class THomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const THomeAppBar({super.key, this.title,  this.showBackArrrow = false, this.leadingIcon, this.actions, this.leadingOnPressed});

  final Widget? title;
  final bool showBackArrrow;
  final IconData? leadingIcon;
  final List<Widget>? actions;
  final VoidCallback? leadingOnPressed;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    return Padding(padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
    child: AppBar(
      automaticallyImplyLeading: false,
      leading: showBackArrrow
      ? IconButton(onPressed: () => Get.back(), icon: const Icon(Iconsax.arrow_left_2_copy), color: dark ? Colors.white : Colors.black,)
      : leadingIcon != null ? IconButton(onPressed: () => Get.back(), icon: Icon(leadingIcon)) : null, 
      title: title,
      actions: actions,),);
  }
  
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(TDeviceUtils.getAppBarHeight());
}