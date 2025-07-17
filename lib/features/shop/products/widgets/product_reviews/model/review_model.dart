class ReviewModel {
  final String? reviewID;
  final String? userID;
  final double? ratingPoint;
  final String? productID;
  final String? reviewText;
  final DateTime? timestamp;
  final String? orderID;

  ReviewModel({
    required this.reviewID,
    required this.userID,
    required this.ratingPoint,
    required this.productID,
    required this.reviewText,
    required this.timestamp,
    required this.orderID,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      reviewID: json['reviewID'],
      userID: json['userID'],
      ratingPoint: (json['ratingPoint'] as num?)?.toDouble(),
      productID: json['productID'],
      reviewText: json['reviewText'],
      timestamp: DateTime.tryParse(json['timestamp'] ?? ''),
      orderID: json['orderID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reviewID': reviewID,
      'userID': userID,
      'ratingPoint': ratingPoint,
      'productID': productID,
      'reviewText': reviewText,
      'timestamp': timestamp?.toIso8601String(),
      'orderID': orderID,
    };
  }
}
