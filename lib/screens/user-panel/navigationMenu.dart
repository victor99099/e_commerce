import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/user-panel/SettingScreen.dart';
import 'package:flutter_application_1/screens/user-panel/WishListScreen.dart';
import 'package:flutter_application_1/screens/user-panel/mainScreen.dart';
import 'package:flutter_application_1/screens/user-panel/storeScreen.dart';
import 'package:flutter_application_1/services/fcmService.dart';
import 'package:flutter_application_1/services/notification_service.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  NotificationService notificationService = NotificationService();
  @override
  void initState(){
    super.initState();
    notificationService.requestNotificationPermission();
    notificationService.getDeviceToken();
    notificationService.firebaseInit(context);
    notificationService.setupInteractMessage(context);
    FcmService.firebaseInit(); 
  }
  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);
    final controller = Get.put(NavigationController());
    return Scaffold(
      bottomNavigationBar: Obx(
        ()=> NavigationBar(
          indicatorColor: currentTheme.colorScheme.primary,
          height: Get.height/12,
          elevation: 0,
          selectedIndex : controller.selectedIndex.value,
          onDestinationSelected: (index)=> controller.selectedIndex.value = index,
          destinations: const [
            NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
            NavigationDestination(icon: Icon(Iconsax.shop), label: 'Store'),
            NavigationDestination(icon: Icon(Iconsax.heart), label: 'WishList'),
            NavigationDestination(icon: Icon(Iconsax.user), label: 'Profile'),
          ],
        )
      ),
      body: Obx( () => controller.screens[controller.selectedIndex.value])
    );
  }
}

class NavigationController extends GetxController{
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const Mainscreen(),
    const StoreScreen(),
    const WishlistScreen(),
    const SettingScreen()
  ];
}