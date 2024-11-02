

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/GetDeviceTokenController.dart';
import 'package:flutter_application_1/models/user-model.dart';
import 'package:flutter_application_1/screens/user-panel/navigationMenu.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:velocity_x/velocity_x.dart';

class GoogleSignInController extends GetxController {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> SignInWithGoogle() async {
    final GetDeviceTokenController getDeviceTokenController = Get.put(GetDeviceTokenController());
    EasyLoading.show(status: "Please Wait ..");
    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      // Ensure loading indicator is dismissed
      EasyLoading.dismiss();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );

        final UserCredential userCredential = await _auth.signInWithCredential(credential);
        final User? user = userCredential.user;

        if (user != null) {
          UserModel userModel = UserModel(
            uId: user.uid,
            username: user.displayName.toString(),
            email: user.email.toString(),
            phone: user.phoneNumber.toString(),
            userImg: user.photoURL.toString(),
            userDeviceToken: getDeviceTokenController.deviceToken.toString(),
            country: '',
            userAddress: '',
            street: '',
            isAdmin: false,
            isActive: true,
            createdOn: DateTime.now(),
            city: '',
          );
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set(userModel.toMap());
          Get.offAll(() => const NavigationMenu());
        }
      } else {
        // Handle the case where the user cancels the sign-in
        ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(content: ("Failed to login, No accouts").text.make()));
      }
    } catch (e) {
      EasyLoading.dismiss();
      print("Error $e");
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(content: ("An error occurred").text.make()));
    }
  }
}
