import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/categories-model.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';
import 'package:velocity_x/velocity_x.dart';

import '../screens/user-panel/SingleCatScreen.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance.collection('categories').get(),
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
              child: "No Category Found".text.make(),
            );
          }

          if (snapshot.data != null) {
            return Container(
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.all(0),
              height: Get.height / 7,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    CategoriesModel categoriesModel = CategoriesModel(
                      categoryId: snapshot.data!.docs[index]['categoryId'], 
                      categoryImg: snapshot.data!.docs[index]['categoryImage'], 
                      categoryName: snapshot.data!.docs[index]['categoryName'], 
                      createdAt: snapshot.data!.docs[index]['createdAt'], 
                      updatedAt: snapshot.data!.docs[index]['updatedAt']
                    );
                    return Row(
                      children: [
                        GestureDetector(
                          onTap: ()=> Get.to(()=>SingleCatScreen(categoryId:categoriesModel.categoryId,categoryTitle:categoriesModel.categoryName ,)),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 2,left: 2,top: 2),
                            child: Container(
                              padding: const EdgeInsets.all(0),
                              margin: const EdgeInsets.only(bottom: 0),
                              color: Colors.transparent,
                              child: FillImageCard(
                                contentPadding: const EdgeInsets.all(0),
                                color: Colors.transparent,
                                borderRadius: 20,
                                width: Get.width/4.0,
                                heightImage: Get.height/10,
                                imageProvider: CachedNetworkImageProvider(
                                  categoriesModel.categoryImg
                                ),
                                title: Center(
                                  child: Text(categoriesModel.categoryName,
                                  style:const TextStyle(fontSize: 11,fontWeight: FontWeight.bold,color: Colors.white) ,
                                  ).p0()
                                ).p0(),
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  }),
            );
          }

          return Container();
        });
  }
}
