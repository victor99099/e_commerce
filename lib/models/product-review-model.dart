// ignore_for_file: file_names

class ProductReviewModel {
  final String userName;
  final String userImage;
  final double rating;
  final String feedback;
  final dynamic updatedAt;
  final String productId;

  ProductReviewModel({
    required this.userName,
    required this.userImage,
    required this.rating,
    required this.feedback,
    required this.updatedAt,
    required this.productId,

  });

  // Serialize the UserModel instance to a JSON map
  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'userImage': userImage,
      'rating': rating,
      'feedback': feedback,
      'updatedAt': updatedAt,
      'productId': productId,
    };
  }

  // Create a UserModel instance from a JSON map
  factory ProductReviewModel.fromMap(Map<String, dynamic> json) {
    return ProductReviewModel(
      userName: json['userName'],
      userImage: json['userImage'],
      rating: json['rating'],
      feedback: json['feedback'],
      updatedAt: json['updatedAt'],
      productId: json['productId'],
    );
  }
}
