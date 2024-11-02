import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class FlashSaleController extends GetxController {
  // Store the quantities of products
  RxMap<String, int> productQuantities = <String, int>{}.obs;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void onInit() async {
    super.onInit();
     await prefetchQuantities();
  }
  Future<void> prefetchQuantities() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('cart')
        .doc(user!.uid)
        .collection('cartOrders')
        .get();

    for (var doc in snapshot.docs) {
      productQuantities[doc.id] = doc['productQuantity'] as int;
    }
  }

  // Fetch the quantity of a specific product from Firestore
  Future<int> fetchProductQuantity(String productId) async {
    
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection('cart')
        .doc(user!.uid)
        .collection('cartOrders')
        .doc(productId);

    DocumentSnapshot snapshot = await documentReference.get();

    if (snapshot.exists) {
      int quantity = snapshot['productQuantity'] as int;
      productQuantities[productId] = quantity;
      return quantity;
    } else {
      return 0; // Product not in cart, so quantity is 0
    }
  }

  // Method to get the current quantity of a specific product
  Stream<int> getProductQuantityStream(String productId) {
    return FirebaseFirestore.instance
        .collection('cart')
        .doc(user!.uid)
        .collection('cartOrders')
        .doc(productId)
        .snapshots()
        .map((snapshot) {
          if (snapshot.exists) {
            return snapshot['productQuantity'] as int;
          } else {
            return 0; // Default to 0 if product not found
          }
        });
  }
  void decrementProductQuantity(String productId) async {
    if (productQuantities.containsKey(productId)) {
      int currentQuantity = productQuantities[productId]!;
      if (currentQuantity > 0) {
        // Optimistically update the UI
        productQuantities[productId] = currentQuantity - 1;

        // Update Firestore in the background
        final DocumentReference documentReference = FirebaseFirestore.instance
            .collection('cart')
            .doc(user!.uid)
            .collection('cartOrders')
            .doc(productId);

        if (currentQuantity > 1) {
          final DocumentSnapshot snapshot = await documentReference.get();
          final data = snapshot.data()! as Map<String, dynamic>;
          double salePrice = data['productTotalPrice'] as double;

          await documentReference.update({
            'productQuantity': currentQuantity - 1,
            'productTotalPrice': salePrice / currentQuantity * (currentQuantity - 1)
          });
        } else {
          await documentReference.delete();  // Remove product from cart if quantity is 0
        }
      }
    }
  }
   Stream<int> getCartItemsCount() {
    return FirebaseFirestore.instance
        .collection('cart')
        .doc(user!.uid)
        .collection('cartOrders')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
}
