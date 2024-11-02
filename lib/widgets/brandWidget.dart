import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/Brand-model.dart';
// import 'package:flutter_application_1/screens/user-panel/singleBrandScreen.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../controllers/BrandProductsCountController.dart';

class BrandWidget extends StatelessWidget {
  const BrandWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.put(ProductController());
    final currentTheme = Theme.of(context);
    return FutureBuilder(
        future: FirebaseFirestore.instance.collection('brand').get(),
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
              child: "No Brand Found".text.make(),
            );
          }

          if (snapshot.data != null) {
            return Container(
              // color: Colors.black,
              margin: const EdgeInsets.all(2),
              padding: const EdgeInsets.all(5),
              // height: Get.height / 7,
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 0,
                    childAspectRatio: 2.5,
                  ),
                  shrinkWrap: true,
                  // scrollDirection: Axis.vertical,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    
                    BrandModel brandModel = BrandModel(
                        brandId: snapshot.data!.docs[index]['brandId'],
                        brandImage: snapshot.data!.docs[index]['brandImage'],
                        brandName: snapshot.data!.docs[index]['brandName'],
                        createdAt: snapshot.data!.docs[index]['createdAt'],
                        updatedAt: snapshot.data!.docs[index]['updatedAt']);

                    int productCount = productController.brandCount[brandModel.brandName] ?? 0;

                    return Container(
                      padding: const EdgeInsets.all(0),
                      margin: const EdgeInsets.all(0),
                      width: Get.width / 2.3,
                      height: Get.height * 0.01,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                                color: currentTheme.colorScheme.onTertiary)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                    width: 40,
                                    height: 50,
                                    child: Image.network(
                                      brandModel.brandImage,
                                      fit: BoxFit.contain,
                                    )).pOnly(left: 5),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        
                                        brandModel.brandName.text.textStyle(const TextStyle(fontWeight: FontWeight.w500))
                                            .make()
                                            .pOnly(left: 10),
                                        Image.asset(
                                          'assets/images/verifiedicon.png', // Replace with your icon path
                                          width: 12,
                                          height: 12,
                                          // color: Colors.white,
                                        ).pOnly(left: 3),
                                      ],
                                    ),
                                    ("$productCount Products")
                                        .text
                                        .textStyle(TextStyle(
                                            fontSize: 8,
                                            color: currentTheme
                                                .colorScheme.tertiaryFixed))
                                        .make()
                                        .pOnly(left: 10)
                                  ],
                                )
                              ]),
                        ),
                      ),
                    );
                  }),
            );
          }

          return Container();
        });
  }
}
