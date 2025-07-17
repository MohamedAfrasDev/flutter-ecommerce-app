class BannerModel {
  final String? id;
  final String? imageUrl;
  final bool? isActive;
  final DateTime? createdAt;
  final String? redirectScreen;
  final String? value;

  BannerModel({
    this.id,
    this.imageUrl,
    this.isActive,
    this.createdAt,
    this.redirectScreen,
    this.value,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
        id: json['id'] as String?,
        imageUrl: json['image_url'] as String?,
        isActive: json['is_active'] as bool?,
        redirectScreen: json['redirect_screen'] as String?,
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'] as String),
        value: json['value'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'image_url': imageUrl,
        'is_active': isActive,
        'redirect_screen': redirectScreen,
        'created_at': createdAt?.toIso8601String(),
        'value': value,
      };
}
