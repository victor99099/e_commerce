import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class HeadingWidget extends StatelessWidget {
  final String headingTitle;
  final String headingSubtitle;
  final VoidCallback onTap;
  final String buttonText;
  const HeadingWidget(
      {super.key,
      required this.headingTitle,
      required this.headingSubtitle,
      required this.buttonText,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);
    return Container(
      height: Get.height/12,
      margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  headingTitle,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: currentTheme.colorScheme.tertiary),
                ),
                Text(
                  headingSubtitle,
                  style: TextStyle(
                      color: currentTheme.colorScheme.tertiary, fontSize: 12),
                )
              ],
            ),
            GestureDetector(
              onTap: onTap,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                        color: currentTheme.colorScheme.onPrimary, width: 1.5)),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: buttonText
                        .text
                        .bold
                        .color(currentTheme.colorScheme.onPrimary)
                        .make()),
              ),
            )
          ],
        ),
      ),
    );
  }
}
