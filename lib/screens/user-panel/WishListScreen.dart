import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/CartPriceController.dart';
import 'package:flutter_application_1/models/product-model.dart';
import 'package:flutter_application_1/models/wishlist-model.dart';
import 'package:flutter_application_1/screens/user-panel/ProductDetailScreen.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_card/image_card.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../controllers/CartItemsController.dart';
import '../../controllers/wishlistController.dart';
import '../../models/cart-model.dart';
import 'SearchScreen.dart';
import 'cartScreen.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  Widget _getActionButton(
      {required Color color, required IconData icon, String? text}) {
    return Container(
      width: Get.width / 4,
      height: Get.height / 8,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white),
          if (text != null) SizedBox(width: 8),
          if (text != null)
            Text(text, style: TextStyle(color: Colors.white, fontSize: 16)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    WishlistController wishlistController = Get.put(WishlistController());
    FlashSaleController cartItemsController = Get.put(FlashSaleController());
    final currentTheme = Theme.of(context);
    User? user = FirebaseAuth.instance.currentUser;

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
                        textStyle: TextStyle(color: currentTheme.colorScheme.surface,fontSize: 10),
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
        title: "Favourites"
            .text
            .color(currentTheme.colorScheme.tertiary)
            .bold
            .make(),
      ),
      body: Container(
        color: currentTheme.primaryColor,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('wishlist')
              .doc(user!.uid)
              .collection('wishlistProducts')
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                child: "No Products Found".text.make(),
              );
            }
        
            if (snapshot.data != null) {
              return Padding(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final productData = snapshot.data!.docs[index];
                            WishlistModel wishlistModel = WishlistModel(
                              brandId: productData['brandId'],
                              brandName: productData['brandName'],
                              productColors: productData['productColors'],
                              productId: productData['productId'],
                              categoryId: productData['categoryId'],
                              productName: productData['productName'],
                              categoryName: productData['categoryName'],
                              salePrice: productData['salePrice'],
                              fullPrice: productData['fullPrice'],
                              productImages: productData['productImages'],
                              deliveryTime: productData['deliveryTime'],
                              isSale: productData['isSale'],
                              productDescription:
                                  productData['productDescription'],
                              createdAt: productData['createdAt'],
                              updatedAt: productData['updatedAt'],
                              isBest: productData['isBest'],
                            );
        
                            ProductModel productModel = ProductModel(
                              brandId: productData['brandId'],
                              brandName: productData['brandName'],
                              productColors: productData['productColors'],
                              productId: productData['productId'],
                              categoryId: productData['categoryId'],
                              productName: productData['productName'],
                              categoryName: productData['categoryName'],
                              salePrice: productData['salePrice'],
                              fullPrice: productData['fullPrice'],
                              productImages: productData['productImages'],
                              deliveryTime: productData['deliveryTime'],
                              isSale: productData['isSale'],
                              productDescription:
                                  productData['productDescription'],
                              createdAt: productData['createdAt'],
                              updatedAt: productData['updatedAt'],
                              isBest: productData['isBest'],
                            );
        
                            wishlistController.checkIfProductInWishlist(
                                productId: productModel.productId,
                                uId: user!.uid);
        
                            return Container(
                              color: currentTheme.primaryColor,
                              child: SwipeActionCell(
                                  trailingActions: [
                                    SwipeAction(
                                      performsFirstActionWithFullSwipe: true,
                                      forceAlignmentToBoundary: false,
                                      content: Padding(
                                        padding: const EdgeInsets.all(0),
                                        child: Container(
                                          
                                          margin: EdgeInsets.all(0),
                                          height: Get.height / 10.5,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.delete,
                                                  color: Colors.white),
                                              SizedBox(width: 8),
                                            ],
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                      widthSpace: Get.width / 3,
                                      color: currentTheme.primaryColor,
                                      onTap: (handler) async {
                                        // Perform the deletion
                                        await FirebaseFirestore.instance
                                            .collection('wishlist')
                                            .doc(user!.uid)
                                            .collection('wishlistProducts')
                                            .doc(wishlistModel.productId)
                                            .delete();
                                      },
                                    ),
                                  ],
                                  key: ObjectKey(wishlistModel.productId),
                                  child: InkWell(
                                    onTap: () => Get.to(() => ProductDetailScreen(
                                        productModel: productModel)),
                                    child: Container(
                                      color: currentTheme.primaryColor,
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10)),
                                        elevation: 5,
                                        child: VxBox(
                                          child: Row(
                                            children: [
                                              CatalogImage(
                                                  image:
                                                      wishlistModel.productImages[0]),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.all(0),
                                                  child: Container(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.center,
                                                      children: [
                                                        wishlistModel
                                                            .productName.text.bold.lg
                                                            .overflow(
                                                                TextOverflow.ellipsis)
                                                            .color(currentTheme
                                                                .colorScheme.onPrimary)
                                                            .make()
                                                            .pOnly(right: 10),
                                                        4.heightBox,
                                                        Row(
                                                          children: [
                                                            FutureBuilder<String>(
                                                              future:
                                                                  fetchBrandImageUrl(
                                                                      wishlistModel
                                                                          .brandId),
                                                              builder:
                                                                  (context, snapshot) {
                                                                if (snapshot
                                                                        .connectionState ==
                                                                    ConnectionState
                                                                        .waiting) {
                                                                  return CircularProgressIndicator();
                                                                } else if (snapshot
                                                                    .hasError) {
                                                                  print(snapshot.error);
                                                                  return Icon(
                                                                      Icons.error);
                                                                } else {
                                                                  return CachedNetworkImage(
                                                                    imageUrl:
                                                                        snapshot.data!,
                                                                    width: 20,
                                                                    height: 20,
                                                                    placeholder: (context,
                                                                            url) =>
                                                                        CircularProgressIndicator(),
                                                                    errorWidget:
                                                                        (context, url,
                                                                                error) =>
                                                                            Icon(Icons
                                                                                .error),
                                                                  );
                                                                }
                                                              },
                                                            ),
                                                            Container(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                padding:
                                                                    EdgeInsets.only(
                                                                        left: 2),
                                                                child: "${wishlistModel.brandName}"
                                                                    .text
                                                                    .textStyle(
                                                                        TextStyle(
                                                                            fontSize:
                                                                                10))
                                                                    .align(
                                                                        TextAlign.left)
                                                                    .color(currentTheme
                                                                        .colorScheme
                                                                        .tertiary)
                                                                    .make()),
                                                            Image.asset(
                                                              'assets/images/verifiedicon.png', // Replace with your icon path
                                                              width: 12,
                                                              height: 12,
                                                              // color: Colors.white,
                                                            ).pOnly(left: 2),
                                                          ],
                                                        ),
                                                        // 10.0.heightBox,
                                                        ButtonBar(
                                                          alignment: MainAxisAlignment
                                                              .spaceBetween,
                                                          buttonPadding:
                                                              EdgeInsets.zero,
                                                          children: [
                                                            "Rs ${wishlistModel.fullPrice}"
                                                                .text
                                                                .bold
                                                                .xl
                                                                .make(),
                                                            Obx(
                                                              () => Opacity(
                                                                opacity: 0.7,
                                                                child: Card(
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .circular(
                                                                                  50)),
                                                                  color: currentTheme.primaryColor,
                                                                  child: IconButton(
                                                                    icon: wishlistController.isFav(
                                                                            productModel
                                                                                .productId)
                                                                        ? Icon(Iconsax
                                                                            .heart5)
                                                                        : Icon(Iconsax
                                                                            .heart),
                                                                    color: wishlistController.isFav(
                                                                            productModel
                                                                                .productId)
                                                                        ? Colors.red
                                                                        : currentTheme
                                                                            .colorScheme
                                                                            .onPrimary,
                                                                    onPressed: () {
                                                                      wishlistController
                                                                          .toggleWishlistStatus(
                                                                              uId: user!
                                                                                  .uid,
                                                                              productModel:
                                                                                  productModel);
                                                                    },
                                                                  ),
                                                                ).pOnly(right: 10),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                            .color(currentTheme.colorScheme.surface)
                                            .rounded
                                            .square(Get.height / 6.5)
                                            .make()
                                            .py4(),
                                      ),
                                    ),
                                  )),
                            );
                          }),
                    ),
                  ],
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}

class CatalogImage extends StatelessWidget {
  final String image;

  const CatalogImage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);

    return Image.network(
      image,
      fit: BoxFit.contain,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        } else {
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      (loadingProgress.expectedTotalBytes ?? 1)
                  : null,
            ),
          );
        }
      },
      errorBuilder: (context, error, stackTrace) {
        return Center(
          child: Text(
            'Failed to load image',
            style: TextStyle(color: currentTheme.colorScheme.error),
          ),
        );
      },
    )
        .box
        .rounded
        .p8
        .color(currentTheme.colorScheme.surface)
        .make()
        .px12()
        .w32(context)
        .py4()
        .h15(context);
  }
}
