import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product-review-model.dart';

class ProductReviewController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all reviews for a specific product
  Future<List<ProductReviewModel>> fetchProductReviews(String productId) async {
    final querySnapshot = await _firestore
        .collection('products')
        .doc(productId)
        .collection('reviews')
        .get();

    return querySnapshot.docs.map((doc) {
      return ProductReviewModel.fromMap(doc.data());
    }).toList();
  }

  // Calculate the average rating for the specific product
  Future<Map<String, dynamic>> calculateAverageRatingAndReviewCount(
      String productId) async {
    final reviews = await fetchProductReviews(productId);
    if (reviews.isEmpty) return {'averageRating': 0.0, 'reviewCount': 0};

    double totalRating = reviews.fold(0.0, (sum, item) => sum + item.rating);
    double averageRating = totalRating / reviews.length;
    int reviewCount = reviews.length;

    return {
      'averageRating': averageRating,
      'reviewCount': reviewCount,
    };
  }
}
