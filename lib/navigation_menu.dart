import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:get/get.dart';
import 'package:online_shop/features/shop/screens/settings/settings.dart';
import 'package:online_shop/features/shop/screens/store/store.dart';
import 'package:online_shop/features/shop/screens/wishlists/wishlists.dart';
import 'package:online_shop/features/shop_2/screens/home/home_2.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/helpers/helper_function.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NaviagtionController());
    final darkMode = THelperFunction.isDarkMode(context);
    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) => controller.selectedIndex.value = index,
          backgroundColor: darkMode ? TColors.textPrimary: TColors.primary.withOpacity(0.3),
          indicatorColor: darkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1),
          destinations: const [
          NavigationDestination(icon: Icon(Iconsax.home_1_copy), label: 'Home'),
          NavigationDestination(icon: Icon(Iconsax.shop_copy), label: 'Shop'),
          NavigationDestination(icon: Icon(Iconsax.heart_copy), label: 'Whishlist'),
          NavigationDestination(icon: Icon(Iconsax.user_copy), label: 'Profile'),
        ]),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NaviagtionController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;


  final screens = [const HomeScreen_2(),  StoreScreen(), const FavouriteScreen(), const SettingsScreen()];
}