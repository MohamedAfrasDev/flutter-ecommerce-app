import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:online_shop/utils/constants/env_config.dart';
import 'package:online_shop/utils/http/payments/payhere/payhere_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:online_shop/features/personailization/controllers/address_add_controller.dart';
import 'package:online_shop/features/shop/products/controller/product_controller.dart';
import 'package:online_shop/features/shop/screens/cart/controller/cart_controller.dart';
import 'package:online_shop/features/shop/screens/home/controllers/home_controllers.dart';
import 'package:online_shop/features/shop_2/screens/controller/customer_controller.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/constants/json_service.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await JsonService().loadJson();
  await GetStorage.init();

  bool isSupabaseInitialized = false;
  try {
    await Supabase.initialize(
      url: EnvConfig.supabaseUrl,
      anonKey: EnvConfig.supabaseAnonKey,
    );
    isSupabaseInitialized = true;
  } catch (e) {
    debugPrint('Supabase initialization failed: $e');
  }

  if (isSupabaseInitialized) {
    await TColors.loadPrimaryColorFromSupabase();
    Get.put(ProductController());
    Get.put(HomeControllers());
    Get.put(CustomerController());
    Get.put(CartController());
    Get.put(AddressAddController());
    Get.put(PayhereController());
  }

  runApp(const App());
}
