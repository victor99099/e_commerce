import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
import 'package:flutter_application_1/screens/user-panel/PersonalInfoScreen.dart';
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
import 'package:image_picker/image_picker.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../widgets/headingWidget.dart';
import '../../widgets/headingWidgetCat.dart';
import '../../widgets/newArrivalWidget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<String> GetUrl(XFile image) async {
    try {
      final ref = FirebaseStorage.instance.ref('userImages/').child(image.name);
      await ref.putFile(File(image.path));
      final url = ref.getDownloadURL();
      return url;
    } catch (e) {
      print("Image upload error : $e");
      return "";
    }
  }

  void restartApp() {
    SystemNavigator.pop(); // This exits the app
  }

  @override
  Widget build(BuildContext context) {
    RxBool isLoading = false.obs;
    User? user = FirebaseAuth.instance.currentUser;

    // bool isDark = Theme.of(context).da

    final currentTheme = Theme.of(context);
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('uId', isEqualTo: user!.uid)
            .snapshots(),
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
              child: "No Data Found".text.make(),
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
              backgroundColor: currentTheme.primaryColor,
              appBar: AppBar(
                iconTheme:
                    IconThemeData(color: currentTheme.colorScheme.tertiary),
                backgroundColor: Colors.transparent,
                title: Container(
                    child: "Profile"
                        .text
                        .color(currentTheme.colorScheme.tertiary)
                        .bold
                        .make()),
              ),
              body: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: Get.height / 5.8,
                      width: Get.width,
                      child: Center(
                        child: Column(
                          children: [
                            Obx(() => CircleAvatar(
                                  backgroundColor:
                                      const Color.fromARGB(255, 233, 230, 230),
                                  radius: 30,
                                  child: isLoading.value
                                      ? Center(
                                          child: CupertinoActivityIndicator())
                                      : userModel.userImg.isEmpty
                                          ? Text(
                                              userModel.username.substring(0, 1))
                                          : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: Image.network(
                                                userModel.userImg,
                                                fit: BoxFit.cover,
                                              )).wh(100,100).p2(),
                                )),
                            TextButton(
                                style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(Colors.transparent)
                                ),
                                onPressed: () async {
                                  try {
                                    final image = await ImagePicker().pickImage(
                                        source: ImageSource.gallery,
                                        imageQuality: 70,
                                        maxHeight: 520,
                                        maxWidth: 520);
                                    if (image != null) {
                                      isLoading.value = true;
                                      final imageUrl = await GetUrl(image);
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(user!.uid)
                                          .update({'userImg': imageUrl});
                                      userModel.userImg = imageUrl;
                                      isLoading.value = false;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                          'Profile picture updated',
                                          style: TextStyle(
                                              color: currentTheme
                                                  .colorScheme.surface),
                                        ),
                                        backgroundColor:
                                            currentTheme.colorScheme.onPrimary,
                                      ));
                                    } else {
                                      print("Error at last");
                                    }
                                  } catch (e) {
                                    print("error image picker: $e");
                                  }
                                },
                                child: Text(
                                  "Change Profile Picture",
                                  style: TextStyle(
                                    backgroundColor: Colors.transparent,
                                    fontSize: 13,
                                      color:
                                          currentTheme.colorScheme.tertiaryFixed),
                                )).color(Colors.transparent),
                          ],
                        ).pOnly(top:20),
                      ),
                    ),
                    Divider(
                      endIndent: 20,
                      indent: 20,
                      color: currentTheme.colorScheme.tertiaryFixed,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          "Account Information".text.bold.xl.make(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              "Email".text.color(currentTheme.colorScheme.tertiaryFixed).make(),
                              userModel.email.text.textStyle(TextStyle(fontSize: 10)).make().pOnly(left: 15),
                              IconButton(
                                iconSize: 18,
                                onPressed: () {}, 
                                icon: Icon(Iconsax.edit,color: currentTheme.colorScheme.tertiaryFixed,) 
                              ),
                            ],
                          ).pOnly(top: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              "User Id".text.color(currentTheme.colorScheme.tertiaryFixed).make(),
                              userModel.uId.text.overflow(TextOverflow.ellipsis).textStyle(TextStyle(fontSize: 10)).make().pOnly(left: 20).w(Get.width*0.618),
                              IconButton(
                                iconSize: 18,
                                onPressed: () {}, 
                                icon: Icon(Iconsax.copy,color: currentTheme.colorScheme.tertiaryFixed,) 
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      endIndent: 20,
                      indent: 20,
                      color: currentTheme.colorScheme.tertiaryFixed,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              "Personal Information".text.bold.xl.make(),
                              IconButton(onPressed: (){Get.to(()=>UpdateUserInfoScreen(userModel: userModel,));}, icon: Icon(Iconsax.edit,color: currentTheme.colorScheme.tertiaryFixed,))
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              "Name".text.color(currentTheme.colorScheme.tertiaryFixed).make(),
                              userModel.username.text.textStyle(TextStyle(fontSize: 10)).make().pOnly(left: 62),
                              
                            ],
                          ).pOnly(top: 25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              "Phone no".text.color(currentTheme.colorScheme.tertiaryFixed).make(),
                              userModel.phone.text.textStyle(TextStyle(fontSize: 10)).make().pOnly(left: 38),
                            ],
                          ).pOnly(top: 25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              "City".text.color(currentTheme.colorScheme.tertiaryFixed).make(),
                              userModel.city.text.textStyle(TextStyle(fontSize: 10)).make().pOnly(left: 77),
                            ],
                          ).pOnly(top: 25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              "Street".text.color(currentTheme.colorScheme.tertiaryFixed).make(),
                              userModel.street.text.textStyle(TextStyle(fontSize: 10)).make().pOnly(left: 63),
                            ],
                          ).pOnly(top: 25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              "Address".text.color(currentTheme.colorScheme.tertiaryFixed).make(),
                              userModel.userAddress.text.overflow(TextOverflow.fade).textStyle(TextStyle(fontSize: 10)).make().pOnly(left: 47).w(Get.width*0.7),
                            ],
                          ).pOnly(top: 25),
                          
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }
          return Container();
        });
  }
}
