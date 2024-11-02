import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_1/controllers/SignUpController.dart';
import 'package:flutter_application_1/screens/auth-ui/SignScreen.dart';
import 'package:flutter_application_1/services/notification_service.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../controllers/GetDeviceTokenController.dart';
import '../../controllers/googleSignInController.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isCheck = true;
  final GoogleSignInController _googleSignInController =
      Get.put(GoogleSignInController());
  final SignUpController signUpController = Get.put(SignUpController());
  TextEditingController username1 = TextEditingController();
  TextEditingController username2 = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController password = TextEditingController();
  final GetDeviceTokenController getDeviceTokenController =
      Get.put(GetDeviceTokenController());
  @override
  Widget build(BuildContext context) {
    final getTheme = Theme.of(context);
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: getTheme.colorScheme.surface,
          foregroundColor: getTheme.colorScheme.surface,
          iconTheme: IconThemeData(color: getTheme.colorScheme.onPrimary),
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          return Container(
            height: constraints.maxHeight,
            width: Get.width,
            decoration: BoxDecoration(
                color: getTheme.cardColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            child: SingleChildScrollView(
              physics: const PageScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: Vx.m16,
                    child: Column(
                      children: [
                        (Get.height * 0.01).heightBox,
                        Container(
                          alignment: Alignment.centerLeft,
                          child: "Let's create your account ....."
                              .text
                              .bold
                              .xl2
                              .color(getTheme.colorScheme.onPrimary)
                              // .color(getTheme.colorScheme.onPrimary)
                              .make(),
                        ),
                        (Get.height * 1 / 30).heightBox,
                        Row(
                          children: [
                            TextFormField(
                              controller: username1,
                              cursorColor: getTheme.colorScheme.onPrimary,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(color: getTheme.colorScheme.tertiaryFixed),
                                filled: true, // Enable filling
                                fillColor: getTheme.colorScheme.surface,
                                hintText: "First Name",
                                prefixIcon: Icon(Iconsax.user,
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
                                          .onPrimary), // Border color when focused
                                ),
                                contentPadding:
                                    const EdgeInsets.only(top: 2.0, left: 8.0),
                              ),
                            )
                                .pOnly(bottom: 10)
                                .wh(Get.width / 2.25, Get.height / 14),
                            (Get.width / 90).widthBox,
                            TextFormField(
                              controller: username2,
                              cursorColor: getTheme.colorScheme.onPrimary,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(color: getTheme.colorScheme.tertiaryFixed),
                                filled: true, // Enable filling
                                fillColor: getTheme.colorScheme.surface,
                                hintText: "Last Name",
                                prefixIcon: Icon(Iconsax.user,
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
                                          .onPrimary), // Border color when focused
                                ),
                                contentPadding:
                                    const EdgeInsets.only(top: 2.0, left: 8.0),
                              ),
                            )
                                .wh(Get.width / 2.22, Get.height / 16.8)
                                .pOnly(bottom: 10)
                          ],
                        ),
                        TextFormField(
                          controller: email,
                          cursorColor: getTheme.colorScheme.onPrimary,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: getTheme.colorScheme.tertiaryFixed),
                            filled: true, // Enable filling
                            fillColor: getTheme.colorScheme.surface,
                            hintText: "Email",
                            prefixIcon: Icon(Iconsax.direct,
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
                                      .onPrimary), // Border color when focused
                            ),
                            contentPadding:
                                const EdgeInsets.only(top: 2.0, left: 8.0),
                          ),
                        ).pOnly(bottom: 10),
                        TextFormField(
                          controller: number,
                          cursorColor: getTheme.colorScheme.onPrimary,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: getTheme.colorScheme.tertiaryFixed),
                            filled: true, // Enable filling
                            fillColor: getTheme.colorScheme.surface,
                            hintText: "Number",
                            prefixIcon: Icon(Iconsax.call,
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
                                      .onPrimary), // Border color when focused
                            ),
                            contentPadding:
                                const EdgeInsets.only(top: 2.0, left: 8.0),
                          ),
                        ).pOnly(bottom: 10),
                        TextFormField(
                          
                          controller: city,
                          cursorColor: getTheme.colorScheme.onPrimary,
                          keyboardType: TextInputType.streetAddress,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: getTheme.colorScheme.tertiaryFixed),
                            filled: true, // Enable filling
                            fillColor: getTheme.colorScheme.surface,
                            hintText: "City",
                            prefixIcon: Icon(Iconsax.location,
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
                                      .onPrimary), // Border color when focused
                            ),
                            contentPadding:
                                const EdgeInsets.only(top: 2.0, left: 8.0),
                          ),
                        ).pOnly(bottom: 10),
                        Obx(() => TextFormField(
                              controller: password,
                              cursorColor: getTheme.colorScheme.onPrimary,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText:
                                  signUpController.isPasswordVisible.value,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(color: getTheme.colorScheme.tertiaryFixed),
                                filled: true, // Enable filling
                                fillColor: getTheme.colorScheme.surface,
                                hintText: "Password",
                                suffixIcon: GestureDetector(
                                    onTap: () {
                                      signUpController.isPasswordVisible
                                          .toggle();
                                    },
                                    child: signUpController
                                            .isPasswordVisible.value
                                        ? Icon(Icons.visibility_off,
                                            color:
                                                getTheme.colorScheme.onPrimary)
                                        : Icon(Icons.visibility,
                                            color: getTheme
                                                .colorScheme.onPrimary)),
                                prefixIcon: Icon(Iconsax.password_check,
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
                                          .onPrimary), // Border color when focused
                                ),
                                contentPadding:
                                    const EdgeInsets.only(top: 2.0, left: 8.0),
                              ),
                            ).pOnly(bottom: 7)),
                        Container(
                          padding: const EdgeInsets.only(left: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 3),
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Checkbox(
                                      fillColor: WidgetStatePropertyAll(
                                          getTheme.colorScheme.secondary),
                                      checkColor: Colors.white,
                                      value: isCheck,
                                      onChanged: (value) {
                                        setState(() {
                                          isCheck = value ?? false;
                                        });
                                      }),
                                ),
                              ),
                              Text.rich(TextSpan(children: [
                                TextSpan(
                                    text: "I agree to",
                                    style: TextStyle(
                                        color:
                                            getTheme.colorScheme.tertiaryFixed,
                                        fontSize: 12)),
                                TextSpan(
                                    text: " Privacy Policy",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: getTheme.colorScheme.onPrimary
                                        )),
                                TextSpan(
                                    text: " & ",
                                    style: TextStyle(
                                        color:
                                            getTheme.colorScheme.tertiaryFixed,
                                        fontSize: 12)),
                                TextSpan(
                                    text: "Terms of use",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,color: getTheme.colorScheme.onPrimary)),
                              ])),
                            ],
                          ).pOnly(right: 10),
                        ),
                        (Get.height * 0.04).heightBox,
                        Material(
                          color: Colors.transparent,
                          child: Container(
                            color: Colors.transparent,
                            child: TextButton(
                              style: ButtonStyle(
                                  foregroundColor: const WidgetStatePropertyAll(
                                      Colors.transparent),
                                  backgroundColor: WidgetStateProperty.all(
                                      getTheme.colorScheme.onPrimary),
                                  shape: const WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)))),
                                  overlayColor: WidgetStatePropertyAll(
                                      getTheme.colorScheme.primary)),
                              onPressed: () async {
                                NotificationService notificationService =
                                    NotificationService();
                                String name =
                                    "${username1.text.trim()} ${username2.text.trim()}";
                                String userrmail = email.text.trim();
                                String userphone = number.text.trim();
                                String usercity = city.text.trim();
                                String userpassword = password.text.trim();
                                String userDeviceToken =
                                    await notificationService.getDeviceToken();

                                if (name.isEmpty ||
                                    userrmail.isEmpty ||
                                    userphone.isEmpty ||
                                    usercity.isEmpty ||
                                    userpassword.isEmpty) {
                                  Get.snackbar("Error", "Fill all details",
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: const Color(0xFFFF5722),
                                      colorText: Colors.white);
                                } else {
                                  UserCredential? userCredential =
                                      await signUpController.signUpMethod(
                                          name,
                                          userrmail,
                                          userphone,
                                          usercity,
                                          userpassword,
                                          userDeviceToken);
                                  if (userCredential != null) {
                                    Get.snackbar("Verification Email Sent",
                                        "Please check your email",
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor:
                                            const Color(0xFFFF5722),
                                        colorText: Colors.white);
                                    FirebaseAuth.instance.signOut();
                                    Get.offAll(() => const SignScreen());
                                  }
                                }
                              },
                              child: "Sign Up"
                                  .text
                                  .color(getTheme.colorScheme.surface)
                                  .make(),
                            ).wh((Get.width - 10), (Get.height / 14)),
                          ),
                        ).pOnly(bottom: 10),
                        Row(
                          children: [
                            "Already have an account ?  "
                                .text
                                .size(12)
                                .color(getTheme.colorScheme.tertiaryFixed)
                                .make(),
                            GestureDetector(
                              onTap: () => Get.offAll(() => const SignScreen()),
                              child: "Sign In"
                                  .text
                                  .color(getTheme.colorScheme.onPrimary)
                                  .extraBold
                                  .make(),
                            )
                          ],
                        ).pOnly(left: 10),
                        (Get.height * 0.04).heightBox,
                        const Row(
                          children: [
                            Flexible(
                                child: Divider(
                              color: Colors.white,
                              thickness: 5,
                              indent: 20,
                              endIndent: 10,
                            )),
                            Text(
                              "Or SignUp with",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Flexible(
                                child: Divider(
                              color: Colors.white,
                              thickness: 5,
                              indent: 10,
                              endIndent: 20,
                            )),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.all(0),
                          padding: const EdgeInsets.all(0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: Get.width * 0.18,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                        Border.all(color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(50)),
                                child: IconButton(
                                    onPressed: () {
                                      _googleSignInController
                                          .SignInWithGoogle();
                                    },
                                    icon: Image.asset(
                                        "assets/images/google.png")),
                              ),
                              (Get.width * 0.03).widthBox,
                              Container(
                                width: Get.width * 0.18,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                        Border.all(color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(50)),
                                child: IconButton(
                                    onPressed: () {},
                                    icon: Image.asset("assets/images/FB.png")),
                              )
                            ],
                          ).pOnly(top: 10, bottom: 0),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }),
      );
    });
  }
}
