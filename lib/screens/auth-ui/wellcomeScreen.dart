import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/googleSignInController.dart';
import 'package:flutter_application_1/screens/auth-ui/SignScreen.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';

class WellcomeScreen extends StatefulWidget {
  const WellcomeScreen({super.key});

  @override
  State<WellcomeScreen> createState() => _WellcomeScreenState();
}

class _WellcomeScreenState extends State<WellcomeScreen> {
  String google = "";
  String email = "";

  @override
  void initState() {
    super.initState();
    _initializeAssets();
  }

  Future<void> _initializeAssets() async {
    google = 'https://i.imgur.com/3ulztsg.png';
    email = 'https://i.imgur.com/fOzMfIT.png';
    setState(() {}); // Update the UI after loading assets
  }

  Future<Image> _loadImage(String url) {
    return Future.delayed(const Duration(seconds: 1), () => Image.network(url));
  }
  final GoogleSignInController _googleSignInController = Get.put(GoogleSignInController()); 

  @override
  Widget build(BuildContext context) {
    final getTheme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: Get.height * 0.3,
              width: Get.width,
              child: Lottie.asset("assets/images/loadingCart.json"),
            ).p12(),
            Expanded(
              child: VxArc(
                height: 30.0,
                arcType: VxArcType.convey,
                edge: VxEdge.top,
                child: Container(
                  color: getTheme.cardColor,
                  width: Get.width,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: "WellCome".text.xl3.align(TextAlign.center).bold.color(getTheme.colorScheme.onPrimary).make(),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                              _googleSignInController.SignInWithGoogle();// Handle Google sign-in action
                              },
                              borderRadius: BorderRadius.circular(200.0),
                              highlightColor: Colors.blue.shade100.withOpacity(0.5), // Color when the button is pressed
                              splashColor: Colors.blue.shade200.withOpacity(0.5), // Splash color
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50, // Background color
                                  borderRadius: BorderRadius.circular(200.0),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(200.0),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      FutureBuilder<Image>(
                                        future: _loadImage(google),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return const CircularProgressIndicator();
                                          } else if (snapshot.hasError) {
                                            return const Icon(Icons.error); // Handle error case
                                          } else {
                                            return snapshot.data!;
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10), // Spacing between the buttons
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Get.off(()=>const SignScreen());
                              },
                              borderRadius: BorderRadius.circular(200.0),
                              highlightColor: Colors.blue.shade100.withOpacity(0.5), // Color when the button is pressed
                              splashColor: Colors.blue.shade200.withOpacity(0.5), // Splash color
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50, // Background color
                                  borderRadius: BorderRadius.circular(200.0),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(200.0),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      FutureBuilder<Image>(
                                        future: _loadImage(email),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return const CircularProgressIndicator();
                                          } else if (snapshot.hasError) {
                                            return const Icon(Icons.error); // Handle error case
                                          } else {
                                            return snapshot.data!;
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ).py64(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
