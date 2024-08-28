import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/controllers/GetUserDataController.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/models/user-model.dart';
import 'package:flutter_application_1/screens/auth-ui/SignScreen.dart';
import 'package:flutter_application_1/screens/auth-ui/wellcomeScreen.dart';
import 'package:flutter_application_1/screens/user-panel/BestSellScree.dart';
import 'package:flutter_application_1/screens/user-panel/FlashSaleScreen.dart';
import 'package:flutter_application_1/screens/user-panel/NewArrivalScreen.dart';
import 'package:flutter_application_1/screens/user-panel/OrdersScreen.dart';
import 'package:flutter_application_1/screens/user-panel/Profilescreen.dart';
import 'package:flutter_application_1/screens/user-panel/allCategoriesScreen.dart';
import 'package:flutter_application_1/screens/user-panel/allFlashSaleScreen.dart';
import 'package:flutter_application_1/screens/user-panel/allProductsScreen.dart';
import 'package:flutter_application_1/screens/user-panel/cartScreen.dart';
import 'package:flutter_application_1/screens/user-panel/storeScreen.dart';
import 'package:flutter_application_1/widgets/DialogLogoutWidget.dart';
import 'package:flutter_application_1/widgets/SearchWidget.dart';
import 'package:flutter_application_1/widgets/SettingSwitchHeading.dart';
import 'package:flutter_application_1/widgets/Settingsheadingwidget.dart';
import 'package:flutter_application_1/widgets/bannerWidget.dart';
import 'package:flutter_application_1/widgets/categoryWidget.dart';
import 'package:flutter_application_1/widgets/customDrawer.dart';
import 'package:flutter_application_1/widgets/flashSaleWidget.dart';
import 'package:flutter_application_1/widgets/productsSliderWidget.dart';

