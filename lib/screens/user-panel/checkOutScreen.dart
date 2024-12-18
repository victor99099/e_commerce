import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/CartPriceController.dart';
import 'package:flutter_application_1/controllers/OrderIdController.dart';
import 'package:flutter_application_1/controllers/deviceTokenController.dart';
import 'package:flutter_application_1/models/order-model.dart';
import 'package:flutter_application_1/models/product-model.dart';
import 'package:flutter_application_1/screens/user-panel/ProductDetailScreen.dart';
import 'package:flutter_application_1/screens/user-panel/mainScreen.dart';
import 'package:flutter_application_1/screens/user-panel/navigationMenu.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/list_notifier.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_card/image_card.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../controllers/validateInfoController.dart';
import '../../models/cart-model.dart';
import '../../models/user-model.dart';
import 'PersonalInfoScreen.dart';

class CheckoutScreen extends StatefulWidget {
  String total = '';
  CheckoutScreen({super.key, required this.total});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  Razorpay _razorpay = Razorpay();
  final UserValidationController validationController =
      Get.put(UserValidationController());

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController noteToRider = TextEditingController();
    RxString payOption = 'Cash'.obs;
    final currentTheme = Theme.of(context);
    User? user = FirebaseAuth.instance.currentUser;
    final PriceController priceController = Get.put(PriceController());

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: currentTheme.colorScheme.tertiary),
        backgroundColor: currentTheme.colorScheme.surface,
        title: "Checkout"
            .text
            .color(currentTheme.colorScheme.tertiary)
            .bold
            .make(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CartItems(
                user: user,
                priceController: priceController,
                currentTheme: currentTheme),
            UserDetails(
                currentTheme: currentTheme,
                user: user,
                noteToRider: noteToRider),
            PaymentOptions(currentTheme: currentTheme, payOption: payOption),
            Container(
              width: Get.width / 1.1,
              height: Get.height / 2.6,
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Iconsax.shopping_bag,
                            color: currentTheme.colorScheme.tertiaryFixed,
                          ),
                          "Order Details"
                              .text
                              .xl
                              .bold
                              .color(currentTheme.colorScheme.tertiaryFixed)
                              .make()
                              .pOnly(left: 10),
                        ],
                      ).pOnly(left: 12, top: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          "subTotal"
                              .text
                              .textStyle(TextStyle(fontSize: 9))
                              .color(currentTheme.colorScheme.tertiaryFixed)
                              .make(),
                          ("Rs ${widget.total}")
                              .text
                              .textStyle(TextStyle(fontSize: 11))
                              .make()
                              .pOnly(right: 30)
                        ],
                      ).pOnly(left: 20, top: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          "Delivery Fee"
                              .text
                              .textStyle(TextStyle(fontSize: 9))
                              .color(currentTheme.colorScheme.tertiaryFixed)
                              .make(),
                          "Rs 200.0"
                              .text
                              .textStyle(TextStyle(fontSize: 11))
                              .make()
                              .pOnly(right: 30)
                        ],
                      ).pOnly(left: 20, top: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          "TAX Fee"
                              .text
                              .textStyle(TextStyle(fontSize: 9))
                              .color(currentTheme.colorScheme.tertiaryFixed)
                              .make(),
                          ("Rs ${(double.parse(widget.total) * 0.015).toStringAsFixed(1)}")
                              .text
                              .textStyle(TextStyle(fontSize: 11))
                              .make()
                              .pOnly(right: 30)
                        ],
                      ).pOnly(left: 20, top: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          "Order Total"
                              .text
                              .textStyle(TextStyle(fontSize: 16))
                              .color(currentTheme.colorScheme.tertiaryFixed)
                              .make(),
                          ("Rs ${((double.parse(widget.total)) - (double.parse(widget.total) * 0.015) - 200).toStringAsFixed(1)} ")
                              .text
                              .semiBold
                              .textStyle(TextStyle(fontSize: 16))
                              .make()
                              .pOnly(right: 27)
                        ],
                      ).pOnly(left: 20, top: 20),
                      Container(
                        margin: EdgeInsets.all(0),
                        padding: EdgeInsets.all(0),
                        width: Get.width - 10,
                        height: Get.height * 0.07,
                        child: Card(
                          color: currentTheme.colorScheme.secondary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 5,
                          child: TextButton(
                            onPressed: () async {
                              final amount = ((double.parse(widget.total)) -
                                  (double.parse(widget.total) * 0.015) -
                                  200);
                              if (validationController.isInfoComplete.value) {
                                if (payOption.value == 'Card') {
                                  var options = {
                                    'key': 'rzp_test_xVMqJrZKp1cCoE',
                                    'amount': amount * 100,
                                    'name': user!.displayName,
                                    'description': '',
                                    'currency': 'PKR',
                                    'prefill': {
                                      'contact': user.phoneNumber,
                                      'email': user.email
                                    }
                                  };
                                  _razorpay.open(options);
                                  _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
                                      (PaymentSuccessResponse response) {
                                    _handlePaymentSuccess(
                                        response,
                                        noteToRider.text,
                                        context,
                                        payOption.value,
                                        amount);
                                  });
                                  _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
                                      _handlePaymentErrorWrapper);
                                  _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
                                      _handleExternalWallet);
                                } else {
                                  placeOrder(
                                      noteToRider: noteToRider.text,
                                      context: context,
                                      payOption: payOption.value,
                                      amount: amount);
                                }
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                    'Please provide the complete address details',
                                    style: TextStyle(
                                        color:
                                            currentTheme.colorScheme.surface),
                                  ),
                                  backgroundColor:
                                      currentTheme.colorScheme.onPrimary,
                                ));
                              }
                            },
                            child: Center(
                                child: "Place Order"
                                    .text
                                    .color(currentTheme.colorScheme.primary)
                                    .make()),
                          ),
                        ),
                      ).pOnly(top: 25),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

