import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/CartPriceController.dart';
import 'package:flutter_application_1/models/product-model.dart';
import 'package:flutter_application_1/screens/user-panel/ProductDetailScreen.dart';
import 'package:flutter_application_1/screens/user-panel/checkOutScreen.dart';
import 'package:flutter_application_1/services/getServiceKey.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../models/cart-model.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
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
          if (text != null) const SizedBox(width: 8),
          if (text != null)
            Text(text,
                style: const TextStyle(color: Colors.white, fontSize: 16)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);
    User? user = FirebaseAuth.instance.currentUser;
    final PriceController priceController = Get.put(PriceController());

    return Scaffold(
      backgroundColor: currentTheme.primaryColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: currentTheme.colorScheme.tertiary),
        backgroundColor: Colors.transparent,
        title: "Cart".text.color(currentTheme.colorScheme.tertiary).bold.make(),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('cart')
            .doc(user!.uid)
            .collection('cartOrders')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
            return Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
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
                            productDescription:
                                productData['productDescription'],
                            createdAt: productData['createdAt'],
                            updatedAt: productData['updatedAt'],
                            isBest: productData['isBest'],
                          );
                          CartModel cartModel = CartModel(
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
                              productDescription:
                                  productData['productDescription'],
                              createdAt: productData['createdAt'],
                              updatedAt: productData['updatedAt'],
                              productQuantity: productData['productQuantity'],
                              productColor: productData['productColor'],
                              productTotalPrice:
                                  productData['productTotalPrice']);
                          // print("Color:  ${cartModel.productColor}");
                          priceController.fetchPrice();
                          return SwipeActionCell(
                              trailingActions: [
                                SwipeAction(
                                  performsFirstActionWithFullSwipe: true,
                                  forceAlignmentToBoundary: false,
                                  content: Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: Container(
                                      margin: const EdgeInsets.all(0),
                                      height: Get.height / 6.5,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.red,
                                      ),
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.delete,
                                              color: Colors.white),
                                          SizedBox(width: 8),
                                        ],
                                      ),
                                    ),
                                  ),
                                  widthSpace: Get.width / 3,
                                  color: Colors.transparent,
                                  onTap: (handler) async {
                                    // Perform the deletion
                                    await FirebaseFirestore.instance
                                        .collection('cart')
                                        .doc(user.uid)
                                        .collection('cartOrders')
                                        .doc(cartModel.productId)
                                        .delete();
                                  },
                                ),
                              ],
                              key: ObjectKey(cartModel.productId),
                              child: InkWell(
                                onTap: () => Get.to(() => ProductDetailScreen(
                                    productModel: productModel)),
                                child: Container(
                                  color: currentTheme.primaryColor,
                                  child: Card(
                                    color: currentTheme.primaryColorLight,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    elevation: 5,
                                    child: VxBox(
                                      child: Row(
                                        children: [
                                          CatalogImage(
                                              image:
                                                  cartModel.productImages[0]),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.all(0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  cartModel
                                                      .productName.text.bold.lg
                                                      .overflow(
                                                          TextOverflow.ellipsis)
                                                      .color(currentTheme
                                                          .colorScheme
                                                          .onPrimary)
                                                      .make()
                                                      .pOnly(right: 10),

                                                  Row(
                                                    children: [
                                                      FutureBuilder<String>(
                                                        future:
                                                            fetchBrandImageUrl(
                                                                cartModel
                                                                    .brandId),
                                                        builder: (context,
                                                            snapshot) {
                                                          if (snapshot
                                                                  .connectionState ==
                                                              ConnectionState
                                                                  .waiting) {
                                                            return const Text("");
                                                          } else if (snapshot
                                                              .hasError) {
                                                            print(
                                                                snapshot.error);
                                                            return const Icon(
                                                                Icons.error);
                                                          } else {
                                                            return CachedNetworkImage(
                                                              imageUrl: snapshot
                                                                  .data!,
                                                              width: 20,
                                                              height: 20,
                                                              placeholder: (context,
                                                                      url) =>
                                                                  const CircularProgressIndicator(),
                                                              errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                  const Icon(Icons
                                                                      .error),
                                                            );
                                                          }
                                                        },
                                                      ),
                                                      Container(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          padding: const EdgeInsets
                                                              .only(left: 2),
                                                          child: cartModel
                                                              .brandName.text
                                                              .textStyle(
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          10))
                                                              .align(TextAlign
                                                                  .left)
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
                                                  4.heightBox,
                                                  Row(
                                                    children: [
                                                      "Color : "
                                                          .text
                                                          .textStyle(context
                                                              .captionStyle)
                                                          .light
                                                          .overflow(TextOverflow
                                                              .ellipsis)
                                                          .color(currentTheme
                                                              .colorScheme
                                                              .tertiary)
                                                          .make(),
                                                      "${cartModel.productColor}"
                                                          .text
                                                          .textStyle(context
                                                              .captionStyle)
                                                          .light
                                                          .overflow(TextOverflow
                                                              .ellipsis)
                                                          .fontWeight(
                                                              FontWeight.bold)
                                                          .color(currentTheme
                                                              .colorScheme
                                                              .tertiary)
                                                          .make()
                                                          .pOnly(right: 10),
                                                    ],
                                                  ),
                                                  // 10.0.heightBox,
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.all(0),
                                                    height: Get.height * 0.05,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        "Rs ${cartModel.productTotalPrice}"
                                                            .text
                                                            .bold
                                                            .xl
                                                            .make(),
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width:
                                                                  Get.width / 9,
                                                              child: Card(
                                                                color: currentTheme
                                                                    .colorScheme
                                                                    .secondary,
                                                                shape:
                                                                    const CircleBorder(),
                                                                elevation: 3,
                                                                child:
                                                                    TextButton(
                                                                  onPressed:
                                                                      () async {
                                                                    if (cartModel
                                                                            .productQuantity >
                                                                        1) {
                                                                      await FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'cart')
                                                                          .doc(user
                                                                              .uid)
                                                                          .collection(
                                                                              'cartOrders')
                                                                          .doc(cartModel
                                                                              .productId)
                                                                          .update({
                                                                        'productQuantity':
                                                                            cartModel.productQuantity -
                                                                                1,
                                                                        'productTotalPrice': (double.parse(cartModel.fullPrice.replaceAll(',',
                                                                                ''))) *
                                                                            (cartModel.productQuantity -
                                                                                1)
                                                                      });
                                                                    } else {
                                                                      await FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'cart')
                                                                          .doc(user
                                                                              .uid)
                                                                          .collection(
                                                                              'cartOrders')
                                                                          .doc(cartModel
                                                                              .productId)
                                                                          .delete();
                                                                    }
                                                                  },
                                                                  child: Center(
                                                                      child: "-"
                                                                          .text
                                                                          .bold
                                                                          .color(currentTheme
                                                                              .colorScheme
                                                                              .primary)
                                                                          .make()),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width:
                                                                  Get.width / 9,
                                                              child: Card(
                                                                color: currentTheme
                                                                    .colorScheme
                                                                    .secondary,
                                                                shape:
                                                                    const CircleBorder(),
                                                                elevation: 3,
                                                                child:
                                                                    TextButton(
                                                                  onPressed:
                                                                      () async {
                                                                    if (cartModel
                                                                            .productQuantity >
                                                                        0) {
                                                                      await FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'cart')
                                                                          .doc(user
                                                                              .uid)
                                                                          .collection(
                                                                              'cartOrders')
                                                                          .doc(cartModel
                                                                              .productId)
                                                                          .update({
                                                                        'productQuantity':
                                                                            cartModel.productQuantity +
                                                                                1,
                                                                        'productTotalPrice': (double.parse(cartModel.fullPrice.replaceAll(',',
                                                                                ''))) *
                                                                            (cartModel.productQuantity +
                                                                                1)
                                                                      });
                                                                    }
                                                                  },
                                                                  child: Center(
                                                                      child: cartModel
                                                                          .productQuantity
                                                                          .text
                                                                          .bold
                                                                          .color(currentTheme
                                                                              .colorScheme
                                                                              .primary)
                                                                          .make()),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ).pOnly(right: 10)
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                        .color(currentTheme.primaryColorLight)
                                        .rounded
                                        .square(Get.height / 6.5)
                                        .make()
                                        .py4(),
                                  ),
                                ),
                              ));
                        }),
                  ),
                  20.heightBox,
                  Obx(
                    () => Container(
                      margin: const EdgeInsets.all(0),
                      padding: const EdgeInsets.all(0),
                      width: Get.width - 10,
                      child: Card(
                        color: currentTheme.colorScheme.secondary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 5,
                        child: TextButton(
                          onPressed: () async {
                            GetServiceKey getServiceKey = GetServiceKey();
                            final serviceKey =
                                await getServiceKey.getServerKeyToken();
                            print("Service key :  $serviceKey");
                            Get.to(CheckoutScreen(
                                total: priceController.totalPrice.value
                                    .toStringAsFixed(1)));
                          },
                          child: Center(
                              child:
                                  "${priceController.totalPrice.value.toStringAsFixed(1)} CheckOut"
                                      .text
                                      .color(currentTheme.colorScheme.primary)
                                      .make()),
                        ),
                      ),
                    ).pOnly(bottom: 20),
                  ),
                ],
              ),
            );
          }
          return Container();
        },
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

Future<String> fetchBrandImageUrl(String brandId) async {
  final brandDoc =
      await FirebaseFirestore.instance.collection('brand').doc(brandId).get();

  if (brandDoc.exists) {
    return brandDoc[
        'brandImage']; // assuming the brand image URL is stored in the 'imageUrl' field
  } else {
    throw Exception("Brand not found");
  }
}
