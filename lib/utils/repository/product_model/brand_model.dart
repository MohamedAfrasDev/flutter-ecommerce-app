import 'package:uuid/uuid.dart';

class BrandModel {
  final String id;
  final String title;
  final String category;
  final bool isFeatured;
  final String imageUrl;
  final String createdAt;

  BrandModel({
    String? id,
    required this.title,
    required this.category,
    required this.isFeatured,
    required this.imageUrl,
    String? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now().toIso8601String();

  factory BrandModel.fromJson(Map<String, dynamic> json) => BrandModel(
        id: json['id'] ?? const Uuid().v4(),
        title: json['title'] ?? '',
        category: json['category'] ?? '',
        isFeatured: json['is_featured'] ?? false,
        imageUrl: json['image_url'] ?? '',
        createdAt: json['created_at'] ?? DateTime.now().toIso8601String(),
      );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image_url': imageUrl,
      'category': category,
      'is_featured': isFeatured,
      'created_at': createdAt,
    };
  }
}
