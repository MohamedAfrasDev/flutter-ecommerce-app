import 'package:online_shop/utils/helpers/models/address_model.dart';

class OrderModel {
  final String? orderID;
  final String? userID;
  final String? orderStatus;
  final String? paymentMethod;
  final String? paymentStatus;
  final List<AddressModel> shippingAddress;
  final List<AddressModel> billingAddress;
  final double? totalPrice;
  final double? subTotal;
  final double? shippingCost;
  final double? taxFee;
  final String? currencySymbol;
  final DateTime? orderDate;
  final List<dynamic> products;
  final String? couponCode;
  final String? note;

  OrderModel({
    this.orderID,
    this.userID,
    this.orderStatus,
    this.paymentMethod,
    this.paymentStatus,
    required this.shippingAddress,
    required this.billingAddress,
    this.totalPrice,
    this.shippingCost,
    this.taxFee,
    this.currencySymbol,
    this.orderDate,
    required this.products,
    this.couponCode,
    this.note,
    this.subTotal
  });

  /// Factory method for creating an OrderModel from JSON
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderID: json['orderID'],
      userID: json['userID'],
      orderStatus: json['orderStatus'],
      paymentMethod: json['paymentMethod'],
      paymentStatus: json['paymentStatus'],
      shippingAddress: (json['shippingAddress'] as List<dynamic>)
    .map((e) => AddressModel.fromJson(e as Map<String, dynamic>))
    .toList(),

      billingAddress: (json['billingAddress'] as List)
          .map((e) => AddressModel.fromJson(e))
          .toList(),
      totalPrice: (json['totalPrice'] as num?)?.toDouble(),
      subTotal: (json['subTotal'] as num?)?.toDouble(),
      shippingCost: (json['shippingCost'] as num?)?.toDouble(),
      taxFee: (json['taxFee'] as num?)?.toDouble(),
      currencySymbol: json['currencySymbol'],
      orderDate: json['orderDate'] != null
          ? DateTime.parse(json['orderDate'])
          : null,
      products: json['products'] ?? [],
      couponCode: json['couponCode'],
      note: json['note'],
    );
  }

  /// Method to convert OrderModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'orderID': orderID,
      'userID': userID,
      'orderStatus': orderStatus,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'shippingAddress': shippingAddress.map((e) => e.toJson()).toList(),
      'billingAddress': billingAddress.map((e) => e.toJson()).toList(),
      'totalPrice': totalPrice,
      'shippingCost': shippingCost,
      'taxFee': taxFee,
      'currencySymbol': currencySymbol,
      'orderDate': orderDate?.toIso8601String(),
      'products': products,
      'couponCode': couponCode,
      'note': note,
      'subTotal': subTotal,
    };
  }
}
