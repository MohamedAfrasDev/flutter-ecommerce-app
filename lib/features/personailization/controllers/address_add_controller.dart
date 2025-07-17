import 'dart:convert';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:online_shop/utils/helpers/models/address_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:online_shop/utils/helpers/models/address_model.dart';

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:online_shop/utils/helpers/models/address_model.dart';

import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class AddressAddController extends GetxController {
  static AddressAddController get instance => Get.find();

  static const String _addressesKey = 'saved_addresses';
  static const String _selectedAddressKey = 'selected_address_id';

  Future<List<AddressModel>> getAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_addressesKey);
    if (jsonString == null) return [];
    final List decoded = jsonDecode(jsonString);
    return decoded.map((json) => AddressModel.fromJson(json)).toList();
  }

  Future<void> saveAddresses(List<AddressModel> addresses) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(addresses.map((a) => a.toJson()).toList());
    await prefs.setString(_addressesKey, jsonString);
  }

  Future<void> saveAddress(AddressModel address) async {
    final addresses = await getAddresses();
    addresses.add(address);
    await saveAddresses(addresses);
  }

  Future<void> saveDefaultAddressId(String addressId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedAddressKey, addressId);
  }

  Future<String?> loadDefaultAddressId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_selectedAddressKey);
  }

  String generateId() {
    return const Uuid().v4();
  }
}
