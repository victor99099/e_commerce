import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/user-panel/cartScreen.dart';
import 'package:flutter_application_1/widgets/SingleCatFlashSaleWidget.dart';
import 'package:flutter_application_1/widgets/singleCatBestSellWidget.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../controllers/CartItemsController.dart';
import '../../widgets/SingleCatNewArrivalWidget.dart';
import 'SearchScreen.dart';

class SingleCatScreen extends StatefulWidget {
  String categoryTitle;
  String categoryId;
  SingleCatScreen(
      {super.key, required this.categoryId, required this.categoryTitle});

  // var categoryId = this.categoryId;

  @override
  State<SingleCatScreen> createState() => _SingleCatScreenState();
}

class _SingleCatScreenState extends State<SingleCatScreen>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
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
              child: const Icon(Iconsax.search_normal).pOnly(right: 10)),
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
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: currentTheme.colorScheme.secondary,
        title: widget.categoryTitle.text
            .color(Colors.white)
            .bold
            .make(),
        bottom: TabBar(
          overlayColor:
              WidgetStatePropertyAll(currentTheme.colorScheme.surface),
          controller: tabController,
          // isScrollable: true,
          tabAlignment: TabAlignment.fill,
          padding: const EdgeInsets.all(0),
          dividerColor: currentTheme.colorScheme.primary,
          indicatorColor: currentTheme.colorScheme.onPrimary,
          labelColor: currentTheme.colorScheme.tertiary,
          unselectedLabelColor: currentTheme.colorScheme.surface,
          tabs: const [
            Tab(child: Text('Flash Sale')),
            Tab(child: Text('New Arrivals')),
            Tab(child: Text('Best Selling')),
          ],
        ),
      ),
      body: Container(
        color: currentTheme.primaryColor,
        child: TabBarView(
          controller: tabController,
          children: [
            SingleCategoryWidgetFlashSale(
                categoryId: widget.categoryId,
                categoryTitle: widget.categoryTitle),
            SingleCategoryWidgetNewArrival(
                categoryId: widget.categoryId, categoryTitle: widget.categoryId),
            SingleCategoryWidgetBestSell(
                categoryId: widget.categoryId, categoryTitle: widget.categoryId),
          ],
        ),
      ),
    );
  }
}
