import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:online_shop/features/shop/screens/cart/controller/cart_item_model.dart';
import 'package:online_shop/features/shop/screens/order_successful_screen/controllers/order_controller.dart';
import 'package:online_shop/features/shop/screens/order_successful_screen/order_successful.dart';
import 'package:online_shop/features/shop_2/screens/controller/customer_controller.dart';
import 'package:online_shop/utils/helpers/models/address_model.dart';
import 'package:online_shop/utils/helpers/models/order_model.dart';
import 'package:online_shop/utils/http/app/app_config.dart';
import 'package:online_shop/utils/http/payments/keys.dart';
import 'package:online_shop/utils/repository/product_model/attributes_model.dart';
import 'package:online_shop/utils/repository/product_model/product_model.dart';
import 'package:payhere_mobilesdk_flutter/payhere_mobilesdk_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class Config {
  final String? paymentAmount;

  Config({required this.paymentAmount});

  /// Builds the payment map object
  static Map<String, dynamic> buildPaymentObject(String amount) {
    return {
      "sandbox": true,
      "merchant_id": TAPIKeys.merchantID,
      "merchant_secret": TAPIKeys.secretKey,
      "notify_url": "http://sample.com/notify",
      "order_id": "ItemNo12345",
      "items": "Online Shop Purchase",
      "amount": amount,
      "currency": TAppConfig.currency_symbol,
      "first_name": "Saman",
      "last_name": "Perera",
      "email": "samanp@gmail.com",
      "phone": "0771234567",
      "address": "No.1, Galle Road",
      "city": "Colombo",
      "country": "Sri Lanka",
      "delivery_address": "No. 46, Galle road, Kalutara South",
      "delivery_city": "Kalutara",
      "delivery_country": "Sri Lanka",
      "custom_1": "",
      "custom_2": ""
    };
  }

  /// Generate unique Order ID
  String generateOrderID() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'ORDER-$timestamp';
  }

  /// Start full cart payment
  void startPayment(List<CartItem> products, AddressModel? addressModel, String? totalPayment) {
    if (paymentAmount == null || addressModel == null || totalPayment == null) {
      print("❌ Missing data for payment.");
      return;
    }

    final orderID = generateOrderID();
    final double totalAmount = (double.tryParse(totalPayment) ?? 0) + TAppConfig.shipping_cost;

    PayHere.startPayment(
      buildPaymentObject(paymentAmount!),
      (paymentId) {
        print("✅ One Time Payment Success. Payment ID: $paymentId");
        final storage = GetStorage();
        final order = OrderModel(
          orderID: orderID,
          userID: storage.read('UID'),
          orderStatus: 'placed',
          paymentMethod: 'PayHere',
          paymentStatus: 'Paid',
          shippingAddress: [addressModel],
          billingAddress: [addressModel],
          totalPrice: totalAmount,
          shippingCost: TAppConfig.shipping_cost,
          subTotal: double.tryParse(totalPayment),
          taxFee: 0,
          currencySymbol: TAppConfig.currency_symbol,
          orderDate: DateTime.now(),
          products: products.map((item) => item.toJson()).toList(),
          couponCode: null,
          note: null,
        );

        final customerController = Get.put(CustomerController());

        customerController.checkCustomerExist(storage.read('UID'));
        
        final controller = Get.put(OrderController());
        controller.saveOrder(order);
for (final item in products) {
  controller.updateProductStocks(item.id, item.quantity);
}

        Get.offAll(() => OrderSuccessfulScreen(
              products: products,
              paymentID: paymentId,
              addressModel: addressModel,
              totalPayment: totalAmount.toString(),
              orderID: orderID,
            ));
      },
      (error) {
        print("❌ One Time Payment Failed. Error: $error");
      },
      () {
        print("⚠️ One Time Payment Dismissed by user.");
      },
    );
  }

  /// Start instant single-product payment
void startInstantPaymentForProduct(String s, {
  required CartItem product,
  required int quantity,
  required String paymentAmount,
  required AddressModel addressModel,
  required ProductAttributeModel productVariation,
}) {
  if (paymentAmount.isEmpty) {
    print("❌ Missing data for payment.");
    return;
  }


  final orderID = generateOrderID();
  final double subTotal = double.tryParse(paymentAmount) ?? 0;
  final double shippingCost = TAppConfig.shipping_cost;
  final double totalAmount = subTotal + shippingCost;

  PayHere.startPayment(
    buildPaymentObject(paymentAmount),
    (paymentId) async {
      print("✅ One Time Payment Success. Payment ID: $paymentId");

      final storage = GetStorage();
      final order = OrderModel(
        orderID: orderID,
        userID: storage.read('UID'),
        orderStatus: 'placed',
        paymentMethod: 'PayHere',
        paymentStatus: 'Paid',
        shippingAddress: [addressModel],
        billingAddress: [addressModel],
        totalPrice: totalAmount,
        shippingCost: shippingCost,
        subTotal: subTotal,
        taxFee: 0,
        currencySymbol: TAppConfig.currency_symbol,
        orderDate: DateTime.now(),
        products: [
          {
            'id': product.id,
            'title': product.title,
            'quantity': quantity,
            'price': totalAmount,
            'image': product.image ?? '',
            'variationAttributes': productVariation,
          }
        ],
        couponCode: null,
        note: null,
      );

      final customerController = Get.put(CustomerController());
      customerController.checkCustomerExist(storage.read('UID'));

      final controller = Get.put(OrderController());
      await controller.saveOrder(order);

      await controller.updateProductStocks(product.id!, quantity);

      Get.offAll(() => OrderSuccessfulScreen(
            products: [product],  // Corrected: pass ProductModel list
            paymentID: paymentId,
            addressModel: addressModel,
            totalPayment: totalAmount.toString(),
            orderID: orderID,
          ));
    },
    (error) {
      print("❌ One Time Payment Failed. Error: $error");
    },
    () {
      print("⚠️ One Time Payment Dismissed by user.");
    },
  );
}

}
