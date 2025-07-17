class CategoryModal {
  String id;
  String name;
  String image;
  String parentId;
  bool isFeatured;

  CategoryModal({
    required this.id,
    required this.name,
    required this.image,
    required this.isFeatured,
    this.parentId = '',
  });


static CategoryModal empty() => CategoryModal(id: '', name: '', image: '', isFeatured: false);

Map<String, dynamic> toJson() {
  return {
    'name': name,
    'image': image,
    'parentId': parentId,
    'isFeatured': isFeatured,
  };
}

  factory CategoryModal.fromJson(Map<String, dynamic> json) {
    return CategoryModal(
      id: json['id'],
      name: json['name'],
      image: json['image'], isFeatured: json[false],
    );
  }}