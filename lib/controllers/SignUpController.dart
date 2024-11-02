import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/user-model.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  //for password visibility
  var isPasswordVisible = false.obs;

  Future<UserCredential?> signUpMethod(
    String userName,
    String userEmail,
    String userPhone,
    String userCity,
    String userPassword,
    String userDeviceToken,
  ) async {
    
    try {
      EasyLoading.show(status: "Please Wait ..");
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: userEmail, 
        password: userPassword
      );

      await userCredential.user!.sendEmailVerification();

      UserModel userModel = UserModel(
        uId: userCredential.user!.uid, 
        username: userName, 
        email: userEmail, 
        phone: userPhone, 
        userImg: '', 
        userDeviceToken : userDeviceToken, 
        country: "", 
        userAddress: "", 
        street: "", 
        isAdmin: false, 
        isActive: true, 
        createdOn: DateTime.now(), 
        city: userCity
        );

      //add data to database
      _firestore.collection("users").doc(userCredential.user!.uid).set(userModel.toMap());
      EasyLoading.dismiss();
      return userCredential;

    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", "$e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFFF5722),
          colorText: Colors.white);
      EasyLoading.dismiss();
    }
    return null;
  }
}
