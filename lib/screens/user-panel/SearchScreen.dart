import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/SearchResultWidget.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../controllers/SearchController.dart';
import 'cartScreen.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});
  TextEditingController search = TextEditingController();
  final SearcherController searcherController = Get.put(SearcherController());
  RxString sortOption = 'Name'.obs;

  @override
  Widget build(BuildContext context) {
    final getTheme = Theme.of(context);
    return Scaffold(
      backgroundColor: getTheme.primaryColor,
      appBar: AppBar(
        actions: [
          InkWell(
            onTap: () => Get.to(() => CartScreen()),
            child: Icon(CupertinoIcons.cart).pOnly(right: 20),
          ),
        ],
        iconTheme: IconThemeData(color: getTheme.colorScheme.tertiary),
        backgroundColor: Colors.transparent,
        title: "Store".text.color(getTheme.colorScheme.tertiary).bold.make(),
      ),
      body: Column(
        children: [
          // 40.heightBox,
          Row(
            children: [
              Container(
                  margin: EdgeInsets.all(0),
                  padding: EdgeInsets.only(left: 10, right: 10),
                  width: Get.width,
                  height: Get.height * 0.07,
                  child: TextFormField(
                    autofocus: true,
                    onChanged: (text) {
                      searcherController.searchText.value = text;
                    },
                    controller: search,
                    cursorColor: getTheme.colorScheme.primary,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintStyle:
                          TextStyle(color: getTheme.colorScheme.onTertiary),
                      filled: true, // Enable filling
                      fillColor: getTheme.colorScheme.surface,
                      hintText: "Search",
                      prefixIcon: Icon(Iconsax.search_normal,
                          color: getTheme.colorScheme.primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: getTheme.colorScheme.surface),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: getTheme
                                .colorScheme.primary), // Default border color
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: getTheme.colorScheme
                                .onTertiary), // Border color when focused
                      ),
                      contentPadding: EdgeInsets.only(top: 2.0, left: 8.0),
                    ),
                  )).pOnly(top: 10),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                  alignment: Alignment.topRight,
                  width: Get.width * 0.5,
                  height: Get.height * 0.05,
                  child: "Order By :"
                      .text
                      .color(getTheme.colorScheme.tertiaryFixed)
                      .xl
                      .make()),
              Container(
                // color: Colors.black,
                width: Get.width * 0.3,
                height: Get.height * 0.1,
                child: Obx(() {
                  return DropdownButtonFormField<String>(
                    borderRadius: BorderRadius.circular(20),

                    // itemHeight: 25,
                    padding: EdgeInsets.all(0),
                    style: TextStyle(
                        color: getTheme.colorScheme.tertiaryFixed,
                        fontSize: 15),
                    dropdownColor: getTheme.colorScheme.surface,
                    icon: Icon(Iconsax.sort),
                    isDense: true,
                    iconSize: 20,
                    alignment: Alignment.centerLeft,
                    // padding: EdgeInsets.only(left: 219,right: 20,bottom: 10),
                    decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: getTheme.colorScheme
                                .primary, // Custom color for the bottom line when enabled
                            width: 2.0, // Thickness of the bottom line
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: getTheme.colorScheme
                                .primary, // Custom color for the bottom line when focused
                            width: 4.0, // Thickness of the bottom line
                          ),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors
                                .red, // Custom color for the bottom line when there's an error
                            width: 2.0,
                          ),
                        ),
                        contentPadding: EdgeInsets.all(0),
                        fillColor: getTheme.colorScheme.surface,
                        labelStyle: TextStyle(
                            color: getTheme.colorScheme.tertiaryFixed)),
                    value: sortOption.value,
                    items: ['Name', 'Higher Price', 'Lower Price', 'Newest']
                        .map((option) => DropdownMenuItem<String>(
                              child: Text(option),
                              value: option,
                            ))
                        .toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        sortOption.value = newValue;
                      }
                    },
                  );
                }),
              ),
            ],
          ),
          // Divider(endIndent: 20,indent: 20,color: getTheme.colorScheme.tertiaryFixed,),
          Obx(() {
            // Display widget only if search text is not empty
            if (searcherController.searchText.value.isNotEmpty) {
              return Expanded(
                  child: SearchResultWidget(searcherController.searchText.value,
                      sortOption: sortOption.value));
            } else {
              return Container(); // Return an empty container if there's no search text
            }
          }),
        ],
      ),
    );
  }
}
