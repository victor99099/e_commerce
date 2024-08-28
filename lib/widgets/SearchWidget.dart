import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/user-panel/SearchScreen.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:velocity_x/velocity_x.dart';
// import '../../controllers/SearchController.dart';

class SearchWidget extends StatelessWidget {
  
  SearchWidget({super.key});
  TextEditingController search = TextEditingController();
  SearchController searchController = Get.put(SearchController());
  @override
  Widget build(BuildContext context) {
    
    final getTheme = Theme.of(context);
    return Container(
      margin: EdgeInsets.only(top: 4),
      width: Get.width / 1.1,
      height: Get.height * 0.075,
      child: TextFormField(
        onTap: ()=>Get.to(()=>SearchScreen()),
        controller: search,
        cursorColor: getTheme.colorScheme.primary,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: getTheme.colorScheme.onTertiary),
          filled: true, // Enable filling
          fillColor: getTheme.colorScheme.surface,
          hintText: "Search",
          prefixIcon:
              Icon(Iconsax.search_normal, color: getTheme.colorScheme.primary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: getTheme.colorScheme.surface),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
                color: getTheme.colorScheme.primary), // Default border color
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
                color: getTheme
                    .colorScheme.onTertiary), // Border color when focused
          ),
          contentPadding: EdgeInsets.only(top: 2.0, left: 8.0),
        ),
      ).pOnly(bottom: 0),
    );
  }
}
