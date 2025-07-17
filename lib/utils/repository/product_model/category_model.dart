import 'package:uuid/uuid.dart';

class CategoryModel {
  final String? id; // NOT Uuid!
  final String? tab_id; // NOT Uuid!
  final String? title;
  final String? imageUrl;
  final bool? isIcon;
  final DateTime? createdAt;
  CategoryModel({
    required this.id,
    required this.tab_id,
    required this.title,
    required this.imageUrl,
    required this.createdAt,
    required this.isIcon,

  });

 factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
  id: json['id'],
  tab_id: json['tab_id'],
  title: json['title'],
  isIcon: json['is_icon'],
  imageUrl: json['image_url'],
  createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
);


  Map<String, dynamic> toJson() => {
  'id': id,
  'tab_id': (tab_id != null && tab_id!.isNotEmpty) ? tab_id : null,
  'title': title,
  'image_url': imageUrl,
  'is_icon': isIcon,
  'created_at': createdAt?.toIso8601String(),
};

}
