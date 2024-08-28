import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/user-panel/cartScreen.dart';
import 'package:flutter_application_1/widgets/SingleCatFlashSaleWidget.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../controllers/CartItemsController.dart';
import 'SearchScreen.dart';

class FlashSaleScreen extends StatefulWidget {
  const FlashSaleScreen({super.key});

  @override
  State<FlashSaleScreen> createState() => _FlashSaleScreenState();
}

class _FlashSaleScreenState extends State<FlashSaleScreen>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FlashSaleController cartItemsController = Get.put(FlashSaleController());
    final currentTheme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          InkWell(
              onTap: () => Get.to(() => SearchScreen()),
              child: Icon(Iconsax.search_normal).pOnly(right: 10)),
          InkWell(
            onTap: () => Get.to(() => CartScreen()),
            child: StreamBuilder<int>(
              stream: cartItemsController
                  .getCartItemsCount(), // Fetch the cart item count
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(CupertinoIcons.cart),
                  ); // Display an empty cart icon or a loading indicator
                } else if (snapshot.hasError) {
                  return Container(
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(CupertinoIcons.cart),
                  ); // Handle error case if necessary
                } else {
                  return Container(
                    height: 40,
                    width: 40,
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(CupertinoIcons
                        .cart), // Show the cart icon with the item count
                  )
                      .badge(
                          color: currentTheme.colorScheme.surface,
                          textStyle: TextStyle(
                              color: currentTheme.colorScheme.onPrimary,
                              fontSize: 10),
                          count: snapshot.data ?? 0,
                          position: VxBadgePosition.rightTop)
                      .pOnly(right: 10);
                }
              },
            ),
          )
        ],
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: currentTheme.colorScheme.secondary,
        title: "Flash Sale"
            .text
            .color(Colors.white)
            .bold
            .make(),
        bottom: TabBar(
          overlayColor:
              WidgetStatePropertyAll(currentTheme.colorScheme.surface),
          controller: tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          padding: EdgeInsets.all(0),
          dividerColor: currentTheme.colorScheme.primary,
          indicatorColor: currentTheme.colorScheme.onPrimary,
          labelColor: currentTheme.colorScheme.tertiary,
          unselectedLabelColor: currentTheme.colorScheme.surface,
          tabs: [
            Tab(child: Text('Phones')),
            Tab(child: Text('Tablets')),
            Tab(child: Text('Headphones')),
            Tab(child: Text('Television')),
          ],
        ),
      ),
      body: Container(
        color: currentTheme.primaryColor,
        child: TabBarView(
          controller: tabController,
          children: [
            SingleCategoryWidgetFlashSale(
                categoryId: 'CAlbFE9mNh5FnV4o1mS1', categoryTitle: 'Phones'),
            SingleCategoryWidgetFlashSale(
                categoryId: 'D1Ly8LBIk8v5RllSV2Ry', categoryTitle: 'Tablets'),
            SingleCategoryWidgetFlashSale(
                categoryId: 'wYWKwkX8B8FkSO787Lr0', categoryTitle: 'Headphones'),
            SingleCategoryWidgetFlashSale(
                categoryId: 'JZUo4g5nkfsHB18PwPGi', categoryTitle: 'Televisions'),
          ],
        ),
      ),
    );
  }
}
