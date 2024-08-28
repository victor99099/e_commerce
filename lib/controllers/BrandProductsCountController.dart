import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductController extends GetxController {
  var brandCount = <String, int>{}.obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    countProductsByBrand();
  }

  Future<void> countProductsByBrand() async {
    try {
      isLoading(true);
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('products').get();

      Map<String, int> tempBrandCount = {};

      for (var doc in querySnapshot.docs) {
        String brand = doc['brandName']; // Assuming your product documents have a 'brand' field

        if (tempBrandCount.containsKey(brand)) {
          tempBrandCount[brand] = tempBrandCount[brand]! + 1;
        } else {
          tempBrandCount[brand] = 1;
        }
      }

      brandCount.assignAll(tempBrandCount);
    } finally {
      isLoading(false);
    }
  }
}
