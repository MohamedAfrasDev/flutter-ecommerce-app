import 'package:uuid/uuid.dart';

class PaymentAddModel {
  final String? APIKey;
  final String? id;
  final String? MerchantID;
  final String? PaymentProvider;
  final DateTime? created_at;
  final bool? isActive;
  final bool? isSandBox;
  final int? processing_fee;

  PaymentAddModel({
    required this.APIKey,
    required this.MerchantID,
    required this.PaymentProvider,
    required this.created_at,
    required this.isActive,
    required this.id,
    required this.isSandBox,
    required this.processing_fee,
  });

  // ✅ Convert Dart object to JSON (Map<String, dynamic>)
  Map<String, dynamic> toJson() {
    return {
      'APIKey': APIKey,
      'MerchantID': MerchantID,
      'PaymentProvider': PaymentProvider,
      'created_at': created_at?.toIso8601String(),
      'isActive': isActive,
      'id': id,
      'isSandBox' : isSandBox,
      'processing_fee' : processing_fee,
    };
  }

  // ✅ Create Dart object from JSON (Map<String, dynamic>)
  factory PaymentAddModel.fromJson(Map<String, dynamic> json) {
    return PaymentAddModel(
      APIKey: json['APIKey'] as String?,
      MerchantID: json['MerchantID'] as String?,
      PaymentProvider: json['PaymentProvider'] as String?,
      created_at: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      isActive: json['isActive'] as bool?,
      id: json['id'] ?? Uuid().v4(),
      isSandBox: json['isSandBox'] as bool?,
      processing_fee: json['processing_fee'] as int?
    );
  }
}
