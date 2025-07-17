import 'dart:convert';

class CartItem {
  final String id;
  final String title;
  final String image;
  final int quantity;
  final double price;
  final Map<String, String> variationAttributes;

  CartItem({
    required this.id,
    required this.title,
    required this.image,
    required this.quantity,
    required this.price,
    required this.variationAttributes,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'image': image,
    'quantity': quantity,
    'price': price,
    'variationAttributes': variationAttributes,
  };

factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
  id: json['id'],
  title: json['title'],
  image: json['image'],
  quantity: json['quantity'],
  price: (json['price'] as num).toDouble(),
  variationAttributes: json['variationAttributes'] != null
      ? Map<String, String>.from(json['variationAttributes'])
      : <String, String>{},
);


}
