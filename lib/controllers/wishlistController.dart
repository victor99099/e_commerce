import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/models/product-model.dart';
import 'package:get/get.dart';

import '../models/wishlist-model.dart';

class WishlistController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxMap<String, bool> _wishlistStatus = RxMap<String, bool>();

 
  bool isFav(String productId) {
    return _wishlistStatus[productId] ?? false;
  }

  Future<void> checkIfProductInWishlist({required String uId, required String productId}) async {
    try {
      final documentReference = _firestore
          .collection("wishlist")
          .doc(uId)
          .collection("wishlistProducts")
          .doc(productId);

      DocumentSnapshot snapshot = await documentReference.get();

      // If the document exists, set the value to true, otherwise false
      _wishlistStatus[productId] = snapshot.exists;
    } catch (e) {
      print("Error checking wishlist: $e");
    }
  }

  Future<void> toggleWishlistStatus({required String uId, required ProductModel productModel}) async {
    final documentReference = _firestore
        .collection("wishlist")
        .doc(uId)
        .collection("wishlistProducts")
        .doc(productModel.productId.toString());

    try {
      DocumentSnapshot snapshot = await documentReference.get();

      if (snapshot.exists) {
        // If the product is already in the wishlist, remove it
        await documentReference.delete();
        _wishlistStatus[productModel.productId] = false;
      } else {
        // If the product is not in the wishlist, add it
        WishlistModel wishlistModel = WishlistModel(
          brandId: productModel.brandId,
          brandName: productModel.brandName,
          productColors: productModel.productColors,
          productId: productModel.productId,
          categoryId: productModel.categoryId,
          productName: productModel.productName,
          categoryName: productModel.categoryName,
          salePrice: productModel.salePrice,
          fullPrice: productModel.fullPrice,
          productImages: productModel.productImages,
          deliveryTime: productModel.deliveryTime,
          isSale: productModel.isSale,
          isBest: productModel.isBest,
          productDescription: productModel.productDescription,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await documentReference.set(wishlistModel.toMap());
        _wishlistStatus[productModel.productId] = true;
      }
    } catch (e) {
      print("Error toggling wishlist status: $e");
    }
  }
}
