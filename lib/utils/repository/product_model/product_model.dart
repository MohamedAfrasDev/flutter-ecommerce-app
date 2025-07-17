
import 'package:online_shop/utils/repository/product_model/attributes_model.dart';
import 'package:online_shop/utils/repository/product_model/brand_model.dart';
import 'package:online_shop/utils/repository/product_model/variation_model.dart';

class ProductModel {
  final String? id;
  final String? sku;
  final bool? isFeatured;
  final String? title;
  final BrandModel? brand;
  final List<ProductVariantionsModel>? variation;
  final String? description;
  final String? productType;
  final int? stock;
  final double? price;
  final List<String>? images;
  final double? salesPrice;
  final String? thumbnail;
  final List<ProductAttributeModel>? productAttributes;
  final DateTime? date;
  final String? offerValue;
  final double? rating;

  ProductModel({
    this.id,
    this.sku,
    this.isFeatured,
    this.title,
    this.brand,
    this.variation,
    this.description,
    this.productType,
    this.stock,
    this.price,
    this.images,
    this.salesPrice,
    this.thumbnail,
    this.productAttributes,
    this.date,
    this.offerValue,
    this.rating,
  });
Map<String, dynamic> toJson() => {
  'id': id,
  'sku': sku ?? '',
  'is_featured': isFeatured ?? false,
  'title': title ?? '',
  'brand': brand?.toJson() ?? {}, // provide empty map if null
  'variation': variation?.map((v) => v.toJson()).toList() ?? [],
  'description': description ?? '',
  'product_type': productType ?? '',
  'stock': stock ?? 0,
  'price': price ?? 0.0,
  'images': images ?? [],
  'sales_price': salesPrice ?? 0.0,
  'thumbnail': thumbnail ?? '',
  'product_attributes': productAttributes?.map((a) => a.toJson()).toList() ?? [],
  'created_at': date?.toIso8601String() ?? DateTime.now().toIso8601String(),
  'offerValue': offerValue,
  'rating': rating ?? 0.0,
};
factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
  id: json['id'] as String?,
  sku: json['sku'] as String?,
  isFeatured: json['is_featured'] as bool? ?? false,
  title: json['title'] as String?,
  brand: json['brand'] != null
      ? BrandModel.fromJson(json['brand'] as Map<String, dynamic>)
      : null,
  variation: json['variation'] != null
      ? (json['variation'] as List)
          .map((v) => ProductVariantionsModel.fromJson(v as Map<String, dynamic>))
          .toList()
      : [],
  description: json['description'] as String?,
  productType: json['product_type'] as String?,
  stock: json['stock'] is int
      ? json['stock'] as int
      : int.tryParse(json['stock'].toString()) ?? 0,
  price: (json['price'] as num?)?.toDouble() ?? 0.0,
  images: json['images'] != null ? List<String>.from(json['images']) : [],
  salesPrice: (json['sales_price'] as num?)?.toDouble() ?? 0.0,
  thumbnail: json['thumbnail'] as String?,
  productAttributes: json['product_attributes'] != null
      ? (json['product_attributes'] as List)
          .map((a) => ProductAttributeModel.fromJson(a as Map<String, dynamic>))
          .toList()
      : [],
  date: json['created_at'] != null
      ? DateTime.tryParse(json['created_at']) ?? DateTime.now()
      : DateTime.now(),
  offerValue: json['offerValue'] as String?,
  rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
);


}
