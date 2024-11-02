import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/order-model.dart';
import 'package:flutter_application_1/screens/user-panel/checkOutScreen.dart';
import 'package:flutter_application_1/screens/user-panel/navigationMenu.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:velocity_x/velocity_x.dart';

import 'ReviewSheet.dart';

class OrderDetailScreen extends StatefulWidget {
  OrderModel orderModel;
  OrderDetailScreen({super.key, required this.orderModel});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final createdAt = widget.orderModel.createdAt.toDate();
    final orderDay = DateFormat('dd MMMM yyyy').format(createdAt);

    final shippingDay = calculateShippingDay(
      widget.orderModel.deliveryTime,
      widget.orderModel.createdAt,
    );
    final shippingDay2 = calculateShippingDay2(
      widget.orderModel.deliveryTime,
      widget.orderModel.createdAt,
    );
    final currentTheme = Theme.of(context);
    return Scaffold(
      backgroundColor: currentTheme.primaryColor,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: currentTheme.colorScheme.tertiary),
        backgroundColor: Colors.transparent,
        title: "Order Details"
            .text
            .color(currentTheme.colorScheme.tertiary)
            .bold
            .make(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                if (widget.orderModel.status) {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return DraggableScrollableSheet(
                        initialChildSize:
                            0.75, // Adjust this value to increase the initial size
                        minChildSize: 0.5, // The minimum size when dragged down
                        maxChildSize:
                            1.0, // The maximum size when fully expanded
                        expand: false,
                        builder: (context, scrollController) {
                          return ReviewSheet(
                              productId: widget.orderModel.productId);
                        },
                      );
                    },
                  );
                } else {}
              },
              child: SizedBox(
                width: Get.width,
                height: Get.height * 0.08,
                child: Card(
                  color: currentTheme.primaryColorLight,
                  // elevation: 8,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      Icon(
                        Iconsax.truck,
                        color: currentTheme.colorScheme.onPrimary,
                      ),
                      widget.orderModel.status
                          ? SizedBox(
                              height: Get.height * 0.05,
                              width: Get.width * 0.7,
                              child:
                                  "Your order has been delivered to you on $shippingDay, Tap to give a review"
                                      .text
                                      .color(currentTheme
                                          .colorScheme.tertiaryFixed)
                                      // .overflow(TextOverflow.ellipsis)
                                      .make(),
                            ).pOnly(left: 10)
                          : SizedBox(
                              height: Get.height * 0.05,
                              width: Get.width * 0.7,
                              child:
                                  "Your order wyll be delivered to you on $shippingDay, Tap to track your order"
                                      .text
                                      .make(),
                            ).pOnly(left: 10),
                      ">"
                          .text
                          .textStyle(const TextStyle(fontSize: 100))
                          .color(currentTheme.colorScheme.tertiaryFixed)
                          .make()
                          .pOnly(left: 20)
                    ],
                  ).pOnly(left: 10),
                ),
              ),
            ),
            SizedBox(
              width: Get.width,
              height: Get.height * 0.12,
              child: Card(
                color: currentTheme.primaryColorLight,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Iconsax.map_14,
                      color: currentTheme.colorScheme.onPrimary,
                      // size: 40,
                    ).pOnly(left: 10, top: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        "${widget.orderModel.customerName} ${widget.orderModel.customerPhone}"
                            .text
                            .textStyle(const TextStyle(fontSize: 10))
                            .color(currentTheme.colorScheme.tertiaryFixed)
                            .make(),
                        SizedBox(
                                width: Get.width * 0.6,
                                height: Get.height * 0.05,
                                child:
                                    "${widget.orderModel.customerAddress}, ${widget.orderModel.customerStreet}."
                                        .text
                                        .color(currentTheme
                                            .colorScheme.tertiaryFixed)
                                        .make())
                            .pOnly(top: 2),
                      ],
                    ).pOnly(top: 10, left: 10)
                  ],
                ),
              ),
            ).pOnly(top: 0),
            SizedBox(
              width: Get.width,
              height: Get.height * 0.15,
              child: Card(
                color: currentTheme.primaryColorLight,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    CatalogImage(image: widget.orderModel.productImages[0]),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            widget.orderModel.productName.text.bold
                                .textStyle(const TextStyle(fontSize: 11))
                                .overflow(TextOverflow.ellipsis)
                                .color(currentTheme.colorScheme.onPrimary)
                                .make()
                                .pOnly(right: 10),
                            4.heightBox,
                            Row(
                              children: [
                                FutureBuilder<String>(
                                  future: fetchBrandImageUrl(
                                      widget.orderModel.brandId),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      print(snapshot.error);
                                      return const Icon(Icons.error);
                                    } else {
                                      return CachedNetworkImage(
                                        imageUrl: snapshot.data!,
                                        width: 16,
                                        height: 16,
                                        placeholder: (context, url) =>
                                            const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      );
                                    }
                                  },
                                ),
                                Container(
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.only(left: 2),
                                    child: widget.orderModel.brandName
                                        .text
                                        .textStyle(const TextStyle(fontSize: 10))
                                        .align(TextAlign.left)
                                        .color(
                                            currentTheme.colorScheme.tertiary)
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
                            "Color : ${widget.orderModel.productColor}"
                                .text
                                .textStyle(const TextStyle(fontSize: 10))
                                .light
                                .overflow(TextOverflow.ellipsis)
                                .color(currentTheme.colorScheme.tertiary)
                                .make()
                                .pOnly(right: 10),
                            // 10.0.heightBox,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(0),
                                  // height: Get.height * 0.05,
                                  child: widget.orderModel.isSale
                                      ? "Rs ${widget.orderModel.salePrice}"
                                          .text
                                          .bold
                                          .textStyle(const TextStyle(fontSize: 10))
                                          .make()
                                      : "Rs ${widget.orderModel.fullPrice}"
                                          .text
                                          .bold
                                          .textStyle(const TextStyle(fontSize: 10))
                                          .make(),
                                ),
                                "Qty : ${widget.orderModel.productQuantity}"
                                    .text
                                    .bold
                                    .textStyle(const TextStyle(fontSize: 10))
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
              ),
            ),
            SizedBox(
              width: Get.width,
              height: Get.height * 0.6,
              child: Card(
                color: currentTheme.primaryColorLight,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    "Order Summary"
                        .text
                        .bold
                        .color(currentTheme.colorScheme.tertiaryFixed)
                        .make(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        "Order Id"
                            .text
                            .textStyle(const TextStyle(fontSize: 9))
                            .color(currentTheme.colorScheme.tertiaryFixed)
                            .make(),
                        widget.orderModel.orderId.text
                            .textStyle(const TextStyle(fontSize: 11))
                            .color(currentTheme.colorScheme.tertiaryFixed)
                            .overflow(TextOverflow.ellipsis)
                            .make().w(Get.width*0.3)
                            .pOnly(right: 10)
                      ],
                    ).pOnly(left: 0, top: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        "Placed on"
                            .text
                            .textStyle(const TextStyle(fontSize: 9))
                            .color(currentTheme.colorScheme.tertiaryFixed)
                            .make(),
                        (orderDay)
                            .text
                            .textStyle(const TextStyle(fontSize: 11))
                            .color(currentTheme.colorScheme.tertiaryFixed)
                            .make()
                            .pOnly(right: 10)
                      ],
                    ).pOnly(left: 0, top: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        "Shipping Date"
                            .text
                            .textStyle(const TextStyle(fontSize: 9))
                            .color(currentTheme.colorScheme.tertiaryFixed)
                            .make(),
                        shippingDay2.text
                            .textStyle(const TextStyle(fontSize: 11))
                            .color(currentTheme.colorScheme.tertiaryFixed)
                            .make()
                            .pOnly(right: 10)
                      ],
                    ).pOnly(left: 0, top: 4),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        "Payment Method"
                            .text
                            .textStyle(const TextStyle(fontSize: 9))
                            .color(currentTheme.colorScheme.tertiaryFixed)
                            .make(),
                        (widget.orderModel.payOption == 'Cash')
                            ? ("Cash on delivery")
                                .text
                                .textStyle(const TextStyle(fontSize: 11))
                                .color(currentTheme.colorScheme.tertiaryFixed)
                                .make()
                                .pOnly(right: 10)
                            : ("Card")
                                .text
                                .textStyle(const TextStyle(fontSize: 11))
                                .color(currentTheme.colorScheme.tertiaryFixed)
                                .make()
                                .pOnly(right: 10)
                      ],
                    ).pOnly(left: 0, top: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        "subTotal"
                            .text
                            .textStyle(const TextStyle(fontSize: 9))
                            .color(currentTheme.colorScheme.tertiaryFixed)
                            .make(),
                        ("Rs ${widget.orderModel.productTotalPrice}")
                            .text
                            .textStyle(const TextStyle(fontSize: 11))
                            .color(currentTheme.colorScheme.tertiaryFixed)
                            .make()
                            .pOnly(right: 10)
                      ],
                    ).pOnly(left: 0, top: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        "Delivery Fee"
                            .text
                            .textStyle(const TextStyle(fontSize: 9))
                            .color(currentTheme.colorScheme.tertiaryFixed)
                            .make(),
                        "Rs 200.0"
                            .text
                            .textStyle(const TextStyle(fontSize: 11))
                            .color(currentTheme.colorScheme.tertiaryFixed)
                            .make()
                            .pOnly(right: 10)
                      ],
                    ).pOnly(left: 0, top: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        "TAX Fee"
                            .text
                            .textStyle(const TextStyle(fontSize: 9))
                            .color(currentTheme.colorScheme.tertiaryFixed)
                            .make(),
                        ("Rs ${(widget.orderModel.productTotalPrice * 0.015).toStringAsFixed(1)}")
                            .text
                            .textStyle(const TextStyle(fontSize: 11))
                            .color(currentTheme.colorScheme.tertiaryFixed)
                            .make()
                            .pOnly(right: 10)
                      ],
                    ).pOnly(left: 0, top: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        "Order Total"
                            .text
                            .textStyle(const TextStyle(fontSize: 13))
                            .color(currentTheme.colorScheme.tertiary)
                            .semiBold
                            .make(),
                        ("Rs ${((widget.orderModel.productTotalPrice) - (widget.orderModel.productTotalPrice * 0.015) - 200).toStringAsFixed(1)} ")
                            .text
                            .semiBold
                            .textStyle(const TextStyle(fontSize: 13))
                            .make()
                            .pOnly(right: 10)
                      ],
                    ).pOnly(left: 0, top: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: Container(
                            color: Colors.transparent,
                            child: TextButton(
                              style: ButtonStyle(
                                  foregroundColor: const WidgetStatePropertyAll(
                                      Colors.transparent),
                                  backgroundColor: WidgetStateProperty.all(
                                      currentTheme.colorScheme.onPrimary),
                                  shape: const WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)))),
                                  overlayColor: WidgetStatePropertyAll(
                                      currentTheme.colorScheme.primary)),
                              onPressed: () {
                                Get.to(() => const NavigationMenu());
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  "Back To Home"
                                      .text
                                      .color(currentTheme.primaryColor)
                                      .make(),
                                  Icon(
                                    Iconsax.home,
                                    color: currentTheme.primaryColor,
                                  ).pOnly(left: 10)
                                ],
                              ),
                            ).wh((Get.width * 0.8), (Get.height / 16)),
                          ),
                        ).pOnly(top: 15),
                        Material(
                          color: Colors.transparent,
                          child: Container(
                            color: Colors.transparent,
                            child: TextButton(
                              style: ButtonStyle(
                                  foregroundColor: const WidgetStatePropertyAll(
                                      Colors.transparent),
                                  backgroundColor: WidgetStateProperty.all(
                                      currentTheme.primaryColorDark),
                                  shape: const WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)))),
                                  overlayColor: WidgetStatePropertyAll(
                                      currentTheme.colorScheme.primary)),
                              onPressed: () {
                                askQuestionOnWhatsapp(
                                    orderModel: widget.orderModel);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  "Chat With Us"
                                      .text
                                      .color(currentTheme.colorScheme.onPrimary)
                                      .make(),
                                  Icon(
                                    Iconsax.message,
                                    color: currentTheme.colorScheme.onPrimary,
                                  ).pOnly(left: 10)
                                ],
                              ),
                            ).wh((Get.width * 0.8), (Get.height / 16)),
                          ),
                        ).pOnly(top: 10),
                      ],
                    ).pOnly(left: 20, top: 20),

                    // "Order Details"
                    //     .text
                    //     .bold
                    //     .color(currentTheme.colorScheme.tertiaryFixed)
                    //     .make()
                    //     .pOnly(top: 30),
                  ],
                ).pOnly(left: 10, top: 10),
              ),
            )
          ],
        ).pOnly(top: 20),
      ),
    );
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
  final shippingDayFormatted = DateFormat('dd-MMM').format(shippingDay);

  return shippingDayFormatted;
}

String calculateShippingDay2(String deliveryTime, Timestamp createdAt) {
  // Extract the number of days from the deliveryTime string
  final days = int.parse(deliveryTime.replaceAll(RegExp(r'[^0-9]'), ''));

  // Convert the Firebase Timestamp to DateTime
  final orderDate = createdAt.toDate();

  // Calculate the shipping day by adding the extracted days
  final shippingDay = orderDate.add(Duration(days: days));

  // Format the shipping day into a readable string
  final shippingDayFormatted = DateFormat('dd MMMM yyyy').format(shippingDay);

  return shippingDayFormatted;
}

Future<void> askQuestionOnWhatsapp({required OrderModel orderModel}) async {
  const number = '+923112709619';
  final message = "Hello Deebugs \n I want to know about my order ${orderModel.orderId}";

  final url = 'https://wa.me/$number?text=${Uri.encodeComponent(message)}';
  try {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw "Could not launch $url";
    }
  } catch (e) {
    print("Error: $e");
  }
}