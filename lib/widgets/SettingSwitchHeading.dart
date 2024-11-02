import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/app-constant.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class SettingHeadingSwitch extends StatelessWidget {
  final String headingTitle;
  final String headingSubtitle;
  final ValueChanged onTap;
  final IconData icon;
  final bool value;
  const SettingHeadingSwitch(
      {super.key,
      required this.headingTitle,
      required this.headingSubtitle,
      required this.icon,
      required this.onTap,
      required this.value});

  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);
    return Container(
      height: Get.height / 10,
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Icon(
                icon,
                color: currentTheme.colorScheme.onPrimary,
              ).pOnly(bottom: 20),
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
                SizedBox(
                  width: Get.width / 1.8,
                  child: Text(
                    headingSubtitle,
                    style: TextStyle(
                        color: currentTheme.colorScheme.tertiaryFixed,
                        fontSize: 12,
                        overflow: TextOverflow.fade),
                  ).pOnly(top: 0),
                ),
              ],
            ).pOnly(left: 10),
            
            Switch(
              
              thumbColor: WidgetStatePropertyAll(MyTheme.dark),
              // trackColor: WidgetStatePropertyAll(MyTheme.medlight),
              value: value,
              onChanged: onTap,
              inactiveTrackColor: Colors.white,
              trackOutlineColor: WidgetStatePropertyAll(currentTheme.colorScheme.primary),
              // inactiveTrackColor: currentTheme.colorScheme.onPrimary,
            )
          ],
        ),
      ),
    );
  }
}
