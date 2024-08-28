import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/categories-model.dart';
import 'package:flutter_application_1/models/product-model.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_card/image_card.dart';
import 'package:velocity_x/velocity_x.dart';

import '../controllers/CartItemsController.dart';
import '../controllers/wishlistController.dart';
import '../models/cart-model.dart';
import '../screens/user-panel/ProductDetailScreen.dart';

class ProductsSliderWidget extends StatelessWidget {
  const ProductsSliderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    WishlistController wishlistController = Get.put(WishlistController());
    final currentTheme = Theme.of(context);
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('products')
            .where('isSale', isEqualTo: false)
            .get(),
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
            return GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 3,
                crossAxisSpacing: 4,
                childAspectRatio: 0.6,
              ),
              itemCount: snapshot.data!.docs.length,
              // clipBehavior: Clip.antiAlias,
              padding: EdgeInsets.all(0),
              itemBuilder: (context, index) {
                final FlashSaleController controller =
                    Get.put(FlashSaleController());
                final productData = snapshot.data!.docs[index];
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
                    isBest: productData['isBest'],
                    productDescription: productData['productDescription'],
                    createdAt: productData['createdAt'],
                    updatedAt: productData['updatedAt']);

                controller.fetchProductQuantity(productModel.productId);

                wishlistController.checkIfProductInWishlist(
                    productId: productModel.productId, uId: user!.uid);

                return GestureDetector(
                  onTap: () => Get.to(
                      () => ProductDetailScreen(productModel: productModel)),
                  child: Padding(
                    padding: EdgeInsets.all(0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 5,
                      child: Container(
                        padding: EdgeInsets.only(left: 10),
                        margin: EdgeInsets.all(0),
                        decoration: BoxDecoration(
                            color: currentTheme.colorScheme.surface,
                            border: Border.all(color: Colors.transparent),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Center(
                          child: Stack(
                            children: [
                              Hero(
                                tag: Key(productModel.productId),
                                child: FillImageCard(
                                  contentPadding:
                                      EdgeInsets.only(bottom: 0, top: 2),
                                  color: currentTheme.colorScheme.surface,
                                  borderRadius: 20,
                                  width: Get.width / 2.6,
                                  heightImage: Get.height / 4.5,
                                  height: Get.height / 1.2,
                                  imageProvider: CachedNetworkImageProvider(
                                    productModel.productImages[0],
                                  ),
                                  title: Center(
                                    heightFactor: 0.2,
                                    child: Text(
                                      productModel.productName,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  footer: Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.all(0),
                                    padding: EdgeInsets.only(top: 5),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Rs ${productModel.salePrice}",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            5.widthBox,
                                            Flexible(
                                              child: Text(
                                                "${productModel.fullPrice}",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                    color: currentTheme
                                                        .colorScheme.onPrimary),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          ],
                                        ),
                                        Container(
                                          // alignment: Alignment.bottomLeft,
                                          margin: EdgeInsets.only(
                                              right: 20, top: 5),
                                          height: Get.height * 0.045,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.all(0),
                                                padding: EdgeInsets.all(0),
                                                width: Get.width / 10,
                                                height: Get.height * 0.045,
                                                child: Card(
                                                  margin: EdgeInsets.all(1),
                                                  color: currentTheme
                                                      .colorScheme.secondary,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  elevation: 3,
                                                  child: TextButton(
                                                    onPressed: () async {
                                                      controller
                                                          .decrementProductQuantity(
                                                              productModel
                                                                  .productId);
                                                    },
                                                    child: Container(
                                                        child: "-"
                                                            .text
                                                            .bold
                                                            .textStyle(
                                                                TextStyle(
                                                                    fontSize:
                                                                        8))
                                                            .color(currentTheme
                                                                .colorScheme
                                                                .primary)
                                                            .make()),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.all(0),
                                                padding: EdgeInsets.all(0),
                                                width: Get.width / 10,
                                                height: Get.height * 0.045,
                                                child: Card(
                                                  margin: EdgeInsets.all(1),
                                                  color: currentTheme
                                                      .colorScheme.secondary,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  elevation: 3,
                                                  child: TextButton(
                                                    onPressed: () async {
                                                      await checkProductExistance(
                                                          uId: user!.uid,
                                                          productModel:
                                                              productModel);
                                                      await controller
                                                          .fetchProductQuantity(
                                                              productModel
                                                                  .productId);
                                                    },
                                                    child: StreamBuilder<int>(
                                                      stream: controller
                                                          .getProductQuantityStream(
                                                              productModel
                                                                  .productId),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return Center(
                                                              child:
                                                                  CircularProgressIndicator());
                                                        }
                                                        if (snapshot.hasError) {
                                                          return Center(
                                                              child: Text(
                                                                  'Error: ${snapshot.error}'));
                                                        }
                                                        int quantity =
                                                            snapshot.data ?? 0;
                                                        return Container(
                                                          padding:
                                                              EdgeInsets.all(0),
                                                          child: Text(
                                                            quantity.toString(),
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: currentTheme
                                                                    .colorScheme
                                                                    .primary),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0.1,
                                right: 0.1,
                                child: Obx(
                                  () => Opacity(
                                    opacity: 0.7,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      color: currentTheme.colorScheme.surface,
                                      child: IconButton(
                                        icon: wishlistController
                                                .isFav(productModel.productId)
                                            ? Icon(Iconsax.heart5)
                                            : Icon(Iconsax.heart),
                                        color: wishlistController
                                                .isFav(productModel.productId)
                                            ? Colors.red
                                            : currentTheme
                                                .colorScheme.onPrimary,
                                        onPressed: () {
                                          wishlistController
                                              .toggleWishlistStatus(
                                                  uId: user!.uid,
                                                  productModel: productModel);
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return Container();
        });
  }

  Future<int> checkProductExistance(
      {required String uId,
      int quantityIncrement = 1,
      required ProductModel productModel}) async {
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection("cart")
        .doc(uId)
        .collection("cartOrders")
        .doc(productModel.productId.toString());
    DocumentSnapshot snapshot = await documentReference.get();

    if (snapshot.exists) {
      var currentQuantity = snapshot["productQuantity"];
      int updatedQuantity = currentQuantity + quantityIncrement;
      double totalPrice = double.parse(productModel.isSale
              ? productModel.salePrice.replaceAll(',', '')
              : productModel.fullPrice.replaceAll(',', '')) *
          updatedQuantity;
      await documentReference.update({
        'productQuantity': updatedQuantity,
        'productTotalPrice': totalPrice
      });
      print("Product Exists");
      return updatedQuantity;
    } else {
      await FirebaseFirestore.instance
          .collection('cart')
          .doc(uId)
          .set({"uId": uId, 'createedAt': DateTime.now()});
      CartModel cartModel = CartModel(
          brandId: productModel.brandId,
          brandName: productModel.brandName,
          productColors: productModel.productColors,
          productId: productModel.productId,
          categoryId: productModel.categoryId,
          productName: productModel.productName,
          categoryName: productModel.categoryName,
          salePrice: productModel.salePrice,
          fullPrice: productModel.fullPrice,
          productImages: productModel.productImages,
          deliveryTime: productModel.deliveryTime,
          isSale: productModel.isSale,
          isBest: productModel.isBest,
          productDescription: productModel.productDescription,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          productQuantity: 1,
          productColor: productModel.productColors[0],
          productTotalPrice: double.parse(productModel.isSale
              ? productModel.salePrice.replaceAll(',', '')
              : productModel.fullPrice.replaceAll(',', '')));
      await documentReference.set(cartModel.toMap());
      print("Product Added");
      return 1;
    }
  }
}
