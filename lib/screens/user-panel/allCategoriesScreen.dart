import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/user-panel/singleCategoryScreen.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../models/categories-model.dart';

class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({super.key});

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: currentTheme.colorScheme.secondary,
        title: "Categories".text.color(Colors.white).bold.make(),
      ),
      body: Column(
        children: [
          20.heightBox,
          Expanded(
            child: FutureBuilder(
              future: FirebaseFirestore.instance.collection('categories').get(),
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
                    child: "No Category Found".text.make(),
                  );
                }
            
                if (snapshot.data != null) {
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 3,
                      crossAxisSpacing: 3,
                      childAspectRatio: 1.19,
                    ),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      CategoriesModel categoriesModel = CategoriesModel(
                        categoryId: snapshot.data!.docs[index]['categoryId'],
                        categoryImg: snapshot.data!.docs[index]['categoryImage'],
                        categoryName: snapshot.data!.docs[index]['categoryName'],
                        createdAt: snapshot.data!.docs[index]['createdAt'],
                        updatedAt: snapshot.data!.docs[index]['updatedAt'],
                      );
                      return GestureDetector(
                        onTap: ()=>Get.to(()=>SingleCategoryScreen(categoryId:categoriesModel.categoryId,categoryTitle:categoriesModel.categoryName ,)),
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Container(
                            child: Center(
                              child: FillImageCard(
                                borderRadius: 20,
                                width: Get.width / 3,
                                heightImage: Get.height / 7.5,
                                height: Get.height / 2,
                                imageProvider: CachedNetworkImageProvider(
                                  categoriesModel.categoryImg,
                                ),
                                title: Center(
                                  heightFactor: 0.2,
                                  child: Text(
                                    categoriesModel.categoryName,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
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
    );
  }
}
