import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:online_shop/utils/helpers/models/customer_model.dart';
import 'package:online_shop/utils/repository/product_model/product_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeControllers extends GetxController {
  static HomeControllers get instance => Get.find();

  Future<bool> getAppReviewEnabled() async {
    final supabase = Supabase.instance.client;

    try {
      final check =
          await supabase
              .from('app_config')
              .select('value')
              .eq('title', 'Enable Product Review')
              .maybeSingle();

      print('🟢 Supabase check result: $check');

      return check?['value'].toString().toLowerCase() == 'true';
    } catch (e) {
      print('🔴 Error fetching review config: ${e.toString()}');
      return false;
    }
  }

  Future<bool> getAppMaintenenceEnabled() async {
    final supabase = Supabase.instance.client;

    try {
      final check =
          await supabase
              .from('app_config')
              .select('value')
              .eq('title', 'maintenanceMode')
              .maybeSingle();

      print('🟢 Supabase check result: $check');

      return check?['value'].toString().toLowerCase() == 'true';
    } catch (e) {
      print('🔴 Error fetching review config: ${e.toString()}');
      return false;
    }
  }

  Future<bool> getAppCurrencySmbol() async {
    final supabase = Supabase.instance.client;

    try {
      final check =
          await supabase
              .from('app_config')
              .select('value')
              .eq('title', 'currencySymbol')
              .maybeSingle();

      print('🟢 Supabase check resasa🎫🎫sult: $check');

      return check?['value'].toString().toLowerCase() == 'true';
    } catch (e) {
      print('🔴 Error fetching review config: ${e.toString()}');
      return false;
    }
  }

  Future<String> getAppCurrencySymbol() async {
    print('🔍 getAppCurrencySymbol called'); // <-- Check if this appears
    final supabase = Supabase.instance.client;

    try {
      final check =
          await supabase
              .from('app_config')
              .select('value')
              .eq('title', 'currencySymbol')
              .maybeSingle();

      print(
        'Curr🎫🎫ency symbol fetched: ${check?['value']}',
      ); // <-- This should print

      return check?['value']?.toString() ?? '';
    } catch (e) {
      print('🔴 Error fetching config: ${e.toString()}');
      return '';
    }
  }

  Future<String> getAppThemeMode() async {
    print('🔍 getAppCurrencySymbol called'); // <-- Check if this appears
    final supabase = Supabase.instance.client;

    try {
      final check =
          await supabase
              .from('app_config')
              .select('value')
              .eq('description', 'App Theme')
              .maybeSingle();

      String mode = check!['value'].toString().toLowerCase();
      print("3434 $mode");
      if (check!['value'] != null) {
        print('asas🟢🟢🟢s ${mode}');
        if (mode == 'dark') {
          themeMode.value = ThemeMode.dark;
        } else if (mode == 'light') {
          themeMode.value = ThemeMode.light;
        } else {
          themeMode.value = ThemeMode.system;
        }
      } else {
        themeMode.value = ThemeMode.system;
      }
      print(
        'Curr🎫🎫ency symbol fetched: ${check?['value']}',
      ); // <-- This should print

      return check?['value']?.toString() ?? '';
    } catch (e) {
      print('🔴 Error fetching config: ${e.toString()}');
      return '';
    }
  }

  Future<bool> getAppColor() async {
    final supabase = Supabase.instance.client;

    try {
      final check =
          await supabase
              .from('app_config')
              .select('value')
              .eq('title', 'app_color')
              .maybeSingle();

      print('🟢 Supabase check result: $check');

      return check?['value'].toString().toLowerCase() == 'true';
    } catch (e) {
      print('🔴 Error fetching review config: ${e.toString()}');
      return false;
    }
  }

  Future<bool> getApprovedReviewed() async {
    final supabase = Supabase.instance.client;

    try {
      final check =
          await supabase
              .from('app_config')
              .select('value')
              .eq('title', 'Allow Verified Review only')
              .maybeSingle();

      print('🟢 Supabase check result: $check');

      return check?['value'].toString().toLowerCase() == 'true';
    } catch (e) {
      print('🔴 Error fetching review config: ${e.toString()}');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> loadTabCategories() async {
    final response = await Supabase.instance.client
        .from('tab_config')
        .select()
        .eq('is_active', true)
        .eq('tab_location', 'home1')
        .order('order', ascending: true);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> fetchProducts() async {
    try {
      print('Fetching products...');
      final response = await Supabase.instance.client
          .from('products')
          .select()
          .eq('offerValue', 'newArrival')
          .order('created_at', ascending: false);

      print('Response from Supabase: $response');

      if (response == null || response.isEmpty) {
        print('No products found');

        return;
      }

      final data = response as List<dynamic>;
      final loadedProducts =
          data.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e, st) {
      print('Error fetching products: $e');
      print('Stack trace: $st');
    }
  }

  final user = Rxn<CustomerModel>();

  Future<void> getUser(String id) async {
    final supabase = Supabase.instance.client;
    final storage = GetStorage();
    try {
      final response =
          await supabase
              .from('customers')
              .select()
              .eq('customerID', id)
              .maybeSingle();

      if (response != null) {
        user.value = CustomerModel.fromJson(response);
        print('🟢 User Loaded: ${user.value!.customerName}');
        storage.write('UserID', user.value!.customerID.toString());
        storage.write('UserEmail', user.value!.customerEmail.toString());
        storage.write('UserName', user.value!.customerName.toString());
        storage.write('UserImage', user.value!.customerImage.toString());
        storage.write(
          'UserPhoneNumber',
          user.value!.customerPhoneNumber.toString(),
        );
      } else {
        print('🟡 No user found for $id');
      }
    } catch (e) {
      print('🔴 Error loading user: ${e.toString()}');
    }
  }

  var themeMode = ThemeMode.system.obs;
  Future<bool> loadThemeMode() async {
    final supabase = Supabase.instance.client;

    try {
      final response =
          await supabase
              .from('app_config')
              .select('value')
              .eq(
                'title',
                'app_theme',
              ) // <-- This must match your exact theme title in DB
              .maybeSingle();

      print('🔍 Supabase response: $response');

      if (response != null && response['value'] != null) {
        String mode = response['value'].toString().toLowerCase().trim();

        print('Theme mode from DB: $mode');

        if (mode == 'dark') {
          themeMode.value = ThemeMode.dark;
        } else if (mode == 'light') {
          themeMode.value = ThemeMode.light;
        } else {
          themeMode.value = ThemeMode.system;
        }
      } else {
        themeMode.value = ThemeMode.system;
      }
    } catch (e) {
      print('Error loading theme mode: $e');
      themeMode.value = ThemeMode.system;
    }
    return true;
  }
}
