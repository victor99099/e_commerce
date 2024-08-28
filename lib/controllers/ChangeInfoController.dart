import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ChangeInfoController extends GetxController{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> UpdateInfo(
    String name,
    String phoneNo,
    String city,
    String address,
    String street
  ) async
  {
    await _firestore.collection('users').doc(user!.uid).update({
      'userAddress':address,
      'username':name,
      'phone':phoneNo,
      'city':city,
      'street':street
    });
  }
}