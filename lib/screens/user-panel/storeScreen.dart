import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/user-panel/SearchScreen.dart';
import 'package:flutter_application_1/widgets/brandWidget.dart';
import 'package:flutter_application_1/widgets/singleCategoryWidget.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../controllers/CartItemsController.dart';
import '../../widgets/SearchWidget.dart';
import '../../widgets/customDrawer.dart';
import 'cartScreen.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen>
    with TickerProviderStateMixin {
  // SearchController searchController = Get.put(SearchController());
  RxBool isSearchActive = false.obs;
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

    // Creating the TabBar separately to access its height
    final tabBar = TabBar(
      controller: tabController,
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      padding: EdgeInsets.all(0),
      dividerColor: currentTheme.colorScheme.primary,
      indicatorColor: currentTheme.colorScheme.onPrimary,
      labelColor: currentTheme.colorScheme.onPrimary,
      unselectedLabelColor: Colors.grey,
      overlayColor: WidgetStatePropertyAll(currentTheme.primaryColor),
      
      tabs: [
        Tab(child: Text('Phones')),
        Tab(child: Text('Tablets')),
        Tab(child: Text('Headphones')),
        Tab(child: Text('Television')),
      ],
    );

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
                          textStyle: TextStyle(
                              color: currentTheme.colorScheme.surface,
                              fontSize: 10),
                          count: snapshot.data ?? 0,
                          position: VxBadgePosition.rightTop,
                          color: currentTheme.colorScheme.onPrimary)
                      .pOnly(right: 10);
                }
              },
            ),
          )
        ],
        iconTheme: IconThemeData(color: currentTheme.colorScheme.tertiary),
        backgroundColor: currentTheme.primaryColor,
        title:
            "Store".text.color(currentTheme.colorScheme.tertiary).bold.make(),
      ),
      // drawer: MyDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              color:currentTheme.primaryColor ,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchWidget().pOnly(left: 16),
                  "Featured Brands"
                      .text
                      .xl
                      .align(TextAlign.left)
                      .bold
                      .make()
                      .pOnly(left: 15, top: 20),
                  BrandWidget(),
                ],
              ),
            ),
          ),
          SliverPersistentHeader(
            delegate: _SliverTabBarDelegate(tabBar),
            
            pinned: true,
          ),
          SliverFillRemaining(
            child: Container(
              color :currentTheme.primaryColor,
              child: TabBarView(
                controller: tabController,
                children: [
                  SingleCategoryWidget(
                      categoryId: 'CAlbFE9mNh5FnV4o1mS1',
                      categoryTitle: 'Phones'),
                  SingleCategoryWidget(
                      categoryId: 'D1Ly8LBIk8v5RllSV2Ry',
                      categoryTitle: 'Tablets'),
                  SingleCategoryWidget(
                      categoryId: 'wYWKwkX8B8FkSO787Lr0',
                      categoryTitle: 'Headphones'),
                  SingleCategoryWidget(
                      categoryId: 'JZUo4g5nkfsHB18PwPGi',
                      categoryTitle: 'Televisions'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  
  final TabBar _tabBar;

  _SliverTabBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
        final currentTheme = Theme.of(context);
    return Container(
      color: currentTheme.primaryColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}
