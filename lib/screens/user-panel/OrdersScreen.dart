import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/order-model.dart';
import 'package:flutter_application_1/screens/user-panel/OrderDetailScreen.dart';
import 'package:flutter_application_1/screens/user-panel/SearchScreen.dart';
import 'package:flutter_application_1/screens/user-panel/cartScreen.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../controllers/CartItemsController.dart';
import '../../controllers/CartPriceController.dart';
import '../../controllers/ReviewControllwe.dart';
import 'ReviewSheet.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  ProductReviewController reviewController = Get.put(ProductReviewController());
  final PriceController priceController = Get.put(PriceController());
  FlashSaleController cartItemsController = Get.put(FlashSaleController());
  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);
    return Scaffold(
      backgroundColor: currentTheme.primaryColor,
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
            ),
            
          ],
          iconTheme: IconThemeData(color: currentTheme.colorScheme.tertiary),
          backgroundColor: Colors.transparent,
          title: "Orders"
              .text
              .color(currentTheme.colorScheme.tertiary)
              .bold
              .make(),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('orders')
              .doc(user!.uid)
              .collection('cartOrders')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                child: "No Orders Found".text.make(),
              );
            }

            if (snapshot.data != null) {
              return Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Column(
                  children: [
                    ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final productData = snapshot.data!.docs[index];
                          // ProductModel productModel = ProductModel(
                          //   brandId: productData['brandId'],
                          //   brandName: productData['brandName'],
                          //   productColors: productData['productColor'],
                          //   productId: productData['productId'],
                          //   categoryId: productData['categoryId'],
                          //   productName: productData['productName'],
                          //   categoryName: productData['categoryName'],
                          //   salePrice: productData['salePrice'],
                          //   fullPrice: productData['fullPrice'],
                          //   productImages: productData['productImages'],
                          //   deliveryTime: productData['deliveryTime'],
                          //   isSale: productData['isSale'],
                          //   productDescription:
                          //       productData['productDescription'],
                          //   createdAt: productData['createdAt'],
                          //   updatedAt: productData['updatedAt'],
                          //   isBest: productData['isBest'],
                          // );
                          OrderModel orderModel = OrderModel(
                              orderId: productData['orderId'],
                              payOption: productData['payOption'],
                              customerAddress: productData['customerAddress'],
                              customerDeviceToken:
                                  productData['customerDeviceToken'],
                              customerId: productData['customerId'],
                              customerName: productData['customerName'],
                              customerPhone: productData['customerPhone'],
                              customerStreet: productData['customerStreet'],
                              noteToRider: productData['noteToRider'],
                              status: productData['status'],
                              brandId: productData['brandId'],
                              brandName: productData['brandName'],
                              productColor: productData['productColor'],
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
                              productQuantity: productData['productQuantity'],
                              productTotalPrice:
                                  productData['productTotalPrice']);

                          final shippingDay = calculateShippingDay(
                            orderModel.deliveryTime,
                            orderModel.createdAt,
                          );
                          // print("Color:  ${orderModel.productColor}");
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
                                        .doc(user!.uid)
                                        .collection('cartOrders')
                                        .doc(orderModel.productId)
                                        .delete();
                                  },
                                ),
                              ],
                              key: ObjectKey(orderModel.productId),
                              child: GestureDetector(
                                onTap: (){
                                  Get.to(()=>OrderDetailScreen(orderModel : orderModel));
                                },
                                child: Container(
                                  color: currentTheme.primaryColor,
                                  child: Card(
                                    color: currentTheme.primaryColorLight,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                    elevation: 5,
                                    child: VxBox(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              CatalogImage(
                                                  image:
                                                      orderModel.productImages[0]),
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    children: [
                                                      orderModel
                                                          .productName.text.bold
                                                          .textStyle(const TextStyle(
                                                              fontSize: 11))
                                                          .overflow(
                                                              TextOverflow.ellipsis)
                                                          .color(currentTheme
                                                              .colorScheme
                                                              .onPrimary)
                                                          .make()
                                                          .pOnly(right: 10),
                                                      4.heightBox,
                                                      Row(
                                                        children: [
                                                          FutureBuilder<String>(
                                                            future:
                                                                fetchBrandImageUrl(
                                                                    orderModel
                                                                        .brandId),
                                                            builder: (context,
                                                                snapshot) {
                                                              if (snapshot
                                                                      .connectionState ==
                                                                  ConnectionState
                                                                      .waiting) {
                                                                return const CircularProgressIndicator();
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
                                                                  width: 16,
                                                                  height: 16,
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
                                                              padding:
                                                                  const EdgeInsets.only(
                                                                      left: 2),
                                                              child: orderModel.brandName
                                                                  .text
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
                                                            width: 8,
                                                            height: 8,
                                                            // color: Colors.white,
                                                          ).pOnly(left: 2),
                                                        ],
                                                      ),
                                                      4.heightBox,
                                                      "Color : ${orderModel.productColor}"
                                                          .text
                                                          .textStyle(const TextStyle(
                                                              fontSize: 10))
                                                          .light
                                                          .overflow(
                                                              TextOverflow.ellipsis)
                                                          .color(currentTheme
                                                              .colorScheme.tertiary)
                                                          .make()
                                                          .pOnly(right: 10),
                                                      // 10.0.heightBox,
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                            margin:
                                                                const EdgeInsets.all(0),
                                                            // height: Get.height * 0.05,
                                                            child: orderModel.isSale
                                                                ? "Rs ${orderModel.salePrice}"
                                                                    .text
                                                                    .bold
                                                                    .textStyle(
                                                                        const TextStyle(
                                                                            fontSize:
                                                                                10))
                                                                    .make()
                                                                : "Rs ${orderModel.fullPrice}"
                                                                    .text
                                                                    .bold
                                                                    .textStyle(
                                                                        const TextStyle(
                                                                            fontSize:
                                                                                10))
                                                                    .make(),
                                                          ),
                                                          "Qty : ${orderModel.productQuantity}"
                                                              .text
                                                              .bold
                                                              .textStyle(const TextStyle(
                                                                  fontSize: 10))
                                                              .make()
                                                              .pOnly(right: 20)
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width: Get.width * 0.95,
                                            height: Get.height / 8,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        "Status : "
                                                            .text
                                                            .textStyle(const TextStyle(
                                                                fontSize: 12))
                                                            .color(currentTheme
                                                                .colorScheme
                                                                .tertiaryFixed)
                                                            .make(),
                                                        orderModel.status
                                                            ? "Delivered"
                                                                .text
                                                                .textStyle(
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            13))
                                                                .color(currentTheme
                                                                    .colorScheme
                                                                    .tertiary)
                                                                .make()
                                                            : "In Progress"
                                                                .text
                                                                .textStyle(
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            13))
                                                                .color(currentTheme
                                                                    .colorScheme
                                                                    .tertiary)
                                                                .make(),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        "Shipping Day : "
                                                            .text
                                                            .textStyle(const TextStyle(
                                                                fontSize: 12))
                                                            .color(currentTheme
                                                                .colorScheme
                                                                .tertiaryFixed)
                                                            .make(),
                                                        shippingDay.text
                                                            .textStyle(const TextStyle(
                                                                fontSize: 13))
                                                            .color(currentTheme
                                                                .colorScheme
                                                                .tertiary)
                                                            .make(),
                                                      ],
                                                    ).pOnly(top: 5),
                                                    Row(
                                                      children: [
                                                        "Total : "
                                                            .text
                                                            .textStyle(const TextStyle(
                                                                fontSize: 12))
                                                            .color(currentTheme
                                                                .colorScheme
                                                                .tertiaryFixed)
                                                            .make(),
                                                        orderModel
                                                            .productTotalPrice.text
                                                            .textStyle(const TextStyle(
                                                                fontSize: 13))
                                                            .color(currentTheme
                                                                .colorScheme
                                                                .tertiary)
                                                            .make()
                                                      ],
                                                    ).pOnly(top: 5)
                                                  ],
                                                ).pOnly(left: 15),
                                                Material(
                                                  color: Colors.transparent,
                                                  child: Container(
                                                    color: Colors.transparent,
                                                    child: TextButton(
                                                      style: ButtonStyle(
                                                          foregroundColor: const WidgetStatePropertyAll(
                                                              Colors.transparent),
                                                          backgroundColor:
                                                              WidgetStateProperty.all(
                                                                  currentTheme
                                                                      .colorScheme
                                                                      .onPrimary),
                                                          shape: const WidgetStatePropertyAll(
                                                              RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              10)))),
                                                          overlayColor:
                                                              WidgetStatePropertyAll(
                                                                  currentTheme.colorScheme.primary)),
                                                      onPressed: () {
                                                        if (orderModel.status) {
                                                          showModalBottomSheet(
                                                            isScrollControlled: true,
                                                            context: context,
                                                            builder: (BuildContext context) {
                                                              return DraggableScrollableSheet(
                                                                initialChildSize:
                                                                    0.75, // Adjust this value to increase the initial size
                                                                minChildSize:
                                                                    0.5, // The minimum size when dragged down
                                                                maxChildSize:
                                                                    1.0, // The maximum size when fully expanded
                                                                expand: false,
                                                                builder: (context, scrollController) {
                                                                  return ReviewSheet(
                                                                      productId: orderModel.productId);
                                                                },
                                                              );
                                                            },
                                                          );
                                                        } else {}
                                                      },
                                                      child: orderModel.status
                                                          ? "Review"
                                                              .text
                                                              .color(currentTheme
                                                                  .colorScheme
                                                                  .surface)
                                                              .make()
                                                          : "Track"
                                                              .text
                                                              .color(currentTheme
                                                                  .colorScheme
                                                                  .surface)
                                                              .make(),
                                                    ).wh(Get.width * 0.3,
                                                        Get.height / 14),
                                                  ),
                                                ).pOnly(right: 15),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                        .color(currentTheme.primaryColorLight)
                                        .rounded
                                        .square(Get.height / 3.5)
                                        .make()
                                        .py4(),
                                  ),
                                ),
                              ));
                        }),
                    20.heightBox,
                  ],
                ),
              );
            }
            return Container();
          },
        ));
  }
}

String calculateShippingDay(String deliveryTime, Timestamp createdAt) {
  // Extract the number of days from the deliveryTime string
  final days = int.parse(deliveryTime.replaceAll(RegExp(r'[^0-9]'), ''));

  // Convert the Firebase Timestamp to DateTime
  final orderDate = createdAt.toDate();

  // Calculate the shipping day by adding the extracted days
  final shippingDay = orderDate.add(Duration(days: days));

  // Format the shipping day into a readable string
  final shippingDayFormatted = DateFormat('dd-MM-yy').format(shippingDay);

  return shippingDayFormatted;
}
