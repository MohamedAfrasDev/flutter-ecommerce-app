import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:online_shop/utils/http/payments/payhere/payhere_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:online_shop/features/personailization/controllers/address_add_controller.dart';
import 'package:online_shop/features/shop/controllers/home_controller.dart';
import 'package:online_shop/features/shop/products/controller/product_controller.dart';
import 'package:online_shop/features/shop/screens/cart/controller/cart_controller.dart';
import 'package:online_shop/features/shop/screens/home/controllers/home_controllers.dart';
import 'package:online_shop/features/shop_2/screens/controller/customer_controller.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/constants/json_service.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load app JSON data
  await JsonService().loadJson();

  // Initialize local storage
  await GetStorage.init();

  // Initialize Supabase
  bool isSupabaseInitialized = false;
  try {
    await Supabase.initialize(
      url: 'https://zlsnfwctlbidxdahlazo.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inpsc25md2N0bGJpZHhkYWhsYXpvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTEyMDM2MzUsImV4cCI6MjA2Njc3OTYzNX0.0MzPCBCaAxo5EAKFQA5iED_EaU83tx1THFjBS215_mM',
    );
    isSupabaseInitialized = true;
    print('✅ Supabase Initialized');
  } catch (e) {
    print('❌ Supabase initialization failed: $e');
  }

  // Load primary color from Supabase (if Supabase initialized)
  if (isSupabaseInitialized) {
    await TColors.loadPrimaryColorFromSupabase();
      // Initialize your GetX controllers BEFORE runApp
  Get.put(ProductController());
  Get.put(HomeControllers());
  Get.put(CustomerController());
  Get.put(CartController());
  Get.put(AddressAddController());
  Get.put(PayhereController());
  }


  // Finally run your app
  runApp(const App());
}
