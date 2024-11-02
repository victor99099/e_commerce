import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/user-panel/ProductDetailScreen.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_card/image_card.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../controllers/CartItemsController.dart';
import '../../models/cart-model.dart';
import '../../models/product-model.dart';

class AllFlashSaleWidget extends StatefulWidget {
  const AllFlashSaleWidget({super.key});

  @override
  State<AllFlashSaleWidget> createState() => _AllFlashSaleWidgetState();
}

class _AllFlashSaleWidgetState extends State<AllFlashSaleWidget> {
  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: currentTheme.colorScheme.secondary,
        title: "Flash Sale".text.color(Colors.white).bold.make(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            20.heightBox,
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('products')
                    .where("isSale", isEqualTo: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text("Error"));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      height: Get.height / 5,
                      child: const Center(
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
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 3,
                        crossAxisSpacing: 4,
                        childAspectRatio: 0.6,
                      ),
                      itemCount: snapshot.data!.docs.length,
                      padding: const EdgeInsets.all(0),
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
                          productDescription: productData['productDescription'],
                          createdAt: productData['createdAt'],
                          updatedAt: productData['updatedAt'],
                          isBest: productData['isBest'],
                          // productColor: productData['productColor']
                        );

                        // Fetch the product quantity when the widget is built
                        controller.fetchProductQuantity(productModel.productId);

                        return GestureDetector(
                          onTap: () => Get.to(() =>
                              ProductDetailScreen(productModel: productModel)),
                          child: Padding(
                            padding: const EdgeInsets.all(0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              elevation: 5,
                              child: Container(
                                padding: const EdgeInsets.only(top: 10),
                                margin: const EdgeInsets.all(0),
                                decoration: BoxDecoration(
                                    color: currentTheme.colorScheme.surface,
                                    border:
                                        Border.all(color: Colors.transparent),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                child: Center(
                                  child: Stack(
                                    children: [
                                      Hero(
                                        tag: Key(productModel.productId),
                                        child: FillImageCard(
                                          contentPadding: const EdgeInsets.only(
                                              bottom: 0, top: 2),
                                          color:
                                              currentTheme.colorScheme.surface,
                                          borderRadius: 20,
                                          width: Get.width / 2.6,
                                          heightImage: Get.height / 4.5,
                                          height: Get.height / 1.2,
                                          imageProvider:
                                              CachedNetworkImageProvider(
                                            productModel.productImages[0],
                                          ),
                                          title: Center(
                                            heightFactor: 0.2,
                                            child: Text(
                                              productModel.productName,
                                              style: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          footer: Container(
                                            width: double.infinity,
                                            margin: const EdgeInsets.all(0),
                                            padding:
                                                const EdgeInsets.only(top: 5),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Rs ${productModel.salePrice}",
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    5.widthBox,
                                                    Flexible(
                                                      child: Text(
                                                        productModel.fullPrice,
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                            color: currentTheme
                                                                .colorScheme
                                                                .onPrimary),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Container(
                                                  // alignment: Alignment.bottomLeft,
                                                  margin: const EdgeInsets.only(
                                                      right: 20, top: 5),
                                                  height: Get.height * 0.045,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .all(0),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(0),
                                                        width: Get.width / 10,
                                                        height:
                                                            Get.height * 0.045,
                                                        child: Card(
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(1),
                                                          color: currentTheme
                                                              .colorScheme
                                                              .secondary,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                          elevation: 3,
                                                          child: TextButton(
                                                            onPressed:
                                                                () async {
                                                              controller.decrementProductQuantity(
                                                                  productModel
                                                                      .productId);
                                                            },
                                                            child: Container(
                                                                child: "-"
                                                                    .text
                                                                    .bold
                                                                    .textStyle(const TextStyle(
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
                                                        margin: const EdgeInsets
                                                            .all(0),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(0),
                                                        width: Get.width / 10,
                                                        height:
                                                            Get.height * 0.045,
                                                        child: Card(
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(1),
                                                          color: currentTheme
                                                              .colorScheme
                                                              .secondary,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                          elevation: 3,
                                                          child: TextButton(
                                                            onPressed:
                                                                () async {
                                                              await checkProductExistance(
                                                                currentTheme: currentTheme,
                                                                  uId:
                                                                      user!.uid,
                                                                  productModel:
                                                                      productModel);
                                                              await controller
                                                                  .fetchProductQuantity(
                                                                      productModel
                                                                          .productId);
                                                            },
                                                            child:
                                                                StreamBuilder<
                                                                    int>(
                                                              stream: controller
                                                                  .getProductQuantityStream(
                                                                      productModel
                                                                          .productId),
                                                              builder: (context,
                                                                  snapshot) {
                                                                if (snapshot
                                                                        .connectionState ==
                                                                    ConnectionState
                                                                        .waiting) {
                                                                  return const Center(
                                                                      child:
                                                                          CircularProgressIndicator());
                                                                }
                                                                if (snapshot
                                                                    .hasError) {
                                                                  return Center(
                                                                      child: Text(
                                                                          'Error: ${snapshot.error}'));
                                                                }
                                                                int quantity =
                                                                    snapshot.data ??
                                                                        0;
                                                                return Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          0),
                                                                  child: Text(
                                                                    quantity
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12,
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
                                        child: Opacity(
                                          opacity: 0.7,
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50)),
                                            color: currentTheme
                                                .colorScheme.surface,
                                            child: IconButton(
                                              icon: const Icon(Iconsax.heart),
                                              color: currentTheme
                                                  .colorScheme.onPrimary,
                                              onPressed: () {
                                                // Handle heart icon press
                                                // You can add/remove from favorites or show a dialog here
                                              },
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
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<int> checkProductExistance(
      {required String uId,
      int quantityIncrement = 1,
      required ProductModel productModel, required dynamic currentTheme}) async {
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Profile picture updated',
          style: TextStyle(color: currentTheme.colorScheme.surface),
        ),
        backgroundColor: currentTheme.colorScheme.onPrimary,
      ));
      print("Product Added");
      return 1;
    }
  }
}
