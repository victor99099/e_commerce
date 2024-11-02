import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/ReviewIdsController.dart';
import 'package:flutter_application_1/models/product-review-model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class ReviewSheet extends StatelessWidget {
  String productId;
  ReviewSheet({super.key, required this.productId});
  TextEditingController feedbackController = TextEditingController();
  final reviewController = Get.put(ReviewController());

  RxDouble rate = 0.0.obs;

  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 50),
      height: Get.height,
      width: Get.width,
      child: Column(
        children: [
          20.heightBox,
          "What is your rate?".text.xl.bold.make(),
          // 20.heightBox,
          RatingBar.builder(
              glow: false,
              itemPadding: const EdgeInsets.all(5),
              // glowColor: Colors.transparent,
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: currentTheme.colorScheme.onPrimary,
                  ),
              onRatingUpdate: (rating) {
                rate.value = rating;
                

              }),
          10.heightBox,
          TextFormField(
              controller: feedbackController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: "Feedback",
                labelStyle:
                    TextStyle(color: currentTheme.colorScheme.tertiaryFixed),
                prefixIcon: Icon(Icons.feedback,
                    color: currentTheme.colorScheme.onPrimary),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: currentTheme.colorScheme.onTertiary),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                hintStyle:
                    TextStyle(color: currentTheme.colorScheme.tertiaryFixed),
              )).p16(),
          // (Get.height/2).heightBox
          Material(
            color: Colors.transparent,
            child: Container(
              color: Colors.transparent,
              child: TextButton(
                style: ButtonStyle(
                    foregroundColor: const WidgetStatePropertyAll(Colors.transparent),
                    backgroundColor: WidgetStateProperty.all(
                        currentTheme.colorScheme.onPrimary),
                    shape: const WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
                    overlayColor: WidgetStatePropertyAll(
                        currentTheme.colorScheme.primary)),
                onPressed: () {
                  addReview(rating: rate.value, feedback: feedbackController.text, producId: productId);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            'Feedback submitted',
                            style: TextStyle(
                                color: currentTheme.colorScheme.surface),
                          ),
                          backgroundColor: currentTheme.colorScheme.onPrimary,
                        ));

                  Navigator.pop(context);

                },
                child: "Submit"
                    .text
                    .color(currentTheme.colorScheme.surface)
                    .make(),
              ).wh(Get.width * 0.7, Get.height / 14),
            ),
          ).pOnly(top: 20)
        ],
      ),
    );
  }

  Future<void> addReview(
      {
      required double rating,
      required String feedback,
      required String producId}) async {
    String id = reviewController.generateUniqueId();
    User? user = FirebaseAuth.instance.currentUser;

    var snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('uId',isEqualTo: user!.uid).get();

    var userName = snapshot.docs[0]['username'];
    var userImage = snapshot.docs[0]['userImg'];

    ProductReviewModel productReviewModel = ProductReviewModel(
        userName: userName,
        userImage: userImage,
        rating: rating,
        feedback: feedback,
        updatedAt: DateTime.now(),
        productId: productId);
    await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .collection('reviews')
        .doc(id) // Use the generated unique ID
        .set(productReviewModel.toMap());


    print("Product Added");
    
  }
}
