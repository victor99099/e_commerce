import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/controllers/CartItemsController.dart';
import 'package:flutter_application_1/screens/user-panel/BestSellScree.dart';
import 'package:flutter_application_1/screens/user-panel/FlashSaleScreen.dart';
import 'package:flutter_application_1/screens/user-panel/NewArrivalScreen.dart';
import 'package:flutter_application_1/screens/user-panel/SearchScreen.dart';
import 'package:flutter_application_1/screens/user-panel/allCategoriesScreen.dart';
import 'package:flutter_application_1/screens/user-panel/cartScreen.dart';
import 'package:flutter_application_1/screens/user-panel/storeScreen.dart';
import 'package:flutter_application_1/widgets/SearchWidget.dart';
import 'package:flutter_application_1/widgets/bannerWidget.dart';
import 'package:flutter_application_1/widgets/categoryWidget.dart';
import 'package:flutter_application_1/widgets/flashSaleWidget.dart';
import 'package:flutter_application_1/widgets/productsSliderWidget.dart';

import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../widgets/headingWidget.dart';
import '../../widgets/headingWidgetCat.dart';
import '../../widgets/newArrivalWidget.dart';

class Mainscreen extends StatelessWidget {
  const Mainscreen({super.key});

  void restartApp() {
    SystemNavigator.pop(); // This exits the app
  }

  @override
  Widget build(BuildContext context) {
    FlashSaleController cartItemsController = Get.put(FlashSaleController());
    final currentTheme = Theme.of(context);
    return Scaffold(
      backgroundColor: currentTheme.colorScheme.secondary,
      appBar: AppBar(
        elevation: 0,
        actions: [
          InkWell(
            onTap: () => Get.to(() => SearchScreen()),
            child: const Icon(Iconsax.search_normal).pOnly(right: 10)
          ),
          InkWell(
            onTap: () => Get.to(() => const CartScreen()),
            child: StreamBuilder<int>(
              stream: cartItemsController
                  .getCartItemsCount(), // Fetch the cart item count
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(CupertinoIcons.cart),
                  ); // Display an empty cart icon or a loading indicator
                } else if (snapshot.hasError) {
                  return Container(
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(CupertinoIcons.cart),
                  ); // Handle error case if necessary
                } else {
                  return Container(
                    height: 40,
                    width: 40,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(CupertinoIcons
                        .cart), // Show the cart icon with the item count
                  )
                      .badge(
                          color: currentTheme.colorScheme.surface,
                          textStyle: TextStyle(color: currentTheme.colorScheme.onPrimary,fontSize: 10),
                          count: snapshot.data ?? 0,
                          position: VxBadgePosition.rightTop)
                      .pOnly(right: 10);
                }
              },
            ),
          )
        ],
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: currentTheme.colorScheme.secondary,
        foregroundColor: currentTheme.colorScheme.secondary,
        surfaceTintColor: currentTheme.colorScheme.secondary,
        title: Container(
            child: "Shopify Clone"
                .text
                .color(Colors.white)
                .bold
                .make()),
      ),
      // drawer: MyDrawer(),
      body: Container(
        // color: currentTheme.colorScheme.secondary,
        child: SingleChildScrollView(
          physics: const PageScrollPhysics(),
          child: Container(
            // color: currentTheme.colorScheme.secondary,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: currentTheme.colorScheme.secondary,
                      image: const DecorationImage(
                          alignment: Alignment.topRight,
                          image: AssetImage("assets/images/design.png"),
                          fit: BoxFit.contain)), //Upper widget
                  child: Column(
                    children: [
                      SearchWidget(),
                      //     SizedBox(
                      //   height: Get.height / 90.0,
                      // ),
                      HeadingWidgetCat(
                        headingTitle: "Popular Categories",
                        headingSubtitle: "According to your Budget",
                        buttonText: "See more >",
                        onTap: () {
                          Get.to(() => const AllCategoriesScreen());
                        },
                      ),
                      const Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: CategoryWidget()),
                    ],
                  ),
                ),

                //banners
                Container(
                  width: Get.width + 10,
                  decoration: BoxDecoration(
                    color: currentTheme.primaryColor,
                    border: Border.all(
                      color: Colors.transparent, // Border color
                      width: 2,
                    ),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                  ),
                  child: Column(
                    children: [
                      20.heightBox,
                      Container(child: const BannerWidget()),
                      HeadingWidget(
                        headingTitle: "New Arrivals",
                        headingSubtitle: "Popular these days",
                        buttonText: "See more >",
                        onTap: () {
                          Get.to(() => const NewArrivalScreen());
                        },
                      ),
                      const NewArrivalsWidget(),
                      HeadingWidget(
                        headingTitle: "Flash Sale",
                        headingSubtitle: "Limited time offers",
                        buttonText: "See more >",
                        onTap: () {
                          Get.to(() => const FlashSaleScreen());
                        },
                      ),
                      FlashAndSaleWidget(type: 'isSale'),
                      HeadingWidget(
                        headingTitle: "Best Selling",
                        headingSubtitle: "Hot Trendings",
                        buttonText: "See more >",
                        onTap: () {
                          Get.to(() => const BestSellScreen());
                        },
                      ),
                      FlashAndSaleWidget(
                        type: 'isBest',
                      ),
                      HeadingWidget(
                        headingTitle: "All Products",
                        headingSubtitle: "Best of ours",
                        buttonText: "See more >",
                        onTap: () {
                          Get.to(() => const StoreScreen());
                        },
                      ),
                      const Padding(
                          padding: EdgeInsets.all(10),
                          child: ProductsSliderWidget()),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
