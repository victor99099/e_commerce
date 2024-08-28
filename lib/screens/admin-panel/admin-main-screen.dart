import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/controllers/ForgetPasswordController.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:velocity_x/velocity_x.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}
void restartApp() {
  SystemNavigator.pop(); // This exits the app
}
class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () async {
              final FirebaseAuth _auth = FirebaseAuth.instance;
              GoogleSignIn googleSignIn = GoogleSignIn();
              
              await _auth.signOut();
              
              await googleSignIn.signOut();

              restartApp();
              // Get.offAll(()=>WellcomeScreen());
            },
            child: Icon(Icons.logout).pOnly(right:10),
          )
        ],
        title: "ADMIN".text.make(),
      ),
    );
  }
}