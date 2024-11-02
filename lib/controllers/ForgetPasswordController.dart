import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/auth-ui/SignScreen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ForgetPasswordController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> forgetPasswordMethod(String userEmail) async {
    try {
      EasyLoading.show(status: "Please Wait ..");

      // Check if the user email exists in Firestore
      final userQuery = await _firestore
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .get();

      if (userQuery.docs.isEmpty) {
        // If the email is not registered, show an error
        EasyLoading.dismiss();
        Get.snackbar("Error", "No user found with this email",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFFFF5722),
            colorText: Colors.white);
      } else {
        // If the email is registered, send the password reset email
        await _auth.sendPasswordResetEmail(email: userEmail);
        EasyLoading.dismiss();
        Get.snackbar(
            "Request sent successfully", "Password reset link sent to $userEmail",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFFFF5722),
            colorText: Colors.white);
        Get.offAll(()=>const SignScreen());
      }
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      Get.snackbar("Error", e.message ?? "An error occurred",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFFF5722),
          colorText: Colors.white);
    }
  }
}
