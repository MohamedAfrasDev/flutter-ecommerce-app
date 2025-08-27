import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:online_shop/common/widgets/custom_shapes/appbar/appbar.dart';
import 'package:online_shop/common/widgets/listview/settings_menu_tile.dart';
import 'package:online_shop/common/widgets/listview/user_profile_title.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/primary_header_widget.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/section_heading.dart';
import 'package:online_shop/features/authentication/screens/login/login.dart';
import 'package:online_shop/features/personailization/screens/address/address.dart';
import 'package:online_shop/features/shop/screens/cart/cart.dart';
import 'package:online_shop/features/shop/screens/order_successful_screen/controllers/monthly_sales_controller.dart';
import 'package:online_shop/features/shop/screens/order_successful_screen/controllers/order_controller.dart';
import 'package:online_shop/features/shop/screens/orders/order.dart';
import 'package:online_shop/features/shop_2/screens/controller/customer_controller.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final controller = Get.put(CustomerController());
  final storage = GetStorage();

  final monthlySalesController = Get.put(MonthlySalesController());

  @override
  void initState() {
    super.initState();
    setState(() {
      controller.getUserDetail(Supabase.instance.client.auth.currentUser!.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final storage = GetStorage();

    final customerController = Get.put(CustomerController());

    final orderController = Get.put(OrderController());

    print(customerController.checkCustomerExist(storage.read('UID')));
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TPrimaryHeader(
              child: Column(
                children: [
                  TAppBar(
                    title: Text(
                      'Account',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium!.apply(color: Colors.white),
                    ),
                  ),

                  TUserProfileTitle(),
                  const SizedBox(height: TSizes.spaceBetwwenSections),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                children: [
                  const TSectionHeading(
                    title: 'Account Settings',
                    showActionButton: false,
                  ),
                  const SizedBox(height: TSizes.spaceBetwwenItems),

                  TSettingsMenuTile(
                    icon: Iconsax.safe_home_copy,
                    title: "My Addresses",
                    subTitle: "Set shopping deleivery address",
                    onTap: () => Get.to(() => const UserAddressScreen()),
                  ),
                  const SizedBox(height: TSizes.sm),
                  TSettingsMenuTile(
                    icon: Iconsax.shopping_cart_copy,
                    title: "My Cart",
                    subTitle: "Add, remove products and move to checkout",
                    onTap: () => Get.to(() => CartScreen()),
                  ),
                  const SizedBox(height: TSizes.sm),
                  TSettingsMenuTile(
                    icon: Iconsax.bag_tick_copy,
                    title: "My Orders",
                    subTitle: "In-progress and Completed Orders",
                    onTap: () => Get.to(() => const OrderScreen()),
                  ),
                  const SizedBox(height: TSizes.sm),

                  // TSettingsMenuTile(icon: Iconsax.notification_copy, title: "Notification", subTitle: "Set any kind of notification message", onTap: () {
                  //  //     orderController.updateProductStocks(productID: '411e1f92-6a23-49a1-a085-a288e5af0598', selectedStock: 2, variationId: '[#58155]');

                  // }),
                  const SizedBox(height: TSizes.spaceBetwwenItems),
                  TSectionHeading(
                    title: 'App Settings',
                    showActionButton: false,
                  ),

                  const SizedBox(height: TSizes.spaceBetwwenSections),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Supabase.instance.client.auth.signOut();

                        final storage = GetStorage();
                        storage.erase();
                        Get.offAll(() => LoginScreen());
                      },
                      child: const Text('Logout'),
                    ),
                  ),

                  
                  const SizedBox(height: TSizes.spaceBetwwenSections * 2.5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
