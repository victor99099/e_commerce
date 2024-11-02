import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/GetUserDataController.dart';
import 'package:flutter_application_1/controllers/SignINController.dart';
import 'package:flutter_application_1/screens/auth-ui/forgetPasswordScreen.dart';
import 'package:flutter_application_1/screens/user-panel/navigationMenu.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../controllers/googleSignInController.dart';
import '../admin-panel/admin-main-screen.dart';
import 'SignUpScreen.dart';

class SignScreen extends StatefulWidget {
  const SignScreen({super.key});

  @override
  State<SignScreen> createState() => _SignScreenState();
}

class _SignScreenState extends State<SignScreen> {
  final GoogleSignInController _googleSignInController =
      Get.put(GoogleSignInController());
  final GetUserDataController getUserDataController =
      Get.put(GetUserDataController());
  final SignInController signInController = Get.put(SignInController());
  TextEditingController useremail = TextEditingController();
  TextEditingController userpassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final getTheme = Theme.of(context);
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return Scaffold(
        backgroundColor: getTheme.colorScheme.secondary,
        // appBar: AppBar(
        //   backgroundColor: Colors.transparent,
        //   foregroundColor: Colors.transparent,
        //   elevation: 0,
        // ),
        body: Column(
          children: [
            isKeyboardVisible
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(0),
                        height: Get.height * 0.15,
                        width: Get.width * 0.2,
                        child: Lottie.asset(
                            "assets/images/loadingCart.json",
                            fit: BoxFit.cover),
                      ).pOnly(left: 0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                              child: "WellCome"
                                  .text
                                  .color(Colors.white)
                                  .xl3
                                  .make()),
                          SizedBox(
                              width: Get.width * 0.6,
                              child:
                                  "Discover Limitless Choices and Unmatched Convernience ."
                                      .text
                                      .color(Colors.white)
                                      .textStyle(const TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 10))
                                      .make()),
                        ],
                      ).pOnly(left: 5, right: 27, top: 20),
                    ],
                  ).pOnly(bottom: 5,top: Get.height*0.04)
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(0),
                        height: Get.height * 0.15,
                        width: Get.width * 0.2,
                        child: Lottie.asset(
                            "assets/images/loadingCart.json",
                            fit: BoxFit.cover),
                      ).pOnly(left: 0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                              child: "WellCome"
                                  .text
                                  .color(Colors.white)
                                  .xl3
                                  .make()),
                          SizedBox(
                              width: Get.width * 0.6,
                              child:
                                  "Discover Limitless Choices and Unmatched Convernience ."
                                      .text
                                      .color(Colors.white)
                                      .textStyle(const TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 10))
                                      .make()),
                        ],
                      ).pOnly(left: 5, right: 27, top: 20),
                    ],
                  ).pOnly(bottom: 10,top: Get.height*0.07),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    height: constraints.maxHeight,
                    width: Get.width,
                    decoration: BoxDecoration(
                        color: getTheme.cardColor,
                        // border: Border.,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
                    child: SingleChildScrollView(
                      physics: const PageScrollPhysics(),
                      child: Padding(
                        padding: Vx.m16,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            (Get.height * 1 / 20).heightBox,
                            TextFormField(
                              controller: useremail,
                              cursorColor: getTheme.colorScheme.onPrimary,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(color: getTheme.colorScheme.tertiaryFixed),
                                filled: true, // Enable filling
                                fillColor: getTheme.colorScheme.surface,
                                hintText: "abc@gmail.com",
                                prefixIcon: Icon(Iconsax.direct,
                                    color:
                                        getTheme.colorScheme.onPrimary),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color:
                                          getTheme.colorScheme.surface),
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
                                contentPadding: const EdgeInsets.only(
                                    top: 2.0, left: 8.0),
                              ),
                            ).pOnly(bottom: 10),
                            Obx(
                              () => TextFormField(
                                controller: userpassword,
                                cursorColor:
                                    getTheme.colorScheme.onPrimary,
                                keyboardType:
                                    TextInputType.visiblePassword,
                                obscureText: signInController
                                    .isPasswordVisible.value,
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(color: getTheme.colorScheme.tertiaryFixed),
                                  filled: true, // Enable filling
                                  fillColor: getTheme.colorScheme.surface,
                                  hintText: "Password",
                                  suffixIcon: GestureDetector(
                                      onTap: () {
                                        signInController.isPasswordVisible
                                            .toggle();
                                      },
                                      child: signInController
                                              .isPasswordVisible.value
                                          ? Icon(Icons.visibility_off,
                                              color: getTheme
                                                  .colorScheme.onPrimary)
                                          : Icon(Icons.visibility,
                                              color: getTheme.colorScheme
                                                  .onPrimary)),
                                  prefixIcon: Icon(Iconsax.password_check,
                                      color:
                                          getTheme.colorScheme.onPrimary),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color:
                                            getTheme.colorScheme.surface),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: getTheme.colorScheme
                                            .surface), // Default border color
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: getTheme.colorScheme
                                            .onPrimary), // Border color when focused
                                  ),
                                  contentPadding: const EdgeInsets.only(
                                      top: 2.0, left: 8.0),
                                ),
                              ).pOnly(bottom: 10),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.to(
                                    () => const ForgetPasswordScreen());
                              },
                              child: Container(
                                margin: const EdgeInsets.all(0),
                                alignment: Alignment.centerRight,
                                child: "Forgot Password ? "
                                    .text
                                    .bold
                                    .color(getTheme.colorScheme.onPrimary)
                                    .make(),
                              ).pOnly(right: 10, top: 10, bottom: 0),
                            ),
                            (Get.height * 1 / 20).heightBox,
                            Material(
                              color: Colors.transparent,
                              child: Container(
                                color: Colors.transparent,
                                child: TextButton(
                                  style: ButtonStyle(
                                      foregroundColor:
                                          const WidgetStatePropertyAll(
                                              Colors.transparent),
                                      backgroundColor:
                                          WidgetStateProperty.all(getTheme
                                              .colorScheme.onPrimary),
                                      shape: const WidgetStatePropertyAll(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.all(
                                                      Radius.circular(
                                                          10)))),
                                      overlayColor: WidgetStatePropertyAll(
                                          getTheme.colorScheme.primary)),
                                  onPressed: () async {
                                    String email = useremail.text.trim();
                                    String password =
                                        userpassword.text.trim();
                                            
                                    if (email.isEmpty ||
                                        password.isEmpty) {
                                      Get.snackbar("Error",
                                          "Please enter all details!",
                                          snackPosition:
                                              SnackPosition.BOTTOM,
                                          backgroundColor:
                                              const Color(0xFFFF5722),
                                          colorText: Colors.white);
                                    } else {
                                      try {
                                        UserCredential? userCredential =
                                            await signInController
                                                .signInMethod(
                                                    email, password);
                                        var userData =
                                            await getUserDataController
                                                .getUserData(
                                                    userCredential!
                                                        .user!.uid);
                                        if (userCredential
                                            .user!.emailVerified) {
                                          Get.snackbar("Success",
                                              "login successfully!",
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              backgroundColor:
                                                  const Color(0xFFFF5722),
                                              colorText: Colors.white);
                                            
                                          if (userData[0]['isAdmin'] ==
                                              true) {
                                            Get.offAll(
                                                const AdminScreen());
                                          } else {
                                            Get.offAll(() =>
                                                const NavigationMenu());
                                          }
                                        } else {
                                          Get.snackbar("Error",
                                              "Please verify your email, check your inbox",
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              backgroundColor:
                                                  const Color(0xFFFF5722),
                                              colorText: Colors.white);
                                        }
                                      } catch (e) {
                                        // Get.snackbar("Error",
                                        //       "Incorrect Password!",
                                        //       snackPosition:
                                        //           SnackPosition.BOTTOM,
                                        //       backgroundColor:
                                        //           Color(0xFFFF5722),
                                        //       colorText: Colors.white);
                                      }
                                    }
                                  },
                                  child: "Sign In"
                                      .text
                                      .color(getTheme.colorScheme.surface)
                                      .make(),
                                ).wh((Get.width - 10), (Get.height / 14)),
                              ),
                            ).pOnly(bottom: 10),
                            Material(
                              color: Colors.transparent,
                              child: Container(
                                color: Colors.transparent,
                                child: TextButton(
                                  style: ButtonStyle(
                                      foregroundColor:
                                          const WidgetStatePropertyAll(
                                              Colors.transparent),
                                      backgroundColor:
                                          WidgetStateProperty.all(getTheme
                                              .colorScheme.surface),
                                      shape: const WidgetStatePropertyAll(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.all(
                                                      Radius.circular(
                                                          10)))),
                                      overlayColor: WidgetStatePropertyAll(
                                          getTheme.colorScheme.primary)),
                                  onPressed: () =>
                                      Get.to(() => const SignUpScreen()),
                                  child: "Create an Account"
                                      .text
                                      .color(
                                          getTheme.colorScheme.onPrimary)
                                      .make(),
                                ).wh((Get.width - 10), (Get.height / 14)),
                              ),
                            ).pOnly(bottom: 30),
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
                                  "Or Sign-in with",
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.only(bottom: 60),
                                  width: Get.width * 0.18,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.transparent),
                                      borderRadius:
                                          BorderRadius.circular(50)),
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
                                  margin:
                                      const EdgeInsets.only(bottom: 60),
                                  width: Get.width * 0.18,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.transparent),
                                      borderRadius:
                                          BorderRadius.circular(50)),
                                  child: IconButton(
                                      onPressed: () {},
                                      icon: Image.asset(
                                          "assets/images/FB.png")),
                                )
                              ],
                            ).pOnly(top: 20)
                          ],
                        ),
                      ),
                    ),
                  );
                }
              ),
            ),
          ],
        ),
      );
    });
  }
}