void _handlePaymentSuccess(PaymentSuccessResponse response, String noteToRider,
    BuildContext context, String payOption, dynamic amount) {
  placeOrder(
      noteToRider: noteToRider,
      context: context,
      payOption: payOption,
      amount: amount);
}

void _handlePaymentErrorWrapper(PaymentFailureResponse response) {
  // Access the current context and call the error handler with the context
  _handlePaymentError(response);
}

void _handlePaymentError(PaymentFailureResponse response) {
  final currentTheme = Theme.of(Get.context!);
  ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
    content: Text(
      'Error in payment processing, Please try again ...',
      style: TextStyle(color: currentTheme.colorScheme.surface),
    ),
    backgroundColor: currentTheme.colorScheme.onPrimary,
  ));
}

void _handleExternalWallet(ExternalWalletResponse response) {
  // Do something when an external wallet was selected
}

class PaymentOptions extends StatelessWidget {
  const PaymentOptions({
    super.key,
    required this.currentTheme,
    required this.payOption,
  });

  final ThemeData currentTheme;
  final RxString payOption;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width / 1.1,
      height: Get.height / 5.5,
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.account_balance_wallet_outlined,
                    color: currentTheme.colorScheme.tertiaryFixed,
                  ),
                  "Payment Method"
                      .text
                      .xl
                      .bold
                      .color(currentTheme.colorScheme.tertiaryFixed)
                      .make()
                      .pOnly(left: 10),
                ],
              ).pOnly(left: 12, top: 12),
              Row(
                children: [
                  Obx(
                    () => Row(
                      children: [
                        SizedBox(
                          width: Get.width * 0.35,
                          height: Get.height * 0.07,
                          child: InkWell(
                            onTap: () {
                              payOption.value = 'Cash';
                            },
                            child: Card(
                              color: payOption.value == 'Cash'
                                  ? currentTheme.colorScheme.onPrimary
                                  : currentTheme.colorScheme.surface,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    size: 20,
                                    Icons.payments_outlined,
                                    color: payOption.value == 'Cash'
                                        ? currentTheme.colorScheme.surface
                                        : currentTheme
                                            .colorScheme.tertiaryFixed,
                                  ),
                                  "Cash"
                                      .text
                                      .textStyle(TextStyle(fontSize: 10))
                                      .color(payOption.value == 'Cash'
                                          ? currentTheme.colorScheme.surface
                                          : currentTheme
                                              .colorScheme.tertiaryFixed)
                                      .make()
                                      .pOnly(left: 10),
                                ],
                              ),
                            ).pOnly(left: 15, top: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Obx(
                    () => Row(
                      children: [
                        SizedBox(
                          width: Get.width * 0.35,
                          height: Get.height * 0.07,
                          child: InkWell(
                            onTap: () {
                              payOption.value = 'Card';
                            },
                            child: Card(
                              color: payOption.value == 'Card'
                                  ? currentTheme.colorScheme.onPrimary
                                  : currentTheme.colorScheme.surface,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    size: 20,
                                    Icons.credit_card,
                                    color: payOption.value == 'Card'
                                        ? currentTheme.colorScheme.surface
                                        : currentTheme
                                            .colorScheme.tertiaryFixed,
                                  ),
                                  "Card"
                                      .text
                                      .textStyle(TextStyle(fontSize: 10))
                                      .color(payOption.value == 'Card'
                                          ? currentTheme.colorScheme.surface
                                          : currentTheme
                                              .colorScheme.tertiaryFixed)
                                      .make()
                                      .pOnly(left: 10),
                                ],
                              ),
                            ).pOnly(top: 12, right: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserDetails extends StatelessWidget {
  TextEditingController noteToRider = TextEditingController();
  UserDetails(
      {super.key,
      required this.currentTheme,
      required this.user,
      required this.noteToRider});

  final ThemeData currentTheme;
  final User? user;
  final UserValidationController validationController =
      Get.put(UserValidationController());
  @override
  Widget build(BuildContext context) {
    if (user != null) {
      validationController.validateUserInfo(user!.uid);
    }

    return Container(
      width: Get.width / 1.1,
      height: Get.height / 2.5,
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('uId', isEqualTo: user!.uid)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  print(snapshot);
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
                      child: "No Data Found".text.make(),
                    );
                  }

                  if (snapshot.data != null) {
                    final userData =
                        snapshot.data!.docs[0].data() as Map<String, dynamic>;

                    UserModel userModel = UserModel(
                        uId: userData['uId'],
                        username: userData['username'],
                        email: userData['email'],
                        phone: userData['phone'],
                        userImg: userData['userImg'],
                        userDeviceToken: userData['userDeviceToken'],
                        country: userData['country'],
                        userAddress: userData['userAddress'],
                        street: userData['street'],
                        isAdmin: userData['isAdmin'],
                        isActive: userData['isActive'],
                        createdOn: userData['createdOn'],
                        city: userData['city']);

                    validationController.isInfoComplete.value =
                        userModel.username.isNotEmpty &&
                            userModel.phone.isNotEmpty &&
                            userModel.city.isNotEmpty &&
                            userModel.street.isNotEmpty &&
                            userModel.userAddress.isNotEmpty;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.local_shipping_outlined,
                                        color: currentTheme
                                            .colorScheme.tertiaryFixed,
                                      ),
                                      "Address Details"
                                          .text
                                          .bold
                                          .xl
                                          .color(currentTheme
                                              .colorScheme.tertiaryFixed)
                                          .make()
                                          .pOnly(left: 10),
                                    ],
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        Get.to(() => UpdateUserInfoScreen(
                                              userModel: userModel,
                                            ));
                                      },
                                      icon: Icon(
                                        Iconsax.edit,
                                        color:
                                            currentTheme.colorScheme.onPrimary,
                                      ))
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  "Name"
                                      .text
                                      .color(currentTheme
                                          .colorScheme.tertiaryFixed)
                                      .make(),
                                  userModel.username.text
                                      .textStyle(TextStyle(fontSize: 10))
                                      .make()
                                      .pOnly(left: 62),
                                ],
                              ).pOnly(top: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  "Phone no"
                                      .text
                                      .color(currentTheme
                                          .colorScheme.tertiaryFixed)
                                      .make(),
                                  userModel.phone.text
                                      .textStyle(TextStyle(fontSize: 10))
                                      .make()
                                      .pOnly(left: 38),
                                ],
                              ).pOnly(top: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  "City"
                                      .text
                                      .color(currentTheme
                                          .colorScheme.tertiaryFixed)
                                      .make(),
                                  userModel.city.text
                                      .textStyle(TextStyle(fontSize: 10))
                                      .make()
                                      .pOnly(left: 77),
                                ],
                              ).pOnly(top: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  "Street"
                                      .text
                                      .color(currentTheme
                                          .colorScheme.tertiaryFixed)
                                      .make(),
                                  userModel.street.text
                                      .textStyle(TextStyle(fontSize: 10))
                                      .make()
                                      .pOnly(left: 63),
                                ],
                              ).pOnly(top: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  "Address"
                                      .text
                                      .color(currentTheme
                                          .colorScheme.tertiaryFixed)
                                      .make(),
                                  userModel.userAddress.text
                                      .overflow(TextOverflow.fade)
                                      .textStyle(TextStyle(fontSize: 10))
                                      .make()
                                      .pOnly(left: 47)
                                      .w(Get.width * 0.58),
                                ],
                              ).pOnly(top: 5),
                              TextFormField(
                                controller: noteToRider,
                                style: TextStyle(fontSize: 10),
                                maxLines: 2,
                                decoration: InputDecoration(
                                    labelText: "Note To Rider",
                                    labelStyle: TextStyle(
                                        fontSize: 10,
                                        color:
                                            currentTheme.colorScheme.tertiary),
                                    hintStyle: TextStyle(
                                        color: currentTheme
                                            .colorScheme.tertiaryFixed,
                                        fontSize: 10),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: currentTheme
                                                .colorScheme.tertiaryFixed)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: currentTheme
                                                .colorScheme.onPrimary)),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: currentTheme
                                                .colorScheme.tertiaryFixed)),
                                    hintText:
                                        "Note to Rider (for e.g landmark)"),
                              ).pOnly(top: 10)
                            ],
                          ),
                        )
                      ],
                    );
                  }
                  return Container();
                })
          ],
        ).pOnly(left: 10),
      ),
    );
  }
}

