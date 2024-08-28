// ignore_for_file: file_names

class OrderModel {
  final String brandId;
  final String brandName;
  final String categoryId;
  final String categoryName;
  final String payOption;
  final dynamic createdAt;
  final String customerAddress;
  final String customerStreet;
  final String noteToRider;
  final String customerDeviceToken;
  final String customerId;
  final String customerName;
  final String customerPhone;
  final String deliveryTime;
  final String fullPrice;
  final bool isSale;
  final String productDescription;
  final String productId;
  final List productImages;
  final String productColor;
  final String productName;
  final int productQuantity;
  final double productTotalPrice;
  final String salePrice;
  final bool status;
  final dynamic updatedAt;

  OrderModel({
    required this.brandId,
    required this.brandName,
    required this.categoryId,
    required this.categoryName,
    required this.payOption,
    required this.createdAt,
    required this.customerAddress,
    required this.customerStreet,
    required this.noteToRider,
    required this.customerDeviceToken,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.deliveryTime,
    required this.fullPrice,
    required this.isSale,
    required this.productDescription,
    required this.productId,
    required this.productImages,
    required this.productColor,
    required this.productName,
    required this.productQuantity,
    required this.productTotalPrice,
    required this.salePrice,
    required this.status,
    required this.updatedAt,
  });

// Convert the object to a map
  Map<String, dynamic> toJson() {
    return {
      'brandId': brandId,
      'brandName': brandName,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'payOption': payOption,
      'createdAt': createdAt,
      'customerAddress': customerAddress,
      'customerStreet': customerStreet,
      'noteToRider': noteToRider,
      'customerDeviceToken': customerDeviceToken,
      'customerId': customerId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'deliveryTime': deliveryTime,
      'fullPrice': fullPrice,
      'isSale': isSale,
      'productDescription': productDescription,
      'productId': productId,
      'productImages': productImages,
      'productColor': productColor,
      'productName': productName,
      'productQuantity': productQuantity,
      'productTotalPrice': productTotalPrice,
      'salePrice': salePrice,
      'status': status,
      'updatedAt': updatedAt,
    };
  }

  // Create an instance of the class from a map
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      brandId: json['brandId'],
      brandName: json['brandName'],
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      createdAt: json['createdAt'],
      payOption: json['payOption'],
      customerAddress: json['customerAddress'],
      customerStreet: json['customerStreet'],
      noteToRider: json['noteToRider'],
      customerDeviceToken: json['customerDeviceToken'],
      customerId: json['customerId'],
      customerName: json['customerName'],
      customerPhone: json['customerPhone'],
      deliveryTime: json['deliveryTime'],
      fullPrice: json['fullPrice'],
      isSale: json['isSale'],
      productDescription: json['productDescription'],
      productId: json['productId'],
      productImages: json['productImages'],
      productColor: json['productColor'],
      productName: json['productName'],
      productQuantity: json['productQuantity'],
      productTotalPrice: json['productTotalPrice'],
      salePrice: json['salePrice'],
      status: json['status'],
      updatedAt: json['updatedAt'],
    );
  }
}
