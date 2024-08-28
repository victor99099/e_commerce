import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/categories-model.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../models/product-model.dart';
import 'ProductDetailScreen.dart';
import 'singleCategoryScreen.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({super.key});

  @override
  State<AllProductsScreen> createState() => _AllFlashSaleWidgetState();
}

class _AllFlashSaleWidgetState extends State<AllProductsScreen> {
  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: currentTheme.colorScheme.secondary,
        title: "All Products".text.color(Colors.white).bold.make(),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            20.heightBox,
            Expanded(
              child: FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('products')
                    .where("isSale", isEqualTo: false)
                    .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
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
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 3,
                        crossAxisSpacing: 4,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: snapshot.data!.docs.length,
                      padding: EdgeInsets.all(0),
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
                            isBest: productData['isBest'],
                            productDescription:
                                productData['productDescription'],
                            createdAt: productData['createdAt'],
                            updatedAt: productData['updatedAt']);
                        return GestureDetector(
                          onTap: () => Get.to(() =>
                              ProductDetailScreen(productModel: productModel)),
                          child: Padding(
                            padding: EdgeInsets.all(0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              elevation: 5,
                              child: Container(
                                padding: EdgeInsets.only(top: 10),
                                margin: EdgeInsets.all(0),
                                decoration: BoxDecoration(
                                    color: currentTheme.colorScheme.primary,
                                    border:
                                        Border.all(color: Colors.transparent),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Center(
                                  child: Hero(
                                    tag: Key(productModel.productId),
                                    child: FillImageCard(
                                      contentPadding:
                                          EdgeInsets.only(bottom: 0, top: 2),
                                      color: currentTheme.colorScheme.primary,
                                      borderRadius: 20,
                                      width: Get.width / 2.6,
                                      heightImage: Get.height / 5.5,
                                      height: Get.height / 1.2,
                                      imageProvider: CachedNetworkImageProvider(
                                        productModel.productImages[0],
                                      ),
                                      title: Center(
                                        heightFactor: 0.2,
                                        child: Text(
                                          productModel.productName,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      footer: Container(
                                        padding: EdgeInsets.only(top: 5),
                                        height: 22,
                                        child: Row(
                                          children: [
                                            Text(
                                              "Rs ${productModel.fullPrice}",
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
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
}
