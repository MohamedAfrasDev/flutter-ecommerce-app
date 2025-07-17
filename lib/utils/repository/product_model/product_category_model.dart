class ProductCategoryModel {
  final String? id;
  final String? productId;
  final String? categoryId;

  ProductCategoryModel({this.id, this.productId, this.categoryId});

  Map<String, dynamic> toJson() => {
        'id': id,
        'product_id': productId,
        'category_id': categoryId,
      };
}
