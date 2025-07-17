import 'package:online_shop/utils/helpers/models/address_model.dart';

class CustomerModel {
  final String? customerID;
  final String? customerName;
  final String? customerPhoneNumber;
  final String? customerEmail;
  final List<AddressModel>? shippingAddress;
  final List<AddressModel>? billingAddress;
  final String? totalOrder;
  final String? totalSpent;
  final String? currentOrders;
  final DateTime? created_at;
  final String? customerImage;

  CustomerModel({
    required this.customerID,
    required this.customerName,
    required this.customerPhoneNumber,
    required this.customerEmail,
    this.shippingAddress,
    this.billingAddress,
    required this.totalOrder,
    required this.totalSpent,
    required this.currentOrders,
    required this.created_at,
    required this.customerImage,
  });

  Map<String, dynamic> toJson() {
    return {
      'customerID': customerID,
      'customerName': customerName,
      'customerPhoneNumber': customerPhoneNumber,
      'customerEmail': customerEmail,
      'shippingAddress': shippingAddress?.map((e) => e.toJson()).toList() ?? [],
      'billingAddress': billingAddress?.map((e) => e.toJson()).toList() ?? [],
      'totalOrder': totalOrder,
      'totalSpent': totalSpent,
      'currentOrders': currentOrders,
      'created_at': created_at?.toIso8601String(),
      'customerImage': customerImage,
    };
  }

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      customerID: json['customerID'],
      customerName: json['customerName'],
      customerPhoneNumber: json['customerPhoneNumber'],
      customerEmail: json['customerEmail'],
      shippingAddress: (json['shippingAddress'] as List<dynamic>?)
              ?.map((e) => AddressModel.fromJson(e))
              .toList() ??
          [],
      billingAddress: (json['billingAddress'] as List<dynamic>?)
              ?.map((e) => AddressModel.fromJson(e))
              .toList() ??
          [],
      totalOrder: json['totalOrder']?.toString(),
      totalSpent: json['totalSpent']?.toString(),
      currentOrders: json['currentOrders']?.toString(),
      created_at: DateTime.tryParse(json['created_at'].toString()),
      customerImage: json['customerImage']?.toString(),
    );
  }
}
