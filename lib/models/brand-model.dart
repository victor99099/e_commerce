// ignore_for_file: file_names

class BrandModel {
  final String brandId;
  final String brandImage;
  final String brandName;
  final dynamic createdAt;
  final dynamic updatedAt;

  BrandModel({
    required this.brandId,
    required this.brandImage,
    required this.brandName,
    required this.createdAt,
    required this.updatedAt,
  });

  // Serialize the UserModel instance to a JSON map
  Map<String, dynamic> toMap() {
    return {
      'brandId': brandId,
      'brandImage': brandImage,
      'brandName': brandName,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  // Create a UserModel instance from a JSON map
  factory BrandModel.fromMap(Map<String, dynamic> json) {
    return BrandModel(
      brandId: json['brandId'],
      brandImage: json['brandImage'],
      brandName: json['brandName'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
