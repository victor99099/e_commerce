import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserValidationController extends GetxController {
  RxBool isInfoComplete = false.obs;

  void validateUserInfo(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data()!;
        if (userData['username'].isNotEmpty &&
            userData['phone'].isNotEmpty &&
            userData['city'].isNotEmpty &&
            userData['street'].isNotEmpty &&
            userData['userAddress'].isNotEmpty) {
          isInfoComplete.value = true;
        } else {
          isInfoComplete.value = false;
        }
      } else {
        isInfoComplete.value = false;
      }
    } catch (e) {
      print("Error validating user info: $e");
      isInfoComplete.value = false;
    }
  }
}