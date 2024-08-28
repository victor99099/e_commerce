import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/ForgetPasswordController.dart';
import 'package:flutter_application_1/controllers/SignINController.dart';
import 'package:flutter_application_1/screens/user-panel/mainScreen.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';

import 'SignUpScreen.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final ForgetPasswordController forgetPasswordController =
      Get.put(ForgetPasswordController());
  TextEditingController useremail = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final getTheme = Theme.of(context);
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return Scaffold(
        appBar: AppBar(),
        body: Container(
          child: Column(
            children: [
              isKeyboardVisible
                  ? "WellCome To Shopify"
                      .text
                      .xl
                      .color(getTheme.colorScheme.onPrimary)
                      .make().pOnly(bottom: 30)
                  : Container(
                      height: Get.height * 0.2,
                      width: Get.width,
                      child: Lottie.asset("assets/images/loadingCart.json"),
                    ).p12(),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                        color: getTheme.cardColor,
                        // border: Border.,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
                    width: Get.width,
                    height: Get.height*0.63,
                    child: Column(
                      children: [
                        Container(
                          child: Padding(
                            padding: Vx.m16,
                            child: Column(
                              children: [
                                (Get.height * 0.01).heightBox,
                                "Forget Password"
                                    .text
                                    .xl3
                                    .color(getTheme.colorScheme.onPrimary)
                                    .make(),
                                (Get.height * 1 / 30).heightBox,
                                TextFormField(
                                  controller: useremail,
                                  cursorColor: getTheme.colorScheme.onPrimary,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    filled: true, // Enable filling
                                    fillColor: getTheme.colorScheme.surface,
                                    hintText: "Enter Email",
                                    prefixIcon: Icon(Icons.email,
                                        color: getTheme.colorScheme.onPrimary),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: getTheme.colorScheme.surface),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: getTheme.colorScheme
                                              .surface), // Default border color
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: getTheme.colorScheme
                                              .tertiary), // Border color when focused
                                    ),
                                    contentPadding:
                                        EdgeInsets.only(top: 2.0, left: 8.0),
                                  ),
                                ).pOnly(bottom: 10),
                                (Get.height * 1 / 20).heightBox,
                                Material(
                                  color: Colors.transparent,
                                  child: Container(
                                    color: Colors.transparent,
                                    child: TextButton(
                                      style: ButtonStyle(
                                          foregroundColor:
                                              WidgetStatePropertyAll(
                                                  Colors.transparent),
                                          backgroundColor:
                                              WidgetStateProperty.all(
                                                  getTheme.colorScheme.surface),
                                          shape:WidgetStatePropertyAll(RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10)
                                          )) ,
                                          overlayColor: WidgetStatePropertyAll(
                                              getTheme.colorScheme.primary)),
                                      onPressed: () async {
                                        String email = useremail.text.trim();

                                        if (email.isEmpty) {
                                          Get.snackbar("Error",
                                              "Please enter all details!",
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              backgroundColor:
                                                  Color(0xFFFF5722),
                                              colorText: Colors.white);
                                        } else {
                                          String email = useremail.text.trim();
                                          forgetPasswordController
                                              .forgetPasswordMethod(email);
                                        }
                                      },
                                      child: "Forget"
                                          .text
                                          .color(getTheme.colorScheme.onPrimary)
                                          .make(),
                                    ).wh((Get.width * 1 / 2),
                                        (Get.height * 1 / 12)),
                                  ),
                                ).pOnly(bottom: 20),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
