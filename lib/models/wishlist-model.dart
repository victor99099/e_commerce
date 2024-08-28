// ignore_for_file: file_names

class WishlistModel {
  final String brandName;
  final String brandId;
  final List productColors;
  final String productId;
  final String categoryId;
  final String productName;
  final String categoryName;
  final String salePrice;
  final String fullPrice;
  final List productImages;
  final String deliveryTime;
  final bool isSale;
  final bool isBest;
  final String productDescription;
  final dynamic createdAt;
  final dynamic updatedAt;

  WishlistModel({
    required this.brandName,
    required  this.brandId,
    required this.productColors,
    required this.productId,
    required this.categoryId,
    required this.productName,
    required this.categoryName,
    required this.salePrice,
    required this.fullPrice,
    required this.productImages,
    required this.deliveryTime,
    required this.isSale,
    required this.isBest,
    // required this.isFavProduct,
    required this.productDescription,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'brandId': brandId,
      'brandName': brandName,
      'productColors': productColors,
      'productId': productId,
      'categoryId': categoryId,
      'productName': productName,
      'categoryName': categoryName,
      'salePrice': salePrice,
      'fullPrice': fullPrice,
      'productImages': productImages,
      'deliveryTime': deliveryTime,
      'isSale': isSale,
      'productDescription': productDescription,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isBest': isBest,
    };
  }

  factory WishlistModel.fromMap(Map<String, dynamic> json) {
    return WishlistModel(
      brandId: json['brandId'],
      brandName: json['brandName'],
      productColors: json['productColors'],
      productId: json['productId'],
      categoryId: json['categoryId'],
      productName: json['productName'],
      categoryName: json['categoryName'],
      salePrice: json['salePrice'],
      fullPrice: json['fullPrice'],
      productImages: json['productImages'],
      deliveryTime: json['deliveryTime'],
      isSale: json['isSale'],
      productDescription: json['productDescription'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      isBest: json['isBest'],
    );
  }
}
