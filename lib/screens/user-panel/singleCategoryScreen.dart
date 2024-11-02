import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/product-model.dart';
import 'package:flutter_application_1/screens/user-panel/ProductDetailScreen.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';
import 'package:velocity_x/velocity_x.dart';


// ignore: must_be_immutable
class SingleCategoryScreen extends StatefulWidget {
  String categoryTitle;
  String categoryId;
  SingleCategoryScreen(
      {super.key, required this.categoryId, required this.categoryTitle});

  @override
  State<SingleCategoryScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<SingleCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: currentTheme.colorScheme.secondary,
        title: widget.categoryTitle.text.color(Colors.white).bold.make(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            20.heightBox,
            Expanded(
              child: FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('products')
                    .where('categoryId', isEqualTo: widget.categoryId)
                    .get(),
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
                      child: "No Category Found".text.make(),
                    );
                  }

                  if (snapshot.data != null) {
                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 3,
                        crossAxisSpacing: 4,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: snapshot.data!.docs.length,
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
                            padding: const EdgeInsets.all(0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 5,
                              child: Container(
                                padding: const EdgeInsets.only(top: 10),
                                margin: const EdgeInsets.all(0),
                                decoration: BoxDecoration(
                                  color: currentTheme.colorScheme.primary,
                                  border: Border.all(
                                    color: Colors.transparent,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: Center(
                                  child: Hero(
                                    tag: Key(productModel.productId),
                                    child: FillImageCard(
                                      contentPadding:
                                          const EdgeInsets.only(bottom: 0, top: 2),
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
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      footer: Container(
                                        padding: const EdgeInsets.only(top: 5),
                                        height: 22,
                                        child: Row(
                                          children: [
                                            Text(
                                              "Rs ${productModel.salePrice}",
                                              style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 2),
                                            Text(
                                              productModel.fullPrice,
                                              style: TextStyle(
                                                fontSize: 11,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                color: currentTheme
                                                    .colorScheme.onPrimary,
                                              ),
                                            )
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
