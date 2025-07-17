class Product {
  final String image;
  final String varText;
  final String price;
  final String brandImage;
  final String brand;
  final String title;

  Product({
    required this.image,
    required this.varText,
    required this.price,
    required this.brandImage,
    required this.brand,
    required this.title,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      image: json['image'],
      varText: json['varText'],
      price: json['price'],
      brandImage: json['brandImage'],
      brand: json['brand'],
      title: json['title'],
    );
  }
}
