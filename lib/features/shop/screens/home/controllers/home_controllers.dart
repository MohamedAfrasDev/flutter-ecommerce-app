import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:online_shop/utils/helpers/models/customer_model.dart';
import 'package:online_shop/utils/repository/product_model/product_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeControllers extends GetxController {
  static HomeControllers get instance => Get.find();

  final user = Rxn<CustomerModel>();
  var themeMode = ThemeMode.system.obs;

  Future<bool> getAppReviewEnabled() async {
    final supabase = Supabase.instance.client;
    try {
      final check = await supabase
          .from('app_config')
          .select('value')
          .eq('title', 'Enable Product Review')
          .maybeSingle();
      return check?['value'].toString().toLowerCase() == 'true';
    } catch (e) {
      debugPrint('Error fetching review config: $e');
      return false;
    }
  }

  Future<bool> getAppMaintenenceEnabled() async {
    final supabase = Supabase.instance.client;
    try {
      final check = await supabase
          .from('app_config')
          .select('value')
          .eq('title', 'maintenanceMode')
          .maybeSingle();
      return check?['value'].toString().toLowerCase() == 'true';
    } catch (e) {
      debugPrint('Error fetching maintenance config: $e');
      return false;
    }
  }

  Future<String> getAppCurrencySymbol() async {
    final supabase = Supabase.instance.client;
    try {
      final check = await supabase
          .from('app_config')
          .select('value')
          .eq('title', 'currencySymbol')
          .maybeSingle();
      return check?['value']?.toString() ?? '';
    } catch (e) {
      debugPrint('Error fetching currency symbol: $e');
      return '';
    }
  }

  Future<String> getAppThemeMode() async {
    final supabase = Supabase.instance.client;
    try {
      final check = await supabase
          .from('app_config')
          .select('value')
          .eq('description', 'App Theme')
          .maybeSingle();

      if (check != null && check['value'] != null) {
        String mode = check['value'].toString().toLowerCase();
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
      return check?['value']?.toString() ?? '';
    } catch (e) {
      debugPrint('Error fetching theme mode: $e');
      return '';
    }
  }

  Future<bool> getAppColor() async {
    final supabase = Supabase.instance.client;
    try {
      final check = await supabase
          .from('app_config')
          .select('value')
          .eq('title', 'app_color')
          .maybeSingle();
      return check?['value'].toString().toLowerCase() == 'true';
    } catch (e) {
      debugPrint('Error fetching app color config: $e');
      return false;
    }
  }

  Future<bool> getApprovedReviewed() async {
    final supabase = Supabase.instance.client;
    try {
      final check = await supabase
          .from('app_config')
          .select('value')
          .eq('title', 'Allow Verified Review only')
          .maybeSingle();
      return check?['value'].toString().toLowerCase() == 'true';
    } catch (e) {
      debugPrint('Error fetching review approval config: $e');
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
      final response = await Supabase.instance.client
          .from('products')
          .select()
          .eq('offerValue', 'newArrival')
          .order('created_at', ascending: false);

      if (response == null || response.isEmpty) return;

      final data = response as List<dynamic>;
      data.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error fetching products: $e');
    }
  }

  Future<void> getUser(String id) async {
    final supabase = Supabase.instance.client;
    final storage = GetStorage();
    try {
      final response = await supabase
          .from('customers')
          .select()
          .eq('customerID', id)
          .maybeSingle();

      if (response != null) {
        user.value = CustomerModel.fromJson(response);
        storage.write('UserID', user.value!.customerID.toString());
        storage.write('UserEmail', user.value!.customerEmail.toString());
        storage.write('UserName', user.value!.customerName.toString());
        storage.write('UserImage', user.value!.customerImage.toString());
        storage.write('UserPhoneNumber', user.value!.customerPhoneNumber.toString());
      }
    } catch (e) {
      debugPrint('Error loading user: $e');
    }
  }

  Future<bool> loadThemeMode() async {
    final supabase = Supabase.instance.client;
    try {
      final response = await supabase
          .from('app_config')
          .select('value')
          .eq('title', 'app_theme')
          .maybeSingle();

      if (response != null && response['value'] != null) {
        String mode = response['value'].toString().toLowerCase().trim();
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
      debugPrint('Error loading theme mode: $e');
      themeMode.value = ThemeMode.system;
    }
    return true;
  }
}