import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../models/order-model.dart';
import '../../widgets/headingWidget.dart';
import '../../widgets/headingWidgetCat.dart';
import '../../widgets/newArrivalWidget.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  void restartApp() {
    SystemNavigator.pop(); // This exits the app
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // bool isDark = Theme.of(context).da

    final currentTheme = Theme.of(context);
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .where('uId', isEqualTo: user!.uid)
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          print(snapshot);
          if (snapshot.hasError) {
            return Center(child: Text("Error"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: Get.height / 5,
              child: Center(
                child: CupertinoActivityIndicator(),
              ),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: "No Category Found".text.make(),
            );
          }

          if (snapshot.data != null) {
            final userData =
                snapshot.data!.docs[0].data() as Map<String, dynamic>;

            print(userData);

            UserModel userModel = UserModel(
                uId: userData['uId'],
                username: userData['username'],
                email: userData['email'],
                phone: userData['phone'],
                userImg: userData['userImg'],
                userDeviceToken: userData['userDeviceToken'],
                country: userData['country'],
                userAddress: userData['userAddress'],
                street: userData['street'],
                isAdmin: userData['isAdmin'],
                isActive: userData['isActive'],
                createdOn: userData['createdOn'],
                city: userData['city']);

            return Scaffold(
              appBar: AppBar(
                iconTheme:
                    IconThemeData(color: Colors.white),
                backgroundColor: currentTheme.colorScheme.secondary,
                title: Container(
                    child: "Account"
                        .text
                        .color(Colors.white)
                        .bold
                        .make()),
              ),
              // drawer: MyDrawer(),
              body: Container(
                color: currentTheme.colorScheme.secondary,
                child: Container(
                  color: currentTheme.colorScheme.secondary,
                  child: Column(
                    children: [
                      Container(
                        // decoration: BoxDecoration(
                        color: currentTheme.colorScheme.secondary,
                        //     image: DecorationImage(
                        //         alignment: Alignment.topRight,
                        //         image: AssetImage("assets/images/design.png"),
                        //         fit: BoxFit.cover)), //Upper widget
                        child: Container(
                          margin: EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                  backgroundColor:
                                      currentTheme.colorScheme.surface,
                                  radius: 30,
                                  child: userModel.userImg.isEmpty
                                      ? Text(userModel.username.substring(0, 1))
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: Image.network(
                                            userModel.userImg,
                                            fit: BoxFit.cover,
                                          )).wh(100, 100).p2()),
                              // Text(userModel.)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  userModel.username.text
                                      .textStyle(TextStyle(
                                          fontSize: 18, color: Colors.white))
                                      .make(),
                                  userModel.email.text
                                      .textStyle(TextStyle(
                                          fontSize: 9, color: Colors.white))
                                      .make()
                                ],
                              ).pOnly(left: 10),
                              IconButton(
                                onPressed: () {
                                  Get.to(() => ProfileScreen());
                                },
                                icon: Icon(
                                  Iconsax.edit,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      //banners
                      Expanded(
                        child: Container(
                          width: Get.width + 10,
                          decoration: BoxDecoration(
                            color: currentTheme.primaryColor,
                            // border: Border.all(
                            //   // color: currentTheme.cardColor, // Border color
                            //   width: 2,
                            // ),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30)),
                          ),
                          child: ListView(
                            physics: BouncingScrollPhysics(),
                            // mainAxisAlignment: MainAxisAlignment.start,
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            children: [
                              "Account Settings"
                                  .text
                                  .extraBold
                                  .xl
                                  .align(TextAlign.start)
                                  .make()
                                  .pOnly(top: 20, left: 20),
                              10.heightBox,
                              SettingHeading(
                                headingTitle: "My Cart",
                                headingSubtitle:
                                    "Add, remove products and move to checkout",
                                onTap: () {
                                  Get.to(()=>CartScreen());
                                },
                                icon: Iconsax.shopping_cart,
                              ).pOnly(top: 10),
                              SettingHeading(
                                headingTitle: "My Orders",
                                headingSubtitle:
                                    "In-progress and Completed Orders",
                                onTap: () {
                                  Get.to(() => OrderScreen());
                                },
                                icon: Iconsax.bag_tick,
                              ),
                              SettingHeading(
                                headingTitle: "My Coupons",
                                headingSubtitle:
                                    "List of all discounted Coupons",
                                onTap: () {},
                                icon: Iconsax.discount_shape,
                              ),
                              SettingHeading(
                                headingTitle: "Notifications",
                                headingSubtitle:
                                    "Set any kind of notification message",
                                onTap: () {},
                                icon: Iconsax.shop,
                              ),
                              SettingHeading(
                                headingTitle: "Account Privacy",
                                headingSubtitle:
                                    "Manage data usage and connected accounts",
                                onTap: () {},
                                icon: Iconsax.notification,
                              ),
                              SettingHeading(
                                headingTitle: "Help & Support",
                                headingSubtitle:
                                    "Chat with us on whatsapp",
                                onTap: () {
                                  askAnyQuestionOnWhatsapp();

                                },
                                icon: Iconsax.message,
                              ),
                              
                              "App Settings"
                                  .text
                                  .extraBold
                                  .xl
                                  .align(TextAlign.start)
                                  .make()
                                  .pOnly(top: 20, left: 20),
                              20.heightBox,
                              SettingHeadingSwitch(
                                  headingTitle: "Geolocation",
                                  headingSubtitle:
                                      "Set recommendations based on location",
                                  icon: Iconsax.location,
                                  onTap: (value) {},
                                  value: true),
                              SettingHeadingSwitch(
                                  headingTitle: "Safe Mode",
                                  headingSubtitle:
                                      "Search result is safe for all ages",
                                  icon: Iconsax.security_user,
                                  onTap: (value) {},
                                  value: true),
                              SettingHeadingSwitch(
                                  headingTitle: "Dark Mode",
                                  headingSubtitle: "Enjoy the dark mode",
                                  icon: Iconsax.moon,
                                  onTap: (value) {
                                    setState(() {
                                      isDarkMode = value;
                                    });
                                    // Here you can add logic to change the app theme
                                  },
                                  value: isDarkMode),
                              Padding(
                                padding: EdgeInsets.only(left: 20, right: 20),
                                child: Material(
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
                                                  currentTheme
                                                      .colorScheme.onPrimary),
                                          shape: WidgetStatePropertyAll(
                                              RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(10)))),
                                          overlayColor: WidgetStatePropertyAll(
                                              currentTheme
                                                  .colorScheme.primary)),
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return CustomDialog(
                                                  title: "Logout",
                                                  content: "Are you sure ?",
                                                  onCancel: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  onConfirm: () async {
                                                    Navigator.of(context).pop();
                                                    final FirebaseAuth _auth =
                                                        FirebaseAuth.instance;
                                                    GoogleSignIn googleSignIn =
                                                        GoogleSignIn();

                                                    await _auth.signOut();

                                                    await googleSignIn
                                                        .signOut();

                                                    Get.offAll(
                                                        () => SignScreen());
                                                  });
                                            });
                                      },
                                      child: "Logout"
                                          .text
                                          .color(
                                              currentTheme.colorScheme.surface)
                                          .make(),
                                    ).h(Get.height / 14),
                                  ),
                                ).pOnly(bottom: 30),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }
          return Container();
        });
  }
}
Future<void> askAnyQuestionOnWhatsapp() async {
  final number = '+923112709619';
  final message = "Hello Deebugs \n I want to know about ";

  final url = 'https://wa.me/$number?text=${Uri.encodeComponent(message)}';
  try {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw "Could not launch $url";
    }
  } catch (e) {
    print("Error: $e");
  }
}