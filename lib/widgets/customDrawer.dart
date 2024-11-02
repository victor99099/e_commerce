import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/auth-ui/wellcomeScreen.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:velocity_x/velocity_x.dart';


class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(top: Get.height/25),
      child: Drawer(
        backgroundColor: currentTheme.cardColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0)
          )
        ),
        child: Wrap(
          runSpacing: 10,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0,
              vertical: 20.0),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: "Abdul Wahab".text.make(),
                subtitle: "Version 1.0.1".text.make(),
                leading: CircleAvatar(
                  radius: 22.0,
                  backgroundColor: currentTheme.colorScheme.secondary,
                  child: "W".text.color(Colors.white).bold.make(),
                ),
              ),
            ),
            const Divider(
              indent: 10,
              endIndent: 10,
              thickness: 2,
              color: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0,
              vertical: 5.0),
              child: ListTile(
                iconColor: Colors.white,
                textColor: Colors.white,
                titleAlignment: ListTileTitleAlignment.center,
                title: "Home".text.xl2.bold.make(),
                leading: const Icon(CupertinoIcons.home),
                trailing: const Icon(CupertinoIcons.arrow_right_square_fill,size: 30).pOnly(top: 4,right: 10),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0,
              vertical: 5.0),
              child: ListTile(
                iconColor: Colors.white,
                textColor: Colors.white,
                titleAlignment: ListTileTitleAlignment.center,
                title: "Products".text.xl2.bold.make(),
                leading: const Icon(CupertinoIcons.shopping_cart),
                trailing: const Icon(CupertinoIcons.arrow_right_square_fill,size: 30).pOnly(top: 4,right: 10),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0,
              vertical: 5.0),
              child: ListTile(
                iconColor: Colors.white,
                textColor: Colors.white,
                titleAlignment: ListTileTitleAlignment.center,
                title: "Orders".text.xl2.bold.make(),
                leading: const Icon(CupertinoIcons.bag),
                trailing: const Icon(CupertinoIcons.arrow_right_square_fill,size: 30).pOnly(top: 4,right: 10),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0,
              vertical: 5.0),
              child: ListTile(
                iconColor: Colors.white,
                textColor: Colors.white,
                titleAlignment: ListTileTitleAlignment.center,
                title: "Contact".text.xl2.bold.make(),
                leading: const Icon(CupertinoIcons.phone),
                trailing: const Icon(CupertinoIcons.arrow_right_square_fill,size: 30).pOnly(top: 4,right: 10),
              ),
            ),
            Padding(
    
              padding: const EdgeInsets.symmetric(horizontal: 25.0,
              vertical: 5.0),
              child: ListTile(
              onTap: () async {
                final FirebaseAuth auth = FirebaseAuth.instance;
                GoogleSignIn googleSignIn = GoogleSignIn();
              
                await auth.signOut();
              
                await googleSignIn.signOut();

                Get.offAll(()=>const WellcomeScreen());

              },
                iconColor: Colors.white,
                textColor: Colors.white,
                titleAlignment: ListTileTitleAlignment.center,
                title: "Log Out".text.xl2.bold.make(),
                leading: const Icon(Icons.logout),
                trailing: const Icon(CupertinoIcons.arrow_right_square_fill,size: 30).pOnly(top: 4,right: 10),
              ),
            ),
          ],
        ),
      ),  
    );
  }
}