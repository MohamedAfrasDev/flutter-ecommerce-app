import 'package:flutter/material.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/helpers/helper_function.dart';

class TSettingsMenuTile extends StatelessWidget {
  const TSettingsMenuTile({super.key, required this.icon, required this.title, required this.subTitle, this.trailing, this.onTap});

  final IconData icon;
  final String title, subTitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    return Container(
      
      child: ListTile(
        leading: Icon(icon, size: 28, color: dark ? TColors.primary : TColors.dark),
        title: Text(title, style: Theme.of(context).textTheme.titleMedium,),
        subtitle: Text(subTitle, style: Theme.of(context).textTheme.labelMedium,),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}