class CartItems extends StatelessWidget {
  const CartItems({
    super.key,
    required this.user,
    required this.priceController,
    required this.currentTheme,
  });

  final User? user;
  final PriceController priceController;
  final ThemeData currentTheme;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('cart')
          .doc(user!.uid)
          .collection('cartOrders')
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
                ListView.builder(
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
                        productDescription: productData['productDescription'],
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
                          productDescription: productData['productDescription'],
                          createdAt: productData['createdAt'],
                          updatedAt: productData['updatedAt'],
                          productQuantity: productData['productQuantity'],
                          productColor: productData['productColor'],
                          productTotalPrice: productData['productTotalPrice']);
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
                                  margin: EdgeInsets.all(0),
                                  height: Get.height / 6.5,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.delete, color: Colors.white),
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
                              color: Colors.transparent,
                              onTap: (handler) async {
                                // Perform the deletion
                                await FirebaseFirestore.instance
                                    .collection('cart')
                                    .doc(user!.uid)
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
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              elevation: 5,
                              child: VxBox(
                                child: Row(
                                  children: [
                                    CatalogImage(
                                        image: cartModel.productImages[0]),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.all(0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            cartModel.productName.text.bold
                                                .textStyle(
                                                    TextStyle(fontSize: 11))
                                                .overflow(TextOverflow.ellipsis)
                                                .color(currentTheme
                                                    .colorScheme.onPrimary)
                                                .make()
                                                .pOnly(right: 10),
                                            4.heightBox,
                                            Row(
                                              children: [
                                                FutureBuilder<String>(
                                                  future: fetchBrandImageUrl(
                                                      cartModel.brandId),
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return CircularProgressIndicator();
                                                    } else if (snapshot
                                                        .hasError) {
                                                      print(snapshot.error);
                                                      return Icon(Icons.error);
                                                    } else {
                                                      return CachedNetworkImage(
                                                        imageUrl:
                                                            snapshot.data!,
                                                        width: 16,
                                                        height: 16,
                                                        placeholder: (context,
                                                                url) =>
                                                            CircularProgressIndicator(),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Icon(Icons.error),
                                                      );
                                                    }
                                                  },
                                                ),
                                                Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    padding: EdgeInsets.only(
                                                        left: 2),
                                                    child:
                                                        "${cartModel.brandName}"
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
                                                  width: 8,
                                                  height: 8,
                                                  // color: Colors.white,
                                                ).pOnly(left: 2),
                                              ],
                                            ),
                                            4.heightBox,
                                            "Color : ${cartModel.productColor}"
                                                .text
                                                .textStyle(
                                                    TextStyle(fontSize: 10))
                                                .light
                                                .overflow(TextOverflow.ellipsis)
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
                                                  margin: EdgeInsets.all(0),
                                                  // height: Get.height * 0.05,
                                                  child:
                                                      "Rs ${cartModel.productTotalPrice}"
                                                          .text
                                                          .bold
                                                          .textStyle(TextStyle(
                                                              fontSize: 10))
                                                          .make(),
                                                ),
                                                "Qty : ${cartModel.productQuantity}"
                                                    .text
                                                    .bold
                                                    .textStyle(
                                                        TextStyle(fontSize: 10))
                                                    .make()
                                                    .pOnly(right: 20)
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                                  .color(currentTheme.colorScheme.surface)
                                  .rounded
                                  .square(Get.height / 9.35)
                                  .make()
                                  .py4(),
                            ),
                          ));
                    }),
                20.heightBox,
                // Obx(
                //   () => Container(
                //     margin: EdgeInsets.all(0),
                //     padding: EdgeInsets.all(0),
                //     width: Get.width - 10,
                //     child: Card(
                //       color: currentTheme.colorScheme.secondary,
                //       shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(10)),
                //       elevation: 5,
                //       child: TextButton(
                //         onPressed: () {
                //           // Get.to()
                //         },
                //         child: Center(
                //             child:
                //                 "${priceController.totalPrice.value.toStringAsFixed(1)} CheckOut"
                //                     .text
                //                     .color(currentTheme.colorScheme.primary)
                //                     .make()),
                //       ),
                //     ),
                //   ).pOnly(bottom: 20),
                // ),
              ],
            ),
          );
        }
        return Container();
      },
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
        .w24(context)
        .py4()
        .h10(context);
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

