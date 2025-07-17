import 'package:get/get_rx/get_rx.dart';

class ProductVariantionsModel {
  final String id;
  String sku;
  Rx<String> image;
  String description;
  double price;
  double salePrice;
  int stock;
  int soldQuantity;
  Map<String, String> attributesValues;
  bool? isDefault;

  ProductVariantionsModel({
    required this.id,
    this.sku = '',
    String image = '',
    this.description = '',
    this.price = 0.0,
    this.salePrice = 0.0,
    this.stock = 0,
    this.soldQuantity = 0,
    required this.attributesValues,
    this.isDefault = false
  }) : image = image.obs;

  static ProductVariantionsModel empty() => ProductVariantionsModel(id: '', attributesValues: {});

factory ProductVariantionsModel.fromJson(Map<String, dynamic> json) {
  Map<String, String> attributes = {};

  final attrJson = json['attributesValues'] ?? json['attributesValue']; // check both keys

  if (attrJson != null) {
    if (attrJson is Map) {
      attrJson.forEach((key, value) {
        attributes[key.toString()] = value.toString();
      });
    }
  }

  print('Raw variation JSON: $json');
  print('Parsed attributesValues: $attributes');

  return ProductVariantionsModel(
    id: json['id'] ?? '',
    sku: json['sku'] ?? '',
    image: json['image'] ?? '',
    description: json['description'] ?? '',
    price: (json['price'] is int) ? (json['price'] as int).toDouble() : (json['price'] ?? 0.0),
    salePrice: (json['salesPrice'] is int) ? (json['salesPrice'] as int).toDouble() : (json['salesPrice'] ?? 0.0),
    stock: json['stock'] ?? 0,
    soldQuantity: json['soldQuantity'] ?? 0,
    attributesValues: attributes,
    isDefault: json['isDefault']
  );
}


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sku': sku,
      'image': image.value,
      'description': description,
      'price': price,
      'salesPrice': salePrice,
      'stock': stock,
      'soldQuantity': soldQuantity,
      'attributesValues': attributesValues,
    };
  }
}
