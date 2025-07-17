import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_shop/utils/http/app/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cart_item_model.dart';

class CartController extends GetxController {
  final cartItems = <CartItem>[].obs;
    final cartFastItems = <CartItem>[].obs;


  static const String _storageKey = 'cart_items';

  @override
  void onInit() {
    super.onInit();
    _loadCartFromStorage();
    _loadCartTempFromStorage();
  }

  Future<void> _loadCartFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      cartItems.value = jsonList.map((e) => CartItem.fromJson(e)).toList();
    }
  }
 Future<void> _loadCartTempFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('_tempCart');
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      cartFastItems.value = jsonList.map((e) => CartItem.fromJson(e)).toList();
    }
  }
  Future<void> _saveCartToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = cartItems.map((e) => e.toJson()).toList();
    final jsonString = json.encode(jsonList);
    await prefs.setString(_storageKey, jsonString);
  }


    Future<void> _saveTempToCart() async {
      
    final prefs = await SharedPreferences.getInstance();
    final jsonList = cartFastItems.map((e) => e.toJson()).toList();
    final jsonString = json.encode(jsonList);
    await prefs.setString('_tempCart', jsonString);

    print("👍👍");
  }

  void addToCart(CartItem item) {
    final index = cartItems.indexWhere(
      (e) =>
          e.id == item.id &&
          e.price == item.price &&
          const DeepCollectionEquality().equals(
            e.variationAttributes,
            item.variationAttributes,
          ),
    );

    if (index >= 0) {
      final existingItem = cartItems[index];
      cartItems[index] = CartItem(
        id: existingItem.id,
        title: existingItem.title,
        image: existingItem.image,
        quantity: existingItem.quantity + item.quantity,
        price: existingItem.price,
        variationAttributes: existingItem.variationAttributes,
      );
    } else {
      cartItems.add(item);
    }
    _saveCartToStorage();
  }


  
  void addToCartTemp(CartItem item) {
    cartFastItems.clear();
    final index = cartFastItems.indexWhere(
      (e) =>
          e.id == item.id &&
          e.price == item.price &&
          const DeepCollectionEquality().equals(
            e.variationAttributes,
            item.variationAttributes,
          ),
    );

    if (index >= 0) {
      final existingItem = cartFastItems[index];
      cartFastItems[index] = CartItem(
        id: existingItem.id,
        title: existingItem.title,
        image: existingItem.image,
        quantity: existingItem.quantity + item.quantity,
        price: existingItem.price,
        variationAttributes: existingItem.variationAttributes,
      );
    } else {
      cartFastItems.add(item);
    }
    _saveTempToCart();
  }

  void removeFromCart(String id) {
    cartItems.removeWhere((item) => item.id == id);
    _saveCartToStorage();
  }


 void removeFromCartFast(String id) {
    cartFastItems.removeWhere((item) => item.id == id);
    _saveTempToCart();
  }
  void clearCart() {
    cartItems.clear();
    cartFastItems.clear();
    _saveCartToStorage();
    _saveTempToCart();
  }

  double get subTotal => cartItems.fold(
      0.0, (sum, item) => sum + (item.price * item.quantity));

        double get totalPrice => cartItems.fold(
      0.0, (sum, item) => sum + (item.price * item.quantity));

        double get subTotalFast => cartFastItems.fold(
      0.0, (sum, item) => sum + (item.price * item.quantity));

        double get totalPriceFast => cartFastItems.fold(
      0.0, (sum, item) => sum + (item.price * item.quantity));
}
    void _showBottomSheet(BuildContext context) {
      final cartController = Get.put(CartController());
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               Obx(() {
        if (cartController.cartItems.isEmpty) {
          return const Center(child: Text('Cart is empty'));
        }
        return SizedBox(
          height: 300,
          child: ListView.builder(
            itemCount: cartController.cartFastItems.length,
            itemBuilder: (context, index) {
              final item = cartController.cartFastItems[index];
              return ListTile(
                leading: Image.network(item.image, width: 50),
                title: Text(item.title, maxLines: 2, overflow: TextOverflow.ellipsis, softWrap: true,),
                subtitle: Text('Qty: ${item.quantity}'),
                
                trailing: Column(
                  children: [
                    Text('Qty 1: LKR ${item.price}'),
                    Text('\LKR ${(item.price * item.quantity).toStringAsFixed(2)}',style: Theme.of(context).textTheme.titleSmall,),
                  ],
                ),
                
                onLongPress: () => cartController.removeFromCart(item.id),
              );
            },
          ),
        );
      }),
            ],
          ),
        );
      },
    );
  }