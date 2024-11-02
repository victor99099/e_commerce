import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/cart-model.dart';
import 'package:flutter_application_1/models/product-model.dart';
import 'package:flutter_application_1/utils/app-constant.dart';
import 'package:flutter_application_1/widgets/SuggestionSliderWidget.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../controllers/ReviewControllwe.dart';
import '../../controllers/wishlistController.dart';
import '../../models/product-review-model.dart';
import '../../utils/ProductColors.dart';

class ProductDetailScreen extends StatefulWidget {
  ProductModel productModel;
  ProductDetailScreen({super.key, required this.productModel});

  @override
  State<ProductDetailScreen> createState() => _ProductdetailscreenState();
}

class _ProductdetailscreenState extends State<ProductDetailScreen> {
  ProductReviewController reviewController = Get.put(ProductReviewController());
  RxString selectedOption = ''.obs;
  final PageController _pageController = PageController(viewportFraction: 1);
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    _autoScrollTimer =
        Timer.periodic(const Duration(seconds: 3), (timer) => _autoScroll());
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    super.dispose();
  }

  void _autoScroll() {
    if (_pageController.page == widget.productModel.productImages.length - 1) {
      _pageController.jumpToPage(0); // Jump to the first slide
    } else {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    RxInt incquantity = 1.obs;
    final bool isSale = widget.productModel.isSale;
    WishlistController wishlistController = Get.put(WishlistController());

    final currentTheme = Theme.of(context);
    User? user = FirebaseAuth.instance.currentUser;
    wishlistController.checkIfProductInWishlist(
        productId: widget.productModel.productId, uId: user!.uid);
    return WillPopScope(
        onWillPop: () async {
          // Custom back button logic
          _pageController.jumpTo(0); // Example: Reset the page controller
          Get.back(); // Go back to the previous screen
          return false; // Return false to prevent the default back action
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            actions: [
              Obx(
                () => Opacity(
                  opacity: 0.7,
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    color: currentTheme.colorScheme.surface,
                    child: IconButton(
                      icon: wishlistController
                              .isFav(widget.productModel.productId)
                          ? const Icon(Iconsax.heart5)
                          : const Icon(Iconsax.heart),
                      color: wishlistController
                              .isFav(widget.productModel.productId)
                          ? Colors.red
                          : currentTheme.colorScheme.onPrimary,
                      onPressed: () {
                        wishlistController.toggleWishlistStatus(
                            uId: user.uid, productModel: widget.productModel);
                      },
                    ),
                  ).pOnly(right: 20, bottom: 4),
                ),
              ),
            ],
            iconTheme: IconThemeData(color: currentTheme.colorScheme.tertiary),
            backgroundColor: currentTheme.primaryColorLight,
            // title: "Details".text.color(currentTheme.colorScheme.tertiary).bold.make(),
          ),
          body: Container(
            color: currentTheme.primaryColorLight,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // slider
                  Container(
                    width: Get.width ,
                    height: Get.height / 3,
                    color: currentTheme.primaryColorLight,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: widget.productModel.productImages.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: Vx.m0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Hero(
                              tag: Key(widget.productModel.productId),
                              child: CachedNetworkImage(
                                imageUrl:
                                    widget.productModel.productImages[index],
                                fit: BoxFit.contain,
                                width: Get.width - 10, // Adjust width if needed
                                placeholder: (context, url) => const ColoredBox(
                                  color: Colors.grey,
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  //slider end
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: Card(
                      color: currentTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 20,
                      shadowColor: currentTheme.colorScheme.tertiaryFixed,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Container(
                                width: Get.width,
                                height: Get.height * 0.01,
                                alignment: Alignment.topRight,
                                padding: const EdgeInsets.only(right: 10),
                                child: IconButton(
                                    onPressed: () {
                                      print('Button Pressed');
                                    },
                                    icon: Icon(
                                      Icons.share,
                                      color: currentTheme
                                          .colorScheme.tertiaryFixed,
                                    ))),
                            5.heightBox,
                            Container(
                              padding: const EdgeInsets.only(left: 10),
                              alignment: Alignment.topLeft,
                              child: FutureBuilder<Map<String, dynamic>>(
                                future: reviewController
                                    .calculateAverageRatingAndReviewCount(
                                        widget.productModel.productId),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator(); // Loading indicator while waiting
                                  } else if (snapshot.hasError) {
                                    return Text(
                                        'Error: ${snapshot.error}'); // Display error message if any
                                  } else if (!snapshot.hasData ||
                                      snapshot.data == null) {
                                    return const Text(
                                        'No reviews available'); // Handle case with no data
                                  } else {
                                    final averageRating = snapshot
                                        .data!['averageRating'] as double;
                                    final reviewCount =
                                        snapshot.data!['reviewCount'] as int;
                                    return Row(
                                      children: [
                                        const Icon(
                                          Iconsax.star5,
                                          color: Colors.amber,
                                        ),
                                        Text(
                                            '${averageRating.toStringAsFixed(1)} ($reviewCount)'),
                                      ],
                                    );
                                  }
                                },
                              ),
                            ),
                            10.heightBox,
                            isSale
                                ? Container(
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Row(
                                      children: [
                                        "Rs ${widget.productModel.salePrice}"
                                            .text
                                            .xl2
                                            .align(TextAlign.left)
                                            .color(currentTheme
                                                .colorScheme.onPrimary)
                                            .make(),
                                        15.widthBox,
                                        widget.productModel.fullPrice
                                            .text
                                            .xl2
                                            .align(TextAlign.left)
                                            .color(currentTheme
                                                .colorScheme.tertiary)
                                            .textStyle(const TextStyle(
                                                decoration:
                                                    TextDecoration.lineThrough))
                                            .make(),
                                      ],
                                    ))
                                : Container(
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.only(left: 10),
                                    child: "Rs ${widget.productModel.fullPrice}"
                                        .text
                                        .xl2
                                        .align(TextAlign.left)
                                        .color(
                                            currentTheme.colorScheme.onPrimary)
                                        .make()),
                            5.heightBox,
                            Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 10),
                                child: widget.productModel.productName
                                    .text
                                    .textStyle(const TextStyle(fontSize: 16))
                                    .align(TextAlign.left)
                                    .color(currentTheme.colorScheme.tertiary)
                                    .make()),
                            5.heightBox,
                            Row(
                              children: [
                                "stock : "
                                    .text
                                    .textStyle(const TextStyle(fontSize: 12))
                                    .make(),
                                "In Stock"
                                    .text
                                    .bold
                                    .textStyle(const TextStyle(fontSize: 14))
                                    .make()
                              ],
                            ).pOnly(left: 10),
                            Row(
                              children: [
                                "Delivey time : "
                                    .text
                                    .textStyle(const TextStyle(fontSize: 12))
                                    .make(),
                                widget.productModel.deliveryTime
                                    .text
                                    .bold
                                    .textStyle(const TextStyle(fontSize: 14))
                                    .make()
                              ],
                            ).pOnly(left: 10),
                            10.heightBox,
                            Row(
                              children: [
                                FutureBuilder<String>(
                                  future: fetchBrandImageUrl(
                                      widget.productModel.brandId),
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
                                        width: 25,
                                        height: 25,
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
                                    padding: const EdgeInsets.only(left: 10),
                                    child: widget.productModel.brandName
                                        .text
                                        .textStyle(const TextStyle(fontSize: 15))
                                        .align(TextAlign.left)
                                        .color(
                                            currentTheme.colorScheme.tertiary)
                                        .make()),
                                Image.asset(
                                  'assets/images/verifiedicon.png', // Replace with your icon path
                                  width: 12,
                                  height: 12,
                                  // color: Colors.white,
                                ).pOnly(left: 7),
                              ],
                            ).pOnly(left: 10),
                            10.heightBox,
                            5.heightBox,
                            Row(
                              children: [
                                Container(
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.only(left: 10),
                                    child: "Colors : "
                                        .text
                                        .bold
                                        .textStyle(const TextStyle(fontSize: 16))
                                        .align(TextAlign.left)
                                        .color(
                                            currentTheme.colorScheme.tertiary)
                                        .make()),
                                SizedBox(
                                  height: Get.height * 0.05,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: widget
                                        .productModel.productColors.length,
                                    itemBuilder: (context, index) {
                                      String colorName = widget
                                          .productModel.productColors[index];
                                      Color color = ColorUtils.getColorFromName(
                                          colorName);
                                      selectedOption.value =
                                          widget.productModel.productColors[0];
                                      return Row(
                                        children: [
                                          Obx(
                                            () => SizedBox(
                                              width: Get.width * 0.12,
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  side: selectedOption.value ==
                                                          widget.productModel
                                                                  .productColors[
                                                              index]
                                                      ? BorderSide(
                                                          color: currentTheme
                                                              .colorScheme
                                                              .tertiary,
                                                          width: 2)
                                                      : const BorderSide(
                                                          color: Colors
                                                              .transparent,
                                                          width: 4),
                                                ),
                                                child: Stack(
                                                  alignment: Alignment
                                                      .center, // Centering the content
                                                  children: [
                                                    IconButton(
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                            WidgetStateProperty
                                                                .all(color),
                                                      ),
                                                      onPressed: () {
                                                        selectedOption
                                                            .value = widget
                                                                .productModel
                                                                .productColors[
                                                            index];
                                                      },
                                                      icon: const SizedBox
                                                          .shrink(), // Empty icon to clear default icon
                                                    ),
                                                    if (selectedOption.value ==
                                                        widget.productModel
                                                                .productColors[
                                                            index])
                                                      const Icon(
                                                        Icons.check,
                                                        color: Colors.white,
                                                      )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            20.heightBox,
                            Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 10),
                                child: "Details"
                                    .text
                                    .bold
                                    .textStyle(const TextStyle(fontSize: 16))
                                    .align(TextAlign.left)
                                    .color(currentTheme.colorScheme.tertiary)
                                    .make()),
                            5.heightBox,
                            Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 10),
                                child:
                                    widget.productModel.productDescription
                                        .text
                                        .textStyle(const TextStyle(fontSize: 10))
                                        .align(TextAlign.left)
                                        .color(currentTheme
                                            .colorScheme.tertiaryFixed)
                                        .make()),
                            40.heightBox,
                            Row(
                              children: [
                                const Icon(
                                  Iconsax.star5,
                                  color: Colors.amber,
                                ),
                                Container(
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.only(left: 10),
                                    child: "Rating & Reviews"
                                        .text
                                        .bold
                                        .textStyle(const TextStyle(fontSize: 16))
                                        .align(TextAlign.left)
                                        .color(
                                            currentTheme.colorScheme.tertiary)
                                        .make()),
                                5.heightBox,
                                Container(
                                  padding: const EdgeInsets.only(left: 10),
                                  alignment: Alignment.topLeft,
                                  child: FutureBuilder<Map<String, dynamic>>(
                                    future: reviewController
                                        .calculateAverageRatingAndReviewCount(
                                            widget.productModel.productId),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator(); // Loading indicator while waiting
                                      } else if (snapshot.hasError) {
                                        return Text(
                                            'Error: ${snapshot.error}'); // Display error message if any
                                      } else if (!snapshot.hasData ||
                                          snapshot.data == null) {
                                        return const Text(
                                            'No reviews available'); // Handle case with no data
                                      } else {
                                        final averageRating = snapshot
                                            .data!['averageRating'] as double;
                                        final reviewCount = snapshot
                                            .data!['reviewCount'] as int;
                                        return Row(
                                          children: [
                                            Text('($reviewCount)'),
                                          ],
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            15.heightBox,
                            Container(
                              child: FutureBuilder(
                                  future: reviewController.fetchProductReviews(
                                      widget.productModel.productId),
                                  builder: (BuildContext context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    } else if (snapshot.hasError) {
                                      return Center(
                                          child: Text(
                                              "Error fetching reviews: ${snapshot.error}"));
                                    } else if (!snapshot.hasData ||
                                        snapshot.data!.isEmpty) {
                                      return const Center(
                                          child: Text("No reviews available."));
                                    } else {
                                      // Reviews are successfully fetched
                                      List<ProductReviewModel> reviews =
                                          snapshot.data!;

                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 8),
                                        child: ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: reviews.length,
                                          itemBuilder: (context, index) {
                                            final review = reviews[index];
                                            return SizedBox(
                                              width: Get.width * 0.9,
                                              height: Get.height / 4.5,
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 40,
                                                        height: 40,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(50),
                                                          child: Image.network(
                                                              review.userImage),
                                                        ),
                                                      ),
                                                      Text(
                                                        review.userName,
                                                        style: const TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ).pOnly(left: 15)
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      RatingBar.builder(
                                                          itemSize: 20,
                                                          ignoreGestures: true,
                                                          glow: false,
                                                          itemPadding:
                                                              const EdgeInsets.all(0),
                                                          // glowColor: Colors.transparent,
                                                          initialRating:
                                                              review.rating,
                                                          minRating: 1,
                                                          direction:
                                                              Axis.horizontal,
                                                          allowHalfRating: true,
                                                          itemBuilder:
                                                              (context, _) {
                                                            return Icon(
                                                              Icons.star,
                                                              color: currentTheme
                                                                  .colorScheme
                                                                  .onPrimary,
                                                            );
                                                          },
                                                          onRatingUpdate:
                                                              (rating) {}),
                                                      Text(
                                                        DateFormat(
                                                                'dd-MMM-yyyy')
                                                            .format(review
                                                                .updatedAt
                                                                .toDate()),
                                                        style: TextStyle(
                                                            color: currentTheme
                                                                .colorScheme
                                                                .tertiaryFixed),
                                                      ).pOnly(left: 10)
                                                    ],
                                                  ).pOnly(top: 10),
                                                  SizedBox(
                                                      width: Get.width * 0.9,
                                                      height: Get.height / 12,
                                                      child: Text(
                                                        review.feedback,
                                                        overflow:
                                                            TextOverflow.fade,
                                                      )).pOnly(top: 12, left: 3),
                                                  // Divider(endIndent: 20,indent: 20,color: currentTheme.colorScheme.onTertiary,)
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    }
                                  }),
                            ),
                            25.heightBox,
                            Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 10),
                                child: "You may like"
                                    .text
                                    .bold
                                    .textStyle(const TextStyle(fontSize: 16))
                                    .align(TextAlign.left)
                                    .color(currentTheme.colorScheme.tertiary)
                                    .make()),
                            SuggestionSlider(
                                categoryId: widget.productModel.categoryId)
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            color: currentTheme.primaryColor,
            // margin: EdgeInsets.only(right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 20),
                  margin: const EdgeInsets.only(right: 20, top: 5),
                  height: Get.height * 0.045,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(0),
                        padding: const EdgeInsets.all(0),
                        width: Get.width / 10,
                        height: Get.height * 0.045,
                        child: Card(
                          margin: const EdgeInsets.all(1),
                          color: MyTheme.dark,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          elevation: 3,
                          child: TextButton(
                            onPressed: () {
                              if (incquantity == 0) {
                              } else {
                                incquantity.value = incquantity.value - 1;
                              }
                            },
                            child: Container(
                                child: "-"
                                    .text
                                    .bold
                                    .textStyle(const TextStyle(fontSize: 8))
                                    .color(currentTheme.colorScheme.primary)
                                    .make()),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: Get.width / 10,
                        height: Get.height * 0.045,
                        child: Card(
                            margin: const EdgeInsets.all(1),
                            color: currentTheme.colorScheme.surface,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            elevation: 3,
                            child: Obx(
                              () => Text(
                                '$incquantity',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: currentTheme.colorScheme.onPrimary),
                              ).pOnly(top: 5),
                            )),
                      ).pOnly(left: 5),
                      Container(
                        margin: const EdgeInsets.all(0),
                        padding: const EdgeInsets.all(0),
                        width: Get.width / 10,
                        height: Get.height * 0.045,
                        child: Card(
                          margin: const EdgeInsets.all(1),
                          color: MyTheme.dark,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          elevation: 3,
                          child: TextButton(
                            onPressed: () {
                              incquantity.value = incquantity.value + 1;
                            },
                            child: Container(
                                child: "+"
                                    .text
                                    .bold
                                    .textStyle(const TextStyle(fontSize: 8))
                                    .color(currentTheme.colorScheme.primary)
                                    .make()),
                          ),
                        ),
                      ).pOnly(left: 5),
                    ],
                  ),
                ),
                SizedBox(
                  width: Get.width / 2.5,
                  height: Get.height * 0.07,
                  child: Card(
                    color: MyTheme.dark,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    elevation: 3,
                    child: TextButton(
                        style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                                MyTheme.dark)),
                        onPressed: () async {
                          // showModalBottomSheet(
                          //   isScrollControlled: true,
                          //   context: context,
                          //   builder: (BuildContext context) {
                          //     return DraggableScrollableSheet(
                          //       initialChildSize:
                          //           0.75, // Adjust this value to increase the initial size
                          //       minChildSize:
                          //           0.5, // The minimum size when dragged down
                          //       maxChildSize:
                          //           1.0, // The maximum size when fully expanded
                          //       expand: false,
                          //       builder: (context, scrollController) {
                          //         return ReviewSheet(
                          //             productId: widget.productModel.productId);
                          //       },
                          //     );
                          //   },
                          // );
                          await checkProductExistance(
                            color: selectedOption.value,
                              uId: user.uid,
                              quantityIncrement: incquantity.value);
                          incquantity.value.isEqual(0)
                              ? ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                  content: Text(
                                    'Select quantity',
                                    style: TextStyle(
                                        color:
                                            currentTheme.colorScheme.surface),
                                  ),
                                  backgroundColor:
                                      currentTheme.colorScheme.onPrimary,
                                ))
                              : ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                  content: Text(
                                    'Added to cart',
                                    style: TextStyle(
                                        color:
                                            currentTheme.colorScheme.surface),
                                  ),
                                  backgroundColor:
                                      currentTheme.colorScheme.onPrimary,
                                ));
                        },
                        child: Row(
                          children: [
                            "Add to cart".text.color(Colors.white).make(),
                            5.widthBox,
                            const Icon(
                              CupertinoIcons.cart_badge_plus,
                              color: Colors.white,
                            )
                          ],
                        )),
                  ),
                ).pOnly(right: 12)
              ],
            ),
          ),
        ));
  }

  Future<void> checkProductExistance(
      {required String uId, required int quantityIncrement, required String color}) async {
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection("cart")
        .doc(uId)
        .collection("cartOrders")
        .doc(widget.productModel.productId.toString());
    DocumentSnapshot snapshot = await documentReference.get();

    if (snapshot.exists) {
      var currentQuantity = snapshot["productQuantity"];
      int updatedQuantity = currentQuantity + quantityIncrement;
      double totalPrice = double.parse(widget.productModel.isSale
              ? widget.productModel.salePrice.replaceAll(',', '')
              : widget.productModel.fullPrice.replaceAll(',', '')) *
          updatedQuantity;
      await documentReference.update({
        'productQuantity': updatedQuantity,
        'productTotalPrice': totalPrice
      });
      print("Product Exists");
    } else {
      await FirebaseFirestore.instance
          .collection('cart')
          .doc(uId)
          .set({"uId": uId, 'createedAt': DateTime.now()});
      CartModel cartModel = CartModel(
          brandId: widget.productModel.brandId,
          brandName: widget.productModel.brandName,
          productColors: widget.productModel.productColors,
          productId: widget.productModel.productId,
          categoryId: widget.productModel.categoryId,
          productName: widget.productModel.productName,
          categoryName: widget.productModel.categoryName,
          salePrice: widget.productModel.salePrice,
          fullPrice: widget.productModel.fullPrice,
          productImages: widget.productModel.productImages,
          deliveryTime: widget.productModel.deliveryTime,
          isSale: widget.productModel.isSale,
          isBest: widget.productModel.isBest,
          productDescription: widget.productModel.productDescription,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          productQuantity: quantityIncrement,
          productColor: color,
          productTotalPrice: double.parse(widget.productModel.isSale
              ? widget.productModel.salePrice.replaceAll(',', '')
              : widget.productModel.fullPrice.replaceAll(',', '')));
      await documentReference.set(cartModel.toMap());
      print("Product Added");
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
}
