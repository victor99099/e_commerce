import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class HeadingWidgetCat extends StatelessWidget {
  final String headingTitle;
  final String headingSubtitle;
  final VoidCallback onTap;
  final String buttonText;
  HeadingWidgetCat(
      {super.key,
      required this.headingTitle,
      required this.headingSubtitle,
      required this.buttonText,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);
    return Container(
      height: Get.height/24,
      child: Padding(
        padding: EdgeInsets.only(left: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                headingTitle.text.extraBold.textStyle(TextStyle(fontSize: 17)).color(Colors.white).make(),
                // Text(
                //   headingTitle,
                //   style: TextStyle(
                //       fontSize: 17,
                //       fontWeight: FontWeight.w900,
                //       color: currentTheme.colorScheme.surface),
                // ),
              ],
            ),
            // GestureDetector(
            //   onTap: onTap,
            //   child: Container(
                
            //     decoration: BoxDecoration(
            //       color: currentTheme.colorScheme.surface,
            //         borderRadius: BorderRadius.circular(20.0),
            //         border: Border.all(
            //             color: currentTheme.colorScheme.onPrimary, width: 1.5)),
            //     child: Padding(
            //         padding: EdgeInsets.all(8.0),
            //         child: buttonText
            //             .text
            //             .bold
            //             .color(currentTheme.colorScheme.onPrimary)
            //             .make()),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