void placeOrder(
    {required String noteToRider,
    required BuildContext context,
    required String payOption,
    required double amount}) async {
  OrderIdController orderIdController = Get.put(OrderIdController());
  User? user = FirebaseAuth.instance.currentUser;
  final currentTheme = Theme.of(context);
  try {
    EasyLoading.show(status: "Please wait ...");
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    UserModel userModel = UserModel(
        uId: userData['uId'],
        username: userData['username'],
        email: userData['email'],
        phone: userData['phone'],
        userImg: userData['userImg'],
        userDeviceToken: userData['userDeviceToken'],
        country: userData['country'],
        userAddress: userData['userAddress'],
        street: userData['street'],
        isAdmin: userData['isAdmin'],
        isActive: userData['isActive'],
        createdOn: userData['createdOn'],
        city: userData['city']);

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('cart')
        .doc(user!.uid)
        .collection('cartOrders')
        .get();

    List<QueryDocumentSnapshot> documents = querySnapshot.docs;
    for (var doc in documents) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>;

      String orderId = orderIdController.generateUniqueId();
      String customerDeviceToken = await getCustomerDeviceToken();
      OrderModel orderModel = OrderModel(
          brandId: data['brandId'],
          brandName: data['brandName'],
          categoryId: data['categoryId'],
          categoryName: data['categoryName'],
          createdAt: DateTime.now(),
          payOption: payOption,
          customerAddress: userModel.userAddress,
          customerStreet: userModel.street,
          noteToRider: noteToRider,
          customerDeviceToken: customerDeviceToken,
          customerId: userModel.uId,
          customerName: userModel.username,
          customerPhone: userModel.phone,
          deliveryTime: data['deliveryTime'],
          fullPrice: data['fullPrice'],
          isSale: data['isSale'],
          productDescription: data['productDescription'],
          productId: data['productId'],
          productImages: data['productImages'],
          productColor: data['productColor'],
          productName: data['productName'],
          productQuantity: data['productQuantity'],
          productTotalPrice: data['productTotalPrice'],
          salePrice: data['salePrice'],
          status: false,
          updatedAt: data['updatedAt']);

      for (var i = 0; i < documents.length; i++) {
        await FirebaseFirestore.instance
            .collection('orders')
            .doc(user.uid)
            .set({
          'uId': user.uid,
          'customerName': userModel.username,
          'createdAt': DateTime.now(),
          'customerAddress': userModel.userAddress,
          'customerStreet': userModel.street,
          'noteToRider': noteToRider,
          'customerDeviceToken': customerDeviceToken,
          'customerPhone': userModel.phone,
        });

        await FirebaseFirestore.instance
            .collection('orders')
            .doc(user.uid)
            .collection('cartOrders')
            .doc(orderId)
            .set(orderModel.toJson());

        await FirebaseFirestore.instance
            .collection('cart')
            .doc(user!.uid)
            .collection('cartOrders')
            .doc((orderModel.productId).toString())
            .delete();
      }
    }
    print("Order Confirmed");
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        'Order Confirmed',
        style: TextStyle(color: currentTheme.colorScheme.surface),
      ),
      backgroundColor: currentTheme.colorScheme.onPrimary,
    ));
    EasyLoading.dismiss();
    Get.off(() => NavigationMenu());
  } catch (e) {
    print("error in placing order :  $e");
    EasyLoading.dismiss();
  }
}
