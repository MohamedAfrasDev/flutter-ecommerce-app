class SalesCountdownModel {
  final String? id;
  final DateTime? endTime;
  final List<String>? productIds; // List of product IDs
  final String? salesPrice;
  final DateTime? createdAt;

  SalesCountdownModel({
    this.id,
    this.endTime,
    this.productIds,
    this.salesPrice,
    this.createdAt,
  });

  factory SalesCountdownModel.fromJson(Map<String, dynamic> json) {
    return SalesCountdownModel(
      id: json['id'] as String?,
      endTime: json['end_time'] != null ? DateTime.parse(json['end_time']) : null,
      productIds: json['product_ids'] != null
          ? List<String>.from(json['product_ids'])
          : null,
      salesPrice: json['sales_price']?.toString(),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'end_time': endTime?.toIso8601String(),
      'product_ids': productIds,
      'sales_price': salesPrice,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
