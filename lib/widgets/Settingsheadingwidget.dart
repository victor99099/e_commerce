import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:velocity_x/velocity_x.dart';

class SettingHeading extends StatelessWidget {
  final String headingTitle;
  final String headingSubtitle;
  final VoidCallback onTap;
  final IconData icon;
  SettingHeading(
      {super.key,
      required this.headingTitle,
      required this.headingSubtitle,
      required this.icon,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: Get.height/10,
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Icon(icon,color: currentTheme.colorScheme.onPrimary,).pOnly(bottom: 20),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    headingTitle,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: currentTheme.colorScheme.tertiary),
                  ),
                  Container(
                    width: Get.width/1.4,
                    child: Text(
                      headingSubtitle,
                      style: TextStyle(
                          color: currentTheme.colorScheme.tertiaryFixed, fontSize: 12,overflow: TextOverflow.fade),
                    ).pOnly(top: 0),
                  )
                ],
              ),
              // GestureDetector(
              //   onTap: onTap,
              //   child: Container(
              //     decoration: BoxDecoration(
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
      ),
    );
  }
}
