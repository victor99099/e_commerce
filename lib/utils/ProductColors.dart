import 'package:flutter/material.dart';

class ColorUtils {
  static Color getColorFromName(String colorName) {
    switch (colorName.toUpperCase()) {
      case 'RED':
        return Colors.red;
      case 'BLUE':
        return Colors.blue;
      case 'GREEN':
        return Colors.green;
      case 'YELLOW':
        return Colors.yellow;
      case 'ORANGE':
        return Colors.orange;
      case 'PURPLE':
        return Colors.purple;
      case 'PINK':
        return Colors.pink;
      case 'BROWN':
        return Colors.brown;
      case 'GREY':
        return Colors.grey;
      case 'BLACK':
        return Colors.black;
      case 'WHITE':
        return Colors.white;
      case 'CYAN':
        return Colors.cyan;
      case 'TEAL':
        return Colors.teal;
      case 'INDIGO':
        return Colors.indigo;
      case 'LIME':
        return Colors.lime;
      case 'AMBER':
        return Colors.amber;
      case 'DEEP ORANGE':
        return Colors.deepOrange;
      case 'DEEP PURPLE':
        return Colors.deepPurple;
      case 'LIGHT BLUE':
        return Colors.lightBlue;
      case 'LIGHT GREEN':
        return Colors.lightGreen;
      case 'RED ACCENT':
        return Colors.redAccent;
      case 'BLUE ACCENT':
        return Colors.blueAccent;
      case 'GREEN ACCENT':
        return Colors.greenAccent;
      case 'YELLOW ACCENT':
        return Colors.yellowAccent;
      case 'ROSE GOLD':
        return Color(0xFFDAB8C1); // Custom color for Rose Gold
      case 'BRONZE':
        return Color(0xFFCD7F32); // Custom color for Bronze
      case 'SILVER':
        return Color(0xFFC0C0C0); // Custom color for Silver
      case 'GOLD':
        return Color(0xFFFFD700); // Custom color for Gold
      // Add more colors as needed
      default:
        return Colors.grey; // Default color if not found
    }
  }
}
