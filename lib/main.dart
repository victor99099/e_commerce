import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/auth-ui/SignScreen.dart';
import 'package:flutter_application_1/screens/auth-ui/wellcomeScreen.dart';
import 'package:flutter_application_1/screens/user-panel/navigationMenu.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:velocity_x/velocity_x.dart';
import 'firebase_options.dart';
import 'screens/auth-ui/splashScreen.dart';
import 'screens/user-panel/mainScreen.dart';
import 'utils/app-constant.dart';


@pragma('vm:entry-point')

Future<void> _firebaseBackgroundHandle(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandle);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: MyTheme.lightTheme(context),
      darkTheme: MyTheme.darkTheme(context),
      title: 'Flutter Demo',

      home: Splashscreen(),
      builder: EasyLoading.init()
    );
  }
}